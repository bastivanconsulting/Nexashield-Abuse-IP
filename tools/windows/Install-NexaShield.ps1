<#
.SYNOPSIS
  Installe le blocage NexaShield Abuse IP sur Windows, avec mise à jour automatique toutes les heures.
  Installs NexaShield Abuse IP blocking on Windows, with automatic hourly updates.
.DESCRIPTION
  - Copie Update-NexaShieldBlocklist.ps1 dans C:\ProgramData\NexaShield
  - Crée la tâche planifiée "NexaShield Abuse IP" (SYSTEM, au démarrage puis toutes les heures)
  - Applique la liste immédiatement (règles Windows Defender Firewall entrée et sortie)
  Exceptions : C:\ProgramData\NexaShield\allowlist.txt (une IP par ligne, jamais bloquée).
.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-NexaShield.ps1
.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-NexaShield.ps1 -Uninstall
.NOTES
  NexaShield EDR · XDR · NDR · MDR · Bastivan Consulting · https://bastivan.com
#>
#Requires -RunAsAdministrator
[CmdletBinding()]
param([switch]$Uninstall)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Dir = Join-Path $env:ProgramData "NexaShield"
$Script = Join-Path $Dir "Update-NexaShieldBlocklist.ps1"
$Task = "NexaShield Abuse IP"
$Src = "https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/tools/windows/Update-NexaShieldBlocklist.ps1"

if ($Uninstall) {
    Unregister-ScheduledTask -TaskName $Task -Confirm:$false -ErrorAction SilentlyContinue
    Get-NetFirewallRule -DisplayName "NexaShield Abuse IP (*)" -ErrorAction SilentlyContinue | Remove-NetFirewallRule
    Remove-Item $Script -ErrorAction SilentlyContinue
    Write-Output "NexaShield : désinstallé (la liste d'exceptions est conservée) / uninstalled."
    return
}

New-Item -ItemType Directory -Force $Dir | Out-Null
# Dossier réservé aux administrateurs et à SYSTEM : la tâche s'exécute en SYSTEM, le script ne doit pas être modifiable par un utilisateur.
icacls $Dir /inheritance:r /grant:r "*S-1-5-18:(OI)(CI)F" "*S-1-5-32-544:(OI)(CI)F" | Out-Null
$local = Join-Path $PSScriptRoot "Update-NexaShieldBlocklist.ps1"
if ($PSScriptRoot -and (Test-Path $local)) { Copy-Item $local $Script -Force }
else { Invoke-WebRequest -UseBasicParsing -Uri $Src -OutFile $Script -TimeoutSec 60 }
$allow = Join-Path $Dir "allowlist.txt"
if (-not (Test-Path $allow)) { Set-Content $allow "# Une IP par ligne : jamais bloquée / one IP per line, never blocked" -Encoding UTF8 }

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$Script`""
$hourly = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(5) -RepetitionInterval (New-TimeSpan -Hours 1)
$boot = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 10) -MultipleInstances IgnoreNew
Register-ScheduledTask -TaskName $Task -Action $action -Trigger $hourly, $boot -Settings $settings `
    -User "SYSTEM" -RunLevel Highest -Description "Met à jour le blocage NexaShield Abuse IP toutes les heures" -Force | Out-Null

& $Script
Write-Output ""
Write-Output "  NexaShield Abuse IP est actif / is active."
Write-Output "  Mise à jour automatique : toutes les heures (tâche planifiée '$Task')"
Write-Output "  Exceptions / allowlist : $allow"
Write-Output "  Désinstaller           : .\Install-NexaShield.ps1 -Uninstall"
Write-Output ""
Write-Output "  Détection et réponse complètes (EDR · XDR · NDR · MDR) : contact@bastivan.com · https://bastivan.com"
