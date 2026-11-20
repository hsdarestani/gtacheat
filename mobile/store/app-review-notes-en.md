# App Review Notes — Vice Codes – Spielhilfe (iOS 1.0.0)

Status: Draft for App Store Connect review information. **Do not resubmit until the genuine physical-iPhone screen recording has been captured, uploaded and linked.** These notes describe the native Flutter mobile app, not the separate GTA VI web site.

## Apple Guideline 2.1 — requested information

1. **Physical-device video (required):** [INSERT A DIRECTLY ACCESSIBLE LINK TO AN UNEDITED SCREEN RECORDING OF THE SUBMITTED BUILD RUNNING ON A PHYSICAL IPHONE WITH THE LATEST IOS VERSION]. The recording must start with the app being launched and demonstrate search, selecting PlayStation 5 / Xbox, category filters, opening a code, marking as favorite, marking as complete, copying/sharing, and the Help / Info tabs. Record the same submitted build (iOS 1.0.0, Build 2) or update this document for a replacement build. Do not substitute an iOS simulator recording.

2. **Purpose and target audience:** Vice Codes is an independent German-language, unofficial companion reference for players seeking published GTA VI directional cheat codes on PlayStation 5 and Xbox. It organizes 19 researched codes with categories, unlock requirements, searchable descriptions, a favorites list, and on-device progress tracking. It is a reference guide, not a game, and is not affiliated with Rockstar Games or Take-Two Interactive. The app explicitly notes that the input combinations have not all been independently tested in-game.

3. **How to access and test:** Install the submitted build and open Vice Codes. No account registration, login, demo credentials, or sample files are needed. The Cheats tab shows the offline database. Select a console, search by keyword, and filter by category. Tap a card to read the description, unlock requirement and input sequence. Inside the details sheet tap Merken to save a favorite, Markieren to track completion, Kopieren to copy the sequence or Teilen to share it. Use the Merkliste tab to view favorites and the Hilfe and Info tabs for instructions and disclosure/source links. There is no in-app purchase or paid content, and no user-generated content.

4. **External services, tools and platforms:** The core content is bundled with the native Flutter app and operates offline; local favorites and progress are stored on the device using shared_preferences. The system's native share sheet and clipboard are used for sharing and copying. The optional Info tab contains outbound links to GamesRadar+ and PC Gamer as source references and to our own privacy-policy and support pages at gta.smarbiz.sbs. No external authentication, payment processor, AI system or network data provider is needed for the core functionality.

5. **Regional differences:** The same German-language offline content and features are available in all supported regions. No geolocation or regional feature gating is implemented.

6. **Third-party rights and game references:** This is an independent, unofficial guide. The submitted Flutter app uses its own UI, app icon and built-in category icons; the source project does not bundle Rockstar screenshots, gameplay videos, game music or official logos. The game name is referenced to identify the subject of the guide, with an explicit non-affiliation disclosure. Public guides are referenced as sources. This is not a claim of a license or endorsement from the rights holders. Review any relevant trademark/content-rights requirements before resubmission; provide documentation if Apple requests it.

## Submission checklist

- [ ] Record the **actual submitted build** on a **physical iPhone** with up-to-date iOS, beginning at the launcher and demonstrating all main flows.
- [ ] Upload the video to a stable share link accessible to Apple reviewers without login, then insert it above.
- [ ] Independently verify build 1.0.0 (2) on an actual iPhone and ensure no crashes or layout defects.
- [ ] Verify actual App Store Connect screenshots reflect the app UI (iPad/iPhone as applicable), including the separately failing screenshot automation.
- [ ] Confirm live privacy/support destinations, release metadata and any required content rights.
- [ ] Paste this information, with the real video link, into App Store Connect > App Review Information > Notes; then resubmit and verify the review status.

Apple rejection message received Nov 20, 2026. Submission ID: cf4efe59-f498-405c-944b-7333a0a93883.
