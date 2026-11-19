# GTA VI Cheats – Deutscher Guide

**Live:** https://gta.smarbiz.sbs/  
**Source:** https://github.com/hsdarestani/gtacheat  
**Hosting:** Cloudflare Worker `vicevault-gta` with custom hostname `gta.smarbiz.sbs`.

## Aktueller Stand (19.11.2026) – Release v3.2.4 (Refresh-Loop behoben)
- Deutschsprachiger, mobiloptimierter GTA-VI-Cheat-Guide mit visuell reduzierter Oberfläche, originalem GTA-VI-Bildmaterial und eigenen thematischen SVG-Icons
- Kein Pfeilsymbol in der UI, inklusive Cheat-Eingaben: Steuerkreuz-Tasten werden als OBEN, UNTEN, LINKS und RECHTS ausgeschrieben
- Visuell kompakte Cheat-Karten; Beschreibungen, Bedingungen und Codes erscheinen erst im Detail-Dialog
- **19 GTA-VI-Cheats mit Tastenkombination** in fünf Kategorien; **42 Einträge ohne Code vollständig entfernt** (alle 19 Einträge mit GamesRadar+ und PC Gamer (19.11.) abgeglichen; weiterhin kein Nachweis für mehr als 19 veröffentlichte Tastenkombinationen)
- Alle sichtbaren Cheats haben vollständige D-Pad-Eingaben; ohne Eingabe erscheinen weder Karten noch Detailansichten. Unterschiedliche Angaben über Freischaltbedingungen werden als solche gekennzeichnet.
- Filtern nach Kategorie, Suchfunktion, Sortierung, PS5-/Xbox-Auswahl
- Merk- und Freischaltungslisten im Browser via `localStorage` (kein Login); bestehende Favoriten/Freischaltungen aus v3 werden über die ursprünglichen 61 Datensatz-Indizes sicher in v3.1 migriert
- Anleitung, Leonida-Bereich, Quellenhinweise und offizielle GTA-VI-Promobilder von Rockstar Games
- Installierbare PWA mit Browser-Offline-Cache
- Live-Healthcheck: `/health` — `gtavi-de` v3.2.4
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
- Die veröffentlichten Codes sind am 19.11.2026 mit [GamesRadar+](https://www.gamesradar.com/games/grand-theft-auto/gta-6-cheats/) und [PC Gamer](https://www.pcgamer.com/games/grand-theft-auto/gta-6-cheats-list/) abgeglichen; zusätzliche Code-Kandidaten ohne reproduzierbare Eingabe wurden nicht hinzugefügt.
- Im Release v3.2 wurden die mobile Modaldarstellung, das Favoriten-Redraw, die alte PWA-Cache-Version und automatische Aktualisierungsprüfungen über `/health` korrigiert.
- Die vier offiziellen Bilder werden mit begrenzter Breite angefragt (`imwidth=1280` statt `3840`). **Nicht alle Cheats wurden in einer echten GTA-VI-Spielsitzung durchgespielt; das kann der Web-Browser-Test nicht ersetzen.**

## Cache und alte Tabs – Hotfix v3.2.4
Der vorherige automatische Versionsabgleich navigierte bei einer inkonsistenten Release-Version ständig neu; ein älterer Service Worker navigierte ebenfalls Tabs bei Aktivierung. Dieser ungewollte Reload-Loop wurde behoben: **kein `location.replace` im Client, kein `clients.navigate` im Service Worker.** Der neue Service Worker räumt alte App-Caches beim Aktivieren ab und lädt Seiten nur noch über die Netzwerkverbindung. Es gibt keine automatische Aktualisierung bereits geöffneter Tabs mehr. Ein einmaliger Hard-Reload kann bei Nutzern mit dem alten Worker notwendig sein. Stand: 19.11.2026.

## Verbleibende Grenzen
Es wurden keine weiteren glaubwürdig dokumentierten GTA-VI-Cheat-Inputs über die 19 vorhanden hinaus gefunden (Recherchestand 19.11.2026). Der Live-Browser-QA prüft die Website, nicht die tatsächliche Eingabe der Cheats auf PlayStation/Xbox. Zusätzliche E2E-Tests für Desktop konnten im Cloudflare-Browser zwischenzeitlich wegen Laufzeitgrenzen nicht vollständig abgeschlossen werden; mobile Testbreiten 340 und 440 px bestanden.
