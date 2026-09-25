# KFZAPP

Look up German license plate codes (*Kfz-Kennzeichen*): type 1–3 letters and get
the district, its origin (*Altkennzeichen* derivation) and Bundesland —
styled like a German number plate, with a Google Maps link for the district.

Built with [Elm](https://elm-lang.org) 0.19.2. No backend, no database:
the whole app compiles to static HTML/JS/CSS.

## Usage

Enter a code such as `BNA`:

> **Leipzig**
> Borna, Sachsen
> 📍 Show on Google Maps

## Development

Prerequisites: [Node.js](https://nodejs.org) and Elm 0.19.2+:

```sh
npm install -g elm elm-test
```

| Task  | Command                                            |
|-------|----------------------------------------------------|
| Test  | `elm-test`                                         |
| Build | `./build.sh` (Elm 0.19.2 → `dist/`, incl. PWA manifest, icons, service worker) |
| Run   | `python3 -m http.server -d dist 8000` → http://localhost:8000 |

Installable as a progressive web app (see `assets/`): manifest, plate
icons and an offline-first service worker are copied into `dist/` by the
build script, so the app works fully offline once installed.

## Data

`platesData` in `src/Main.elm` holds 716 codes, generated from the
[Kraftfahrt-Bundesamt list](https://www.kba.de/DE/Service/Kennzeichen/kennzeichen_node.html)
(via the [openpotato/kfz-kennzeichen](https://github.com/openpotato/kfz-kennzeichen)
CSV, status April 2026) plus `X`/`Y` (Bundeswehr). Each entry has the district
name, the derivation place (`Herleitung`, empty when identical to the district)
and the Bundesland.

## Hosting

Static hosting fits (see `TODO.md` for the Cloudflare Pages plan).

## License

MIT — see [LICENSE](LICENSE).
