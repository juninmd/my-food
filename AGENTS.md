# AGENTS.md

WebDiet (`my-food`): a meal-planning and nutrition app. A Flutter client (`lib/`) talks to a Node server (`server.ts`).

## Stack

- Flutter, Dart `>=3.5.0 <4.0.0` (`pubspec.yaml`). Web and Android targets (`web/`, `android/`).
- Node 20 (`.nvmrc`, `engines`), TypeScript, `tsx` for `server.ts`.
- pnpm 10.30.3 (`packageManager`). semantic-release for versioning (`release.config.ts`).

## Commands

```bash
pnpm install
pnpm start                    # tsx server.ts
pnpm build:server             # tsc
flutter pub get
flutter analyze
flutter test
./build_web.sh                # clones Flutter into ./flutter and builds the web app (set -e)
```

`pnpm release` runs semantic-release, which publishes a version. Run it from CI, not by hand.

## Structure

- `lib/`: Flutter app. `lib/pages/` screens (e.g. `food_catalog_page.dart`, `food_form_page.dart`), `lib/widgets/` reusable UI.
- `test/`: Flutter tests. `assets/`, `l10n.yaml`: assets and localization.
- `server.ts`, `tsconfig.json`: Node server. `release.config.ts`: semantic-release config.
- `web/`, `android/`: platform shells. `build_web.sh`: web build script.
- `docs/`: design and redesign notes. `dist/`: `tsc` output (`outDir` in `tsconfig.json`); two compiled files are tracked.
- `.github/workflows/`: `validate.yml` (base-actions), `deploy-pages.yml`, `release-drafter.yml`, `sast.yml`, `security.yml`.

## Conventions

- Max 150 lines per file. Refactor and split when logic grows.
- Keep business rules out of API routes and UI widgets.
- Validate API contracts against one unified schema.
- Versions come only from semantic-release. Do not bump versions by hand.
- Health features follow Plan, Act, Validate.
- `GEMINI.md` holds the core instruction set for the AI. Read it when the rules here are not enough.

## Gotchas

- `deploy-pages.yml` runs on every push to `main` or `master`. Merging to either branch publishes the site.
- `build_web.sh` deletes and re-clones `./flutter` on every run.
- Do not commit secrets. `.gitignore` covers `*.key`, `*.pem`, `*.p12`, `secrets/`, and `config/secrets.yml`.

<!-- base-actions-main-policy -->
## GitHub Actions — padrão obrigatório (@main)

- Referencie as actions internas sempre pelo branch, nunca por SHA:
  - `uses: juninmd/base-actions/<action>@main`
  - `uses: juninmd/base-actions/.github/workflows/<arquivo>.yml@main`
- Não fixe `@<sha>` em `juninmd/base-actions`: a atualização é centralizada no
  `main` e passa a valer no próximo run.
- PRs cujos checks não iniciam por billing/spending limit são mesclados pelo bot central
  `juninmd/base-actions/.github/workflows/auto-merge-billing-blocked.yml`.
  Para impedir o merge automático de um PR, aplique a label `do-not-merge`.
