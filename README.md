# GTA VI Cheats – Deutscher Guide

**Live:** https://gta.smarbiz.sbs/  
**Source:** https://github.com/hsdarestani/gtacheat  
**Hosting:** Cloudflare Worker `vicevault-gta` with custom hostname `gta.smarbiz.sbs`.

## Aktueller Stand (19.11.2026) – Redesign v3.0.0
- Deutschsprachiger, mobiloptimierter GTA-VI-Cheat-Guide mit visuell reduzierter Oberfläche, originalem GTA-VI-Bildmaterial und eigenen thematischen SVG-Icons
- Kein Pfeilsymbol in der UI, inklusive Cheat-Eingaben: Steuerkreuz-Tasten werden als OBEN, UNTEN, LINKS und RECHTS ausgeschrieben
- Visuell kompakte Cheat-Karten; Beschreibungen, Bedingungen und Codes erscheinen erst im Detail-Dialog
- **61** GTA-VI-Cheats in fünf Kategorien, **19** veröffentlichte Tastenkombinationen (17 in beiden geprüften Medien, zwei neu nur bei GamesRadar+)
- Bedingungen zur Freischaltung jedes Cheats; unbekannte Codes bleiben ausdrücklich als offen gekennzeichnet
- Filtern nach Kategorie, Suchfunktion, Sortierung, PS5-/Xbox-Auswahl
- Merk- und Freischaltungslisten im Browser via `localStorage` (kein Login)
- Anleitung, Leonida-Bereich, Quellenhinweise und offizielle GTA-VI-Promobilder von Rockstar Games
- Installierbare PWA mit Browser-Offline-Cache
- Live-Healthcheck: `/health` — `gtavi-de` v3.0.0
- **Keine GTA-V-Codes, kein PC-Port, keine In-App-Zahlung**.

## Originalquellen
- GamesRadar+: https://www.gamesradar.com/games/grand-theft-auto/gta-6-cheats/
- PowerPyx: https://www.powerpyx.com/gta-6-all-cheats/
- Rockstar Games (offizielle Medien): https://www.rockstargames.com/VI/media/screenshots
- Rockstar Release: https://www.rockstargames.com/de/newswire/article/39akk424a9oo53/grand-theft-auto-vi-now-available

Cheat-Codes sind faktische Eingaben; alle Beschreibungen und Bedienhinweise sind eigenständig in deutscher Sprache verfasst. **Wir haben nicht persönlich sämtliche Eingaben im Spiel getestet.** Cheats sind laut Guides erst nach Abschluss der Story und jeweiliger Freischaltung nutzbar.

## Lizenz / geistiges Eigentum
Inoffizieller Fan-Guide; keine Verbindung zu Rockstar Games oder Take-Two. Marken und offizielle Screenshots gehören den Rechteinhabern. Das Einbinden offizieller Rockstar-Grafiken in ein **kommerzielles Produkt** kann eine separate Lizenz erfordern; eine Quellenangabe allein ersetzt diese nicht. Vor Monetarisierung Bild- und Markenrechte prüfen: https://support.rockstargames.com/articles/7bNaeoMFTV0iUDGhStTXvz/policy-on-posting-copyrighted-rockstar-games-material.

## Deployment
Die Worker-Datei `src/worker.js` wird direkt auf Cloudflare als ES-Module-Worker veröffentlicht; das Custom Domain Mapping ist bereits eingerichtet. Die GitHub-Repositoryversion ist die Referenzquelle; aktuell besteht **kein automatisches GitHub-Deployment**. Änderungen müssen ausdrücklich erneut über Cloudflare veröffentlicht werden. Cloudflare-Konto/Zone sind vorhanden.

## Teststatus
Browser Rendering nach v3 bei 390 px geprüft: 61 Karten, Suche, Kategorien, Konsolenwechsel, Favoriten, Detail-Dialog, Codeanzeige ohne Pfeilsymbole, Freischaltungen, Anleitung, Leonida und Quellen erfolgreich. Keine horizontale Überbreite bei 390 px. Der `/health`-Endpunkt wurde beim initialen Deployment validiert; erneute Prüfung für v2 vorgesehen.
