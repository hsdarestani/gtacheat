# ViceVault — GTA Cheats & Guides

An original, fast, responsive fan-made GTA companion built for Cloudflare Workers. Live target: **https://gta.smarbiz.sbs/**

## Features
- Searchable GTA V Story Mode cheat database (34 cheats), with PC commands and dialable phone numbers for modern PlayStation / Xbox consoles
- Instant game / platform / category navigation, favorites stored in the browser, copy-to-clipboard
- Expanded usage details for important cheats; instructions and warnings
- GTA VI launch tracker that does **not** invent or republish unverified GTA VI cheat codes
- Mobile-first responsive UI, installable PWA and basic offline cache, no account needed
- Simple health check at `/health`

## Architecture
Single Cloudflare Worker module at `src/worker.js`. No backend database, paid subscriptions, third-party tracking, or user accounts in MVP. Content is versioned in source code.

## Deployment
Worker name: `vicevault-gta`; Cloudflare custom hostname: `gta.smarbiz.sbs`. This version was directly deployed using the connected Cloudflare account. Future GitHub commits are **not automatically deployed**; use the Cloudflare API / CLI or explicitly configure deployment credentials in GitHub Actions.

## Data notes
GTA V command and phone-number facts cross-checked against [PC Gamer](https://www.pcgamer.com/gta-5-cheats/) and [GTA BOOM](https://www.gtaboom.com/every-gta-5-cheat-console-code-and-phone-number-0740/). No third-party screenshots or copied editorial writing. Additional vehicle-spawn codes have unlock requirements. GTA VI codes require independent verification before publication.

## Disclaimer
Independent, unofficial fan project. Not affiliated with, sponsored by, or endorsed by Rockstar Games or Take-Two Interactive. GTA and related names are trademarks of their respective owners.
