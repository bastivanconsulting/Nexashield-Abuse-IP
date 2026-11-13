/* NexaShield Abuse IP · tableau de bord. Aucune donnée n'est envoyée : tout est calculé dans le navigateur. */
"use strict";
(() => {
  const RAW = "https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/";
  const REPO = "https://github.com/bastivanconsulting/Nexashield-Abuse-IP/tree/main/";
  const $ = (s) => document.querySelector(s);
  const el = (tag, props = {}, ...kids) => { const e = document.createElement(tag); Object.assign(e, props); kids.forEach((k) => e.append(k)); return e; };

  const T = {
    fr: {
      live: "Données en direct", cta_short: "Protéger mon SI", kicker: "THREAT INTELLIGENCE · OPEN DATA",
      title: "Nous l'avons construit pour nous protéger. Nous le partageons pour vous protéger.",
      lead: "Chaque adresse ci-dessous a réellement attaqué un serveur que nous protégeons. Notre SOC l'a détectée, prouvée et signalée à son hébergeur. Bloquez-la gratuitement, avant qu'elle ne frappe chez vous.",
      check_ph: "Une IP est-elle listée ? ex. 203.0.113.10", check_btn: "Vérifier",
      k_ips: "IP malveillantes", k_cc: "pays", k_asn: "réseaux (ASN)", k_ev: "attaques enregistrées", k_last: "dernière attaque (UTC)",
      map: "D'où viennent les attaques", map_hint: "Survolez un pays", types: "Nature des attaques", timeline: "Nouveaux attaquants par jour",
      top_asn: "Réseaux les plus actifs", ai: "Analyse de la menace par l'IA NexaShield", explore: "Explorer les adresses",
      filter_ph: "Filtrer : IP, pays, opérateur…", all_cc: "Tous les pays", all_cat: "Toutes les natures",
      col_ip: "IP", col_cc: "Pays", col_asn: "Réseau", col_cat: "Nature", col_ev: "Événements", col_last: "Dernière activité",
      use: "Bloquez ces IP en 30 secondes", use_hint: "Mise à jour automatique toutes les heures", copy: "Copier", copied: "Copié ✓",
      guide_fw: "Guide pare-feu →", guide_sw: "Guide logiciels (SIEM, CTI, Kubernetes) →",
      cta_title: "Cette liste n'est que la partie visible.",
      cta_text: "NexaShield détecte et bloque ces attaques sur vos postes, serveurs, conteneurs et votre réseau, reconstitue le déroulé complet d'une attaque et répond en quelques secondes. Notre SOC s'occupe du reste.",
      cta_btn: "Protéger mon infrastructure", foot: "Données publiées sous", repo: "Dépôt GitHub", tag: "Détecter. Corréler. Répondre.",
      listed: (ip, x) => `⚠️ ${ip} est listée : ${x.country}, AS${x.asn || "?"} ${x.asn_org}, ${x.events} événement(s), vue pour la dernière fois le ${x.last_seen}.`,
      notlisted: (ip) => `✓ ${ip} n'est pas dans la liste NexaShield.`, invalid: "Saisissez une adresse IPv4 ou IPv6 valide.",
      shown: (a, b) => `${a} adresse(s) sur ${b}`, ago: (h) => h < 1 ? "il y a moins d'une heure" : h < 48 ? `il y a ${h} h` : `il y a ${Math.round(h / 24)} j`,
      ai_meta: (d) => `générée le ${d} · Mistral AI`, ips: "IP", events: "événements", error: "Impossible de charger les données. Réessayez dans un instant.",
    },
    en: {
      live: "Live data", cta_short: "Protect my company", kicker: "THREAT INTELLIGENCE · OPEN DATA",
      title: "We built it to protect ourselves. We share it to protect you.",
      lead: "Every address below really attacked a server we protect. Our SOC detected it, proved it and reported it to its network owner. Block it for free, before it hits you.",
      check_ph: "Is an IP listed? e.g. 203.0.113.10", check_btn: "Check",
      k_ips: "malicious IPs", k_cc: "countries", k_asn: "networks (ASN)", k_ev: "recorded attacks", k_last: "latest attack (UTC)",
      map: "Where attacks come from", map_hint: "Hover a country", types: "Attack types", timeline: "New attackers per day",
      top_asn: "Most active networks", ai: "Threat analysis by NexaShield AI", explore: "Explore addresses",
      filter_ph: "Filter: IP, country, owner…", all_cc: "All countries", all_cat: "All types",
      col_ip: "IP", col_cc: "Country", col_asn: "Network", col_cat: "Type", col_ev: "Events", col_last: "Last activity",
      use: "Block these IPs in 30 seconds", use_hint: "Automatic hourly updates", copy: "Copy", copied: "Copied ✓",
      guide_fw: "Firewall guide →", guide_sw: "Software guide (SIEM, CTI, Kubernetes) →",
      cta_title: "This list is only the tip of the iceberg.",
      cta_text: "NexaShield detects and blocks these attacks on your endpoints, servers, containers and network, rebuilds the full attack timeline and responds within seconds. Our SOC handles the rest.",
      cta_btn: "Protect my infrastructure", foot: "Data published under", repo: "GitHub repository", tag: "Detect. Correlate. Respond.",
      listed: (ip, x) => `⚠️ ${ip} is listed: ${x.country}, AS${x.asn || "?"} ${x.asn_org}, ${x.events} event(s), last seen ${x.last_seen}.`,
      notlisted: (ip) => `✓ ${ip} is not on the NexaShield list.`, invalid: "Enter a valid IPv4 or IPv6 address.",
      shown: (a, b) => `${a} of ${b} address(es)`, ago: (h) => h < 1 ? "less than an hour ago" : h < 48 ? `${h} h ago` : `${Math.round(h / 24)} days ago`,
      ai_meta: (d) => `generated ${d} · Mistral AI · in French`, ips: "IPs", events: "events", error: "Could not load data. Please retry in a moment.",
    },
  };
  const CATS = {
    fr: { exploit: "Exploitation (CVE, RCE)", waf: "Injection bloquée (WAF)", web: "Requêtes HTTP abusives", ssh: "Force brute SSH", mail: "Force brute SMTP / IMAP",
          c2: "Botnet / C2", spamhaus: "Réseau Spamhaus DROP", scan: "Balayage de ports", udp: "Exploit UDP" },
    en: { exploit: "Exploitation (CVE, RCE)", waf: "Injection blocked (WAF)", web: "Abusive HTTP requests", ssh: "SSH brute force", mail: "SMTP / IMAP brute force",
          c2: "Botnet / C2", spamhaus: "Spamhaus DROP network", scan: "Port scanning", udp: "UDP exploit" },
  };
  const SNIPPETS = {
    Linux: "curl -fsSLO " + RAW + "tools/linux/install.sh\nless install.sh   # lisez avant d'exécuter / read before running\nsudo bash install.sh",
    Windows: '$u = "' + RAW + 'tools/windows"\niwr -UseBasicParsing "$u/Install-NexaShield.ps1" -OutFile Install-NexaShield.ps1\niwr -UseBasicParsing "$u/Update-NexaShieldBlocklist.ps1" -OutFile Update-NexaShieldBlocklist.ps1\npowershell -NoProfile -ExecutionPolicy Bypass -File .\\Install-NexaShield.ps1',
    MikroTik: '/tool fetch url="' + RAW + 'tools/mikrotik/install.rsc" dst-path=nexashield-install.rsc\n/import file-name=nexashield-install.rsc',
    FortiGate: 'config system external-resource\n    edit "NexaShield-Abuse-IP"\n        set type address\n        set resource "' + RAW + 'lists/plain/all.txt"\n        set refresh-rate 60\n    next\nend',
    "pfSense / OPNsense": "Firewall › Aliases › URL Table (IPs)\nURL : " + RAW + "lists/plain/all.txt\nFirewall › Rules › WAN › Block, source = alias",
    Wazuh: "curl -fsSL -o /var/ossec/etc/lists/nexashield-abuse \\\n  " + RAW + "lists/wazuh-cdb.txt\n# ossec.conf <ruleset> : <list>etc/lists/nexashield-abuse</list>",
    CrowdSec: "curl -fsSL -o /tmp/nexashield.json " + RAW + "lists/crowdsec-decisions.json\ncscli decisions import -i /tmp/nexashield.json",
    "OpenCTI / MISP": "STIX 2.1 : " + RAW + "lists/stix2-bundle.json\nFreetext / CSV feed : " + RAW + "lists/plain/all.txt",
  };

  let lang = (() => { try { return localStorage.getItem("ns-lang") || (navigator.language || "fr").slice(0, 2); } catch { return "fr"; } })();
  if (!T[lang]) lang = "en";
  let data = [], byCC = {}, charts = [], map = null, sortKey = "events", sortAsc = false, page = 0, tab = "Linux", aiRaw = null;
  const PER = 15;

  const css = (v) => getComputedStyle(document.documentElement).getPropertyValue(v).trim();
  const slug = (s) => (String(s).replace(/[^A-Za-z0-9]+/g, "-").replace(/^-+|-+$/g, "").slice(0, 48).replace(/-+$/, "") || "Unknown");
  const folder = (x) => `countries/${x.country_code}_${slug(x.country)}/${x.asn ? `AS${x.asn}_${slug(x.asn_org)}` : "AS-Unknown"}/${x.ip.replace(/:/g, "_")}`;
  const fmt = (n) => Number(n).toLocaleString(lang === "fr" ? "fr-FR" : "en-US");
  const catLabel = (k) => CATS[lang][k] || k;
  const validIP = (s) => /^(25[0-5]|2[0-4]\d|1?\d?\d)(\.(25[0-5]|2[0-4]\d|1?\d?\d)){3}$/.test(s) || (/^[0-9a-f:]+$/i.test(s) && s.includes(":") && s.length <= 39);
  const normIP = (s) => { s = s.trim().toLowerCase(); if (!s.includes(":")) return s; try { return new URL(`http://[${s}]/`).hostname.slice(1, -1); } catch { return s; } };

  async function getJSON(p) { for (const u of ["../" + p, RAW + p]) { try { const r = await fetch(u, { cache: "no-cache" }); if (r.ok) return await r.json(); } catch { /* source suivante */ } } throw new Error(p); }
  async function getText(p) { for (const u of ["../" + p, RAW + p]) { try { const r = await fetch(u, { cache: "no-cache" }); if (r.ok) return await r.text(); } catch { /* source suivante */ } } return null; }

  function applyLang() {
    const t = T[lang];
    document.documentElement.lang = lang;
    document.querySelectorAll("[data-i18n]").forEach((e) => { const v = t[e.dataset.i18n]; if (typeof v === "string") e.textContent = v; });
    document.querySelectorAll("[data-i18n-ph]").forEach((e) => { e.placeholder = t[e.dataset.i18nPh]; });
    $("#lang").textContent = lang === "fr" ? "EN" : "FR";
    document.title = lang === "fr" ? "NexaShield Abuse IP · Tableau de bord" : "NexaShield Abuse IP · Dashboard";
    if (data.length) render();
  }

  function render() {
    const t = T[lang];
    const asns = new Set(data.map((x) => `${x.country_code}|${x.asn}`));
    const last = data.map((x) => x.last_seen).filter((v) => v && v !== "n/a").sort().pop() || "";
    $("#k-ips").textContent = fmt(data.length);
    $("#k-cc").textContent = fmt(Object.keys(byCC).length);
    $("#k-asn").textContent = fmt(asns.size);
    $("#k-ev").textContent = fmt(data.reduce((a, x) => a + (+x.events || 0), 0));
    $("#k-last").textContent = last ? new Date(last).toLocaleString(lang === "fr" ? "fr-FR" : "en-GB", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit", timeZone: "UTC" }) : "–";
    if (last) $("#updated").textContent = t.ago(Math.max(0, Math.floor((Date.now() - Date.parse(last)) / 3.6e6)));
    drawCharts(); drawMap(); fillFilters(); drawTable(); drawTabs(); drawAI();
  }

  function drawCharts() {
    charts.forEach((c) => c.destroy()); charts = [];
    const fg = css("--fg"), muted = css("--muted"), line = css("--line");
    Chart.defaults.color = muted; Chart.defaults.borderColor = line; Chart.defaults.font.family = getComputedStyle(document.body).fontFamily;
    const palette = ["#dc2626", "#2563eb", "#7c3aed", "#d97706", "#059669", "#0891b2", "#db2777", "#65a30d", "#64748b"];
    const cats = {}; data.forEach((x) => Object.keys(x.categories || {}).forEach((k) => { cats[k] = (cats[k] || 0) + 1; }));
    const ck = Object.keys(cats).sort((a, b) => cats[b] - cats[a]);
    charts.push(new Chart($("#c-types"), { type: "doughnut",
      data: { labels: ck.map(catLabel), datasets: [{ data: ck.map((k) => cats[k]), backgroundColor: palette, borderColor: css("--panel"), borderWidth: 3 }] },
      options: { maintainAspectRatio: false, cutout: "62%", plugins: { legend: { position: "bottom", labels: { boxWidth: 10, color: fg, padding: 12 } } } } }));
    const days = {}; data.forEach((x) => { const d = (x.first_seen && x.first_seen !== "n/a" ? x.first_seen : x.reported || "").slice(0, 10); if (/^\d{4}-\d\d-\d\d$/.test(d)) days[d] = (days[d] || 0) + 1; });
    const dk = Object.keys(days).sort();
    charts.push(new Chart($("#c-time"), { type: "bar",
      data: { labels: dk, datasets: [{ label: T[lang].ips, data: dk.map((d) => days[d]), backgroundColor: "#2563eb", borderRadius: 6, maxBarThickness: 28 }] },
      options: { maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } }, y: { beginAtZero: true, ticks: { precision: 0 } } } } }));
    const asn = {}; data.forEach((x) => { const k = x.asn || 0; asn[k] = asn[k] || { n: 0, org: x.asn_org }; asn[k].n++; });
    const ak = Object.keys(asn).sort((a, b) => asn[b].n - asn[a].n || a - b).slice(0, 8);
    charts.push(new Chart($("#c-asn"), { type: "bar",
      data: { labels: ak.map((k) => `AS${k} ${String(asn[k].org).slice(0, 22)}`), datasets: [{ label: T[lang].ips, data: ak.map((k) => asn[k].n), backgroundColor: "#7c3aed", borderRadius: 6, maxBarThickness: 22 }] },
      options: { indexAxis: "y", maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true, ticks: { precision: 0 } }, y: { grid: { display: false }, ticks: { color: fg } } } } }));
  }

  function drawMap() {
    const box = $("#map"); box.textContent = "";
    const values = {}; Object.entries(byCC).forEach(([cc, a]) => { values[cc] = a.length; });
    try {
      map = new jsVectorMap({
        selector: "#map", map: "world", zoomButtons: false, zoomOnScroll: false, backgroundColor: "transparent",
        regionStyle: { initial: { fill: css("--map0"), stroke: css("--panel"), strokeWidth: 0.4 }, hover: { fillOpacity: 0.8, cursor: "pointer" } },
        visualizeData: { scale: ["#fecaca", "#b91c1c"], values },
        onRegionTooltipShow(e, tip, code) { const n = values[code] || 0; tip.text(`${tip.text()} : ${n} ${T[lang].ips}`); },
        onRegionClick(e, code) { if (values[code]) { $("#f-cc").value = code; page = 0; drawTable(); $("#tbl").scrollIntoView({ behavior: "smooth", block: "start" }); } },
      });
    } catch { box.textContent = ""; }
  }

  function fillFilters() {
    const t = T[lang], cc = $("#f-cc"), cat = $("#f-cat"), keepCC = cc.value, keepCat = cat.value;
    cc.textContent = ""; cat.textContent = "";
    cc.append(el("option", { value: "", textContent: t.all_cc }));
    Object.keys(byCC).sort((a, b) => byCC[b].length - byCC[a].length).forEach((k) => cc.append(el("option", { value: k, textContent: `${byCC[k][0].country} (${byCC[k].length})` })));
    cat.append(el("option", { value: "", textContent: t.all_cat }));
    Object.keys(CATS.fr).forEach((k) => { if (data.some((x) => x.categories && x.categories[k])) cat.append(el("option", { value: k, textContent: catLabel(k) })); });
    cc.value = keepCC; cat.value = keepCat;
  }

  function rows() {
    const q = $("#f-text").value.trim().toLowerCase(), cc = $("#f-cc").value, cat = $("#f-cat").value;
    let r = data.filter((x) => (!cc || x.country_code === cc) && (!cat || (x.categories && x.categories[cat]))
      && (!q || `${x.ip} ${x.country} ${x.asn_org} AS${x.asn}`.toLowerCase().includes(q)));
    const key = (x) => sortKey === "events" ? +x.events || 0 : sortKey === "cats" ? Object.keys(x.categories || {}).length : String(x[sortKey] || "");
    r.sort((a, b) => { const A = key(a), B = key(b); return (A < B ? -1 : A > B ? 1 : 0) * (sortAsc ? 1 : -1); });
    return r;
  }

  function drawTable() {
    const r = rows(), pages = Math.max(1, Math.ceil(r.length / PER)); page = Math.min(page, pages - 1);
    const tb = $("#tbl tbody"); tb.textContent = "";
    r.slice(page * PER, page * PER + PER).forEach((x) => {
      const tags = el("td"); Object.keys(x.categories || {}).forEach((k) => tags.append(el("span", { className: "tag", textContent: catLabel(k) })));
      tb.append(el("tr", {},
        el("td", { className: "ip" }, el("a", { href: REPO + folder(x), textContent: x.ip, rel: "noopener" })),
        el("td", { textContent: x.country }),
        el("td", { textContent: `AS${x.asn || "?"} ${x.asn_org}` }),
        tags,
        el("td", { className: "num", textContent: fmt(x.events || 0) }),
        el("td", { textContent: (x.last_seen || "").replace("T", " ").replace("Z", "") })));
    });
    document.querySelectorAll("#tbl th").forEach((th) => { th.classList.toggle("sorted", th.dataset.k === sortKey); th.classList.toggle("asc", th.dataset.k === sortKey && sortAsc); });
    $("#count").textContent = T[lang].shown(fmt(r.length), fmt(data.length));
    $("#page").textContent = `${page + 1} / ${pages}`;
    $("#prev").disabled = page === 0; $("#next").disabled = page >= pages - 1;
  }

  function drawTabs() {
    const box = document.querySelector(".tabs"); box.textContent = "";
    Object.keys(SNIPPETS).forEach((k) => {
      const b = el("button", { type: "button", textContent: k }); b.setAttribute("role", "tab"); b.setAttribute("aria-selected", String(k === tab));
      b.addEventListener("click", () => { tab = k; drawTabs(); }); box.append(b);
    });
    $("#snippet").textContent = SNIPPETS[tab];
  }

  function drawAI() {
    if (!aiRaw) return;
    const box = $("#ai-text"); box.textContent = "";
    aiRaw.text.split(/\n\s*\n/).map((p) => p.replace(/\*\*|__|`/g, "").replace(/^\s*[-*]\s+/gm, "• ").replace(/\s*[—–]\s*/g, ", ").trim()).filter(Boolean)
      .forEach((p) => box.append(el("p", { textContent: p })));
    $("#ai-meta").textContent = aiRaw.meta && aiRaw.meta.generated ? T[lang].ai_meta(aiRaw.meta.generated) : "";
    $("#ai").hidden = false;
  }

  function check(ev) {
    ev.preventDefault();
    const t = T[lang], raw = $("#q").value.trim(), res = $("#checkres");
    if (!validIP(raw)) { res.className = "checkres bad"; res.textContent = t.invalid; return; }
    const ip = normIP(raw), x = data.find((d) => d.ip.toLowerCase() === ip);
    res.className = "checkres " + (x ? "bad" : "ok");
    res.textContent = x ? t.listed(ip, x) : t.notlisted(ip);
  }

  function setTheme(next) {
    if (next) { document.documentElement.dataset.theme = next; try { localStorage.setItem("ns-theme", next); } catch { /* stockage indisponible */ } }
    if (data.length) { drawCharts(); drawMap(); }
  }

  async function init() {
    $("#year").textContent = new Date().getFullYear();
    try { const th = localStorage.getItem("ns-theme"); if (th) document.documentElement.dataset.theme = th; } catch { /* stockage indisponible */ }
    $("#lang").addEventListener("click", () => { lang = lang === "fr" ? "en" : "fr"; try { localStorage.setItem("ns-lang", lang); } catch { /* idem */ } applyLang(); });
    $("#theme").addEventListener("click", () => {
      const dark = getComputedStyle(document.documentElement).getPropertyValue("color-scheme").trim() === "dark";
      setTheme(dark ? "light" : "dark");
    });
    matchMedia("(prefers-color-scheme: dark)").addEventListener("change", () => setTheme());
    $("#check").addEventListener("submit", check);
    ["#f-text", "#f-cc", "#f-cat"].forEach((s) => $(s).addEventListener("input", () => { page = 0; drawTable(); }));
    document.querySelectorAll("#tbl th").forEach((th) => th.addEventListener("click", () => {
      if (sortKey === th.dataset.k) sortAsc = !sortAsc; else { sortKey = th.dataset.k; sortAsc = th.dataset.k !== "events" && th.dataset.k !== "last_seen"; }
      drawTable();
    }));
    $("#prev").addEventListener("click", () => { page--; drawTable(); });
    $("#next").addEventListener("click", () => { page++; drawTable(); });
    $("#copy").addEventListener("click", async () => {
      try { await navigator.clipboard.writeText(SNIPPETS[tab]); $("#copy").textContent = T[lang].copied; setTimeout(() => { $("#copy").textContent = T[lang].copy; }, 1500); } catch { /* presse-papiers refusé */ }
    });
    applyLang();
    try {
      data = (await getJSON("lists/abuse-ip.json")).filter((x) => x && typeof x.ip === "string");
    } catch { $("#checkres").className = "checkres bad"; $("#checkres").textContent = T[lang].error; return; }
    byCC = {}; data.forEach((x) => { (byCC[x.country_code] = byCC[x.country_code] || []).push(x); });
    const [txt, meta] = await Promise.all([getText("analysis/latest.md"), getJSON("analysis/meta.json").catch(() => null)]);
    if (txt) aiRaw = { text: txt, meta };
    render();
  }
  init();
})();
