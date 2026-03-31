# Finance

A modular Flutter finance app built as a public engineering case study. This
repository focuses on production-minded mobile architecture: explicit app
initialization, package boundaries, reusable UI foundations, and custom native
voice integration.

## Current project state

The repo already has a working app shell, routed feature packages, a shared
design system, and a federated voice plugin setup. It is not yet a fully
finished product, so this README reflects what is implemented now instead of
describing the end vision.

- `apps/finance_app` provides the app bootstrap flow, dependency setup,
  `go_router` navigation, and the main shell with bottom navigation plus a
  centered FAB currently routed to transaction creation.
- `packages/home_screen` contains the most complete dashboard flow so far,
  including a total balance card, category spending chart, and recent activity
  preview.
- `packages/budgets_screen` contains a more polished budgets overview UI with
  category progress cards and summary sections.
- `packages/voice_recognition_feature` is wired into the app with `flutter_bloc`
  and backed by the custom voice plugin stack.
- `packages/transaction_feature` already provides transaction preview
  components and mock transaction data used in the dashboard.
- `packages/design_system` defines the shared Material 3 theme, color system,
  and bundled `Manrope` typography.
- `packages/core` contains app config, environment handling, logger utilities,
  permission helpers, dialogs, modal sheets, overlays, toasts, and URL
  launcher helpers.

## Feature status

- Implemented foundation:
  - Monorepo workspace with Melos and FVM
  - Explicit app initialization pipeline
  - Shared theming and typography package
  - Federated voice plugin split across Android, iOS, and platform interface
  - BLoC-based voice recognition screen
  - Dashboard and budgets UI package work

- Wired but still evolving:
  - `history`, `settings`, and `create transaction` routes exist, but their
    current screen implementations are still placeholder `Scaffold`s
  - The high-level `VoiceService` in `packages/voice_plugin` is still stubbed,
    so voice-to-domain transaction parsing is not complete yet
  - Some production hooks such as Firebase/localization are present as TODO
    points, not active integrations

## Workspace structure

- `apps/finance_app` - main app entry point, initialization, dependency wiring,
  app shell, and routing
- `packages/core` - shared config, environment models, services, utilities, and
  logging
- `packages/design_system` - color tokens, typography, and app theme
- `packages/home_screen` - home dashboard UI
- `packages/history_screen` - history feature package, currently placeholder UI
- `packages/budgets_screen` - budgets overview UI
- `packages/settings_screen` - settings feature package, currently placeholder UI
- `packages/transaction_feature` - transaction UI components, previews, and mock
  data
- `packages/voice_recognition_feature` - voice recognition feature built with
  `flutter_bloc`
- `packages/voice_plugin` - federated plugin entry package
- `packages/voice_android` - Android implementation of the voice plugin
- `packages/voice_ios` - iOS implementation of the voice plugin
- `packages/voice_platform_interface` - shared platform contract for voice

## Tech stack

Flutter, Dart, FVM, Melos, `flutter_bloc`, `go_router`, Dio,
`shared_preferences`, `flutter_secure_storage`, `permission_handler`, and a
custom federated plugin architecture for voice recognition.

## Git flow

This repo currently follows a lightweight branch flow:

- `main` is the stable branch
- `dev` is the integration branch
- `features/*` branches are used for isolated feature work

The current history shows feature branches being merged into `dev`, then
promoted into `main`. Recent examples in this repo include
`features/home-screen`, `features/budgets-screen`,
`features/ios-voice-recognition`, and `features/create-transaction`.

## Run locally

```bash
fvm dart run melos pub_get
fvm dart run melos analyze
fvm dart run melos test
cd apps/finance_app
fvm flutter run
```

## Useful workspace commands

```bash
fvm dart run melos format
fvm dart run melos clean
fvm dart run melos build_runner
```

The project is still evolving, but the current direction is consistent: grow a
finance app with clear package boundaries, reusable UI building blocks, and
native-platform depth without letting the architecture drift into a demo-only
codebase.
