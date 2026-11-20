# Vice Codes — Erstregistrierung in App Store Connect und Google Play Console

Stand: 20. November 2026. **App owner: A+ Solution GmbH**. Status: Android AAB und iOS IPA wurden in A+ Publisher bereits erfolgreich gebaut. Neue Store-App-Records sind von Build-Artifacts und Publisher-Releases zu unterscheiden. Originale Screenshots stehen nach erfolgreicher Flutter-CI im Artifact `vice-codes-store-screenshots` bereit.

## Gemeinsame Daten

| Feld | Wert |
| --- | --- |
| Öffentlicher Markenname | **Vice Codes** |
| Empfehlungsname im Store | **Vice Codes – Spielhilfe** |
| Beschreibung | Unabhängiger, deutschsprachiger GTA-VI-Fan-Guide |
| Primäre Sprache | Deutsch (Deutschland) |
| Android Package ID | `de.smarbiz.vicecodes` |
| Apple Bundle ID | `de.smarbiz.vicecodes` |
| Version | `1.0.0` |
| Preis | Kostenlos, keine In-App-Käufe |
| Ads | Keine |
| Benutzerkonto | Nein |
| Datenbank | 19 veröffentlichte Eingaben, Offline-Nutzung |
| Datenschutz | https://gta.smarbiz.sbs/privacy |
| Support | https://gta.smarbiz.sbs/support |
| Website | https://gta.smarbiz.sbs/ |
| Entwickler / Rechteinhaber der App | A+ Solution GmbH |
| Verbindung zu Rockstar / Take-Two | **Keine** |

**Rechtlicher Hinweis:** Der App-Name und das App-Icon sollen weder das Rockstar-Logo noch die GTA-Marke als eigene Marke benutzen. Die Beschreibung nennt das Zielspiel rein sachlich. Die eingebetteten Spielinformationen sind nach journalistischen Quellen recherchiert. Offizielle Zulassung oder Nutzungsrechte an fremden Marken/Materialien werden nicht behauptet. Vor Einreichung die App-Store-Prüfung zu Markenrechten und Mindestfunktionalität durchführen.

## App Store Connect: Neuer App-Datensatz (einmalig manuell in der Weboberfläche)

https://appstoreconnect.apple.com/apps

1. **Apps** öffnen → **+ / New App** → Plattform **iOS**.
2. **Name:** Vice Codes – Spielhilfe.
3. **Primary Language:** German (Germany).
4. **Bundle ID:** `de.smarbiz.vicecodes` — diesen Identifier hat Publisher bereits für die iOS-Signatur bei Apple angelegt.
5. **SKU:** `VICECODES-IOS-001` (falls verfügbar).
6. **User Access:** Full Access.
7. **Create**. App-Record zuerst erstellen, bevor das bereits gebaute IPA über Publisher zu TestFlight hochgeladen wird.
8. Danach mindestens diese Pflichtfelder pflegen: Support und Privacy URLs, deutsche Beschreibung und Untertitel, Altersfreigabe-Fragebogen, Export-Compliance, Datenschutz-Antworten, Screenshots der tatsächlich gerenderten App, Review-Kontakt.
9. In Publisher Release **#39** den macOS-Upload `upload_apple` erst nach Vorliegen des Apple-App-Records starten. Das Laden nach App Store Connect ist NICHT die Veröffentlichung.
10. Erst TestFlight intern testen, dann `submit_apple` starten (manuelle Freigabe, keine automatische Live-Veröffentlichung).

Offizielle Apple-Anleitung: https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app/

## Google Play Console: Neue Android-App (einmalig manuell in der Weboberfläche)

https://play.google.com/console/

1. **All apps** → **Create app**.
2. **App name:** Vice Codes – Spielhilfe. **Default language:** Deutsch (Deutschland).
3. **App or game:** App. **Free or paid:** Free. Acknowledge declarations as appropriate after reading them.
4. Create app. Fülle die Datenschutz-/Data-Safety-Erklärung ehrlich anhand der App und aller verwendeten SDKs aus (kein Login, keine In-App-Käufe, keine Werbe-SDKs, Favoriten lokal).
5. **Store listing:** deutsche Beschreibungen und echte Android-App-Screenshots sowie 1024×500 Feature Graphic; die installierte App samt Altersfreigabe und Zielgruppe korrekt deklarieren.
6. **Testing → Internal testing:** aus A+ Publisher den bereits signierten AAB der Version 1.0.0 hochladen; der bei Google erstmals verarbeitete Bundle-Identifier muss `de.smarbiz.vicecodes` sein. Google Play App Signing aktivieren und die upload-key Zuordnung beachten.
7. Nach erfolgreichem internem Test zur Produktionsfreigabe übergehen. Nicht unbeabsichtigt direkt in Production veröffentlichen.
8. Wenn die Google-Play-Publishing-API die App noch nicht findet: Erstregistrierung in der **Weboberfläche** ist erforderlich; das Publisher-API kann diese nicht ersetzen.

Offizielle Google-Anleitung: https://support.google.com/googleplay/android-developer/answer/9859152

## Deutsche Store-Texte (Copy-ready)

**Kurztitel:** Vice Codes – Spielhilfe

**Untertitel (iOS):** Codes offline nachschlagen

**Kurzbeschreibung (Google):** Unabhängiger GTA-VI-Guide mit Offline-Codes, Suche und Favoriten.

**Lange Beschreibung:**

Vice Codes ist ein unabhängiger deutschsprachiger Fan-Guide für GTA VI.

• 19 recherchierte Cheat-Tastenkombinationen für PS5 und Xbox Series
• Offline-Suche und Kategorien für schnellen Zugriff
• Freischaltbedingungen zu den einzelnen Einträgen
• Favoriten und Spielfortschritt werden lokal auf deinem Gerät gespeichert
• Codes kopieren und mit anderen teilen
• Keine Anmeldung, keine Werbung und keine In-App-Käufe

Die Eingaben wurden aus veröffentlichten Spiele-Guides zusammengestellt; eine offizielle Verifizierung durch Rockstar Games liegt nicht vor. Keine Verbindung zu Rockstar Games oder Take-Two Interactive.

**Review-Notiz (iOS):** Die App benötigt keinen Account. Zur Prüfung bitte Offline-Modus aktivieren und Suche, Kategorien, Favoriten, Detailanzeige und Kopieren/Teilen testen. Favoriten und Fortschritt verbleiben lokal. Es handelt sich um einen nicht offiziellen Fan-Guide ohne In-App-Käufe oder Werbung. Der App-Inhalt ist von Rockstar/Take-Two unabhängig zusammengestellt.

## Rückfragen/Blocker

- Rechtefreigabe für fremde Marken/Assets wird **nicht** behauptet; notfalls eigene Grafiken und redaktionelle Marke statt GTA-Markensymbole.
- Apple Guideline 4.2 kann einen reinen Spielguide trotz nativer Bedienung als zu wenig Funktionalität zurückweisen.
- Erstregistrierung der Apple-/Google-App-Records kann nicht allein durch vorhandene Publisher-API-Credentials erfolgen; dafür wird einmaliger Zugriff auf die jeweilige Store-Weboberfläche benötigt.
- Die App-Datenschutz- und Altersfreigabe-Fragebögen sind wahrheitsgemäß durch den Kontoinhaber zu bestätigen; keine ungeprüften Erklärungen automatisieren.
