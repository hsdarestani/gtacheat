# GTA VI Cheats – Deutscher Guide

**Live:** https://gta.smarbiz.sbs/  
**Source:** https://github.com/hsdarestani/gtacheat  
**Hosting:** Cloudflare Worker `vicevault-gta` with custom hostname `gta.smarbiz.sbs`.

## Aktueller Stand (19.11.2026) – Release v3.1.0 (nur Codes mit Eingabe)
- Deutschsprachiger, mobiloptimierter GTA-VI-Cheat-Guide mit visuell reduzierter Oberfläche, originalem GTA-VI-Bildmaterial und eigenen thematischen SVG-Icons
- Kein Pfeilsymbol in der UI, inklusive Cheat-Eingaben: Steuerkreuz-Tasten werden als OBEN, UNTEN, LINKS und RECHTS ausgeschrieben
- Visuell kompakte Cheat-Karten; Beschreibungen, Bedingungen und Codes erscheinen erst im Detail-Dialog
- **19 GTA-VI-Cheats mit Tastenkombination** in fünf Kategorien; **42 Einträge ohne Code vollständig entfernt** (17 bei GamesRadar+ und PowerPyx dokumentiert, 2 nur bei GamesRadar+ gemeldet)
- Alle sichtbaren Cheats haben vollständige D-Pad-Eingaben; ohne Eingabe erscheinen weder Karten noch Detailansichten. Unterschiedliche Angaben über Freischaltbedingungen werden als solche gekennzeichnet.
- Filtern nach Kategorie, Suchfunktion, Sortierung, PS5-/Xbox-Auswahl
- Merk- und Freischaltungslisten im Browser via `localStorage` (kein Login); bestehende Favoriten/Freischaltungen aus v3 werden über die ursprünglichen 61 Datensatz-Indizes sicher in v3.1 migriert
- Anleitung, Leonida-Bereich, Quellenhinweise und offizielle GTA-VI-Promobilder von Rockstar Games
- Installierbare PWA mit Browser-Offline-Cache
- Live-Healthcheck: `/health` — `gtavi-de` v3.1.0
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

## Teststatus (Live-Domain, 19.11.2026)
- Cloudflare Browser Rendering: **390 px mobile** ohne horizontalen Überlauf; 19 Karten, Suche, Kategorie-Filter, Xbox-Auswahl, Favoriten, Dialog, Freischaltung, Anleitung und Quellen geprüft.
- **1365 px desktop** ohne Überlauf; 19 Karten und alle fünf Kategorien geprüft.
- Datenmigration geprüft: ältere Indizes `[4,7,20,21,58,58]` werden zu `[4,5,11,18]` (nicht mehr existierende und doppelte Einträge fallen weg), vorhandene Daten bleiben erhalten.
- Copy-to-Clipboard im echten Browser mit instrumentierter Clipboard-API geprüft. Eingabe wird als `OBEN · RECHTS · UNTEN · LINKS ...` kopiert.
- Die veröffentlichten Codes sind mit journalistischen Guides abgeglichen. **Nicht alle Cheats wurden in einer echten GTA-VI-Spielsitzung durchgespielt; das kann der Web-Browser-Test nicht ersetzen.**
