# TODO — host kfzapp for free on Cloudflare Pages

## Goal
Deploy the app to Cloudflare Pages (free tier: unlimited bandwidth, 500 builds/mo,
free SSL). URL will be `https://<project>.pages.dev`. A custom domain (e.g. `kfzapp.de`)
is NOT free — the name itself costs ~€10–15/yr (can be bought via Cloudflare Registrar
at cost); DNS + hosting + cert stay free.

## Problem to solve first
`build/` (index.html, elm.js, main.css) is gitignored, so Pages must build from source.
Before connecting the repo, make the build reproducible from a clean checkout:

1. Move `build/index.html` to a tracked template, e.g. `assets/index.html`
   (or generate it in the build script).
2. Add a build script (e.g. `build.sh` or npm `build`) that runs:
   ```sh
   npm install -g elm@0.19.2-0
   mkdir -p dist
   elm make src/Main.elm --output=dist/elm.js
   cp src/main.css dist/main.css
   cp assets/index.html dist/index.html
   ```
   (Elm 0.19.2, see `elm.json`; verify locally with `rm -rf dist && ./build.sh`.)
3. Commit + push to `master`.

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
