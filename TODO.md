# TODO — host kfzapp for free on Cloudflare Pages

## Goal
Deploy the app to Cloudflare Pages (free tier: unlimited bandwidth, 500 builds/mo,
free SSL). URL will be `https://<project>.pages.dev`. A custom domain (e.g. `kfzapp.de`)
is NOT free — the name itself costs ~€10–15/yr (can be bought via Cloudflare Registrar
at cost); DNS + hosting + cert stay free.

## Build from a clean checkout — DONE (`./build.sh` → `dist/`)

Reproducible build exists and is verified locally (`rm -rf dist && ./build.sh`):
`elm make src/Main.elm --optimize --output=dist/elm.js` plus copies of
`src/main.css`, `assets/index.html`, `assets/manifest.webmanifest`,
`assets/sw.js` and `assets/icons/`. If `elm` is missing (e.g. on Pages),
the script fetches the official Elm 0.19.2 Linux binary (not on npm).
The app is an installable offline-first PWA (plate icons, service worker).

## Connect Cloudflare Pages
1. Sign up at https://dash.cloudflare.com (no credit card needed).
2. Workers & Pages → Create → Pages → Connect to Git → select `pelgero/kfzapp`.
3. Build settings: Framework preset = None,
   Build command = `./build.sh` (or npm script),
   Build output directory = `dist`.
4. Deploy → app is live at `https://<project>.pages.dev`.
   Every push to `master` redeploys automatically.

## Optional: custom domain
1. Buy the domain (Cloudflare Registrar or any registrar).
2. Pages project → Custom domains → Set up a custom domain → follow DNS steps.
3. Certificate is provisioned automatically.
