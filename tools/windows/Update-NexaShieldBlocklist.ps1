<#
.SYNOPSIS
  Bloque dans le pare-feu Windows (Windows Defender Firewall) les IP malveillantes publiées par NexaShield.
.DESCRIPTION
  Télécharge la liste https://github.com/bastivanconsulting/Nexashield-Abuse-IP, vérifie chaque adresse,
  puis remplace les règles "NexaShield Abuse IP (In)" et "(Out)". À exécuter en administrateur.
  Planification quotidienne (PowerShell administrateur) :
    $a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument '-NoProfile -ExecutionPolicy Bypass -File "C:\NexaShield\Update-NexaShieldBlocklist.ps1"'
    $t = New-ScheduledTaskTrigger -Daily -At 6am
    Register-ScheduledTask -TaskName "NexaShield Abuse IP" -Action $a -Trigger $t -User "SYSTEM" -RunLevel Highest
.NOTES
  NexaShield EDR / XDR / NDR / MDR · Bastivan Consulting · https://bastivan.com
#>
#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [string]$Url = "https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt",
    [string]$RuleName = "NexaShield Abuse IP",
    [string]$AllowList = (Join-Path $env:ProgramData "NexaShield\allowlist.txt"),
    [int]$Minimum = 10
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$allow = @{}
if (Test-Path $AllowList) {
    foreach ($a in Get-Content $AllowList) { $a = $a.Trim(); if ($a -and -not $a.StartsWith("#")) { $allow[$a] = $true } }
}
$raw = (Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec 60).Content
$ips = @()
foreach ($line in ($raw -split "`r?`n")) {
    $l = $line.Trim()
    $parsed = $null
    if ($l -and [System.Net.IPAddress]::TryParse($l, [ref]$parsed) -and -not $allow.ContainsKey($parsed.ToString())) { $ips += $parsed.ToString() }
}
# Garde-fou : une liste anormalement courte (téléchargement tronqué) n'est jamais appliquée.
if ($ips.Count -lt $Minimum) { throw "Liste trop courte ($($ips.Count)) : aucune règle modifiée." }

foreach ($dir in "Inbound", "Outbound") {
    $name = "$RuleName ($(@{Inbound = 'In'; Outbound = 'Out'}[$dir]))"
    Get-NetFirewallRule -DisplayName $name -ErrorAction SilentlyContinue | Remove-NetFirewallRule
    New-NetFirewallRule -DisplayName $name -Direction $dir -Action Block -RemoteAddress $ips `
        -Profile Any -Description "IP malveillantes NexaShield (Bastivan Consulting) - mise à jour $(Get-Date -Format s)" | Out-Null
}
Write-Output "NexaShield : $($ips.Count) adresse(s) bloquée(s) en entrée et en sortie."
