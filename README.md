# Finance

A modular Flutter finance app that I use as an engineering case study and
portfolio project. The goal is to show how I approach mobile product
development beyond screen-building: architecture, package boundaries, app
startup reliability, native integrations, and maintainable delivery workflow.

## What is already implemented

- Modular monorepo structure with `apps/*` and `packages/*`
- Flutter workspace tooling with FVM and Melos
- Dedicated app startup and dependency initialization flow
- Shared design system package with theme, colors, and `Manrope` typography
- Main application shell with routed navigation
- Home dashboard UI with balance, categories, and recent activity sections
- Budgets overview screen with richer visual treatment
- Voice recognition feature wired through `flutter_bloc`
- Federated voice plugin architecture for Android, iOS, and shared platform
  interface
- Reusable transaction preview components and mock transaction data

## Current maturity

The project is intentionally documented by its current state, not by its future
vision.

- The strongest implemented areas today are app structure, shared foundations,
  dashboard UI, budgets UI, and the custom voice/plugin setup.
- `history`, `settings`, and `create transaction` routes are already wired into
  the app, but their current screen implementations are still placeholders.
- The high-level voice-to-domain mapping service is not fully finished yet, so
  voice recognition is integrated at the platform and feature level, but not
  yet extended into a complete transaction-creation workflow.
- Some production-ready hooks such as Firebase and localization exist as TODO
  integration points rather than active features.

## Architecture overview

The repository is organized to keep concerns separate and scalable:

- `apps/finance_app`
  Main application entry point, startup flow, dependency wiring, routing, and
  shell UI.
- `packages/core`
  Shared configuration, environment handling, utilities, logging, dialogs,
  sheets, overlays, permissions, toasts, and URL launching helpers.
- `packages/design_system`
  Shared theme foundation, color tokens, and typography assets.
- `packages/home_screen`
  Home dashboard UI package.
- `packages/budgets_screen`
  Budgets UI package.
- `packages/history_screen`
  History feature package, currently scaffold-level.
- `packages/settings_screen`
  Settings feature package, currently scaffold-level.
- `packages/transaction_feature`
  Transaction-related UI components, previews, and mock data.
- `packages/voice_recognition_feature`
  Feature package for voice recognition using `flutter_bloc`.
- `packages/voice_plugin`
  Federated plugin entry package.
- `packages/voice_android`
  Android voice implementation.
- `packages/voice_ios`
  iOS voice implementation.
- `packages/voice_platform_interface`
  Shared platform contract for the voice stack.

## Engineering choices

- `flutter_bloc` for predictable state transitions in feature flows
- `go_router` for app navigation and shell-based route structure
- Melos for monorepo orchestration
- FVM for consistent Flutter SDK versioning
- Shared package boundaries to prevent app code from absorbing everything
- Federated plugin design to keep native voice integrations extensible and
  platform-specific where needed

## Tech stack

Flutter, Dart, FVM, Melos, `flutter_bloc`, `go_router`, Dio,
`shared_preferences`, `flutter_secure_storage`, `permission_handler`, and a
custom federated plugin architecture for voice recognition.

## Git flow

I currently use a lightweight branching model:

- `main` for stable code
- `dev` for integration
- `features/*` for isolated feature work

The recent repository history reflects that flow clearly. Feature branches are
merged into `dev`, then promoted into `main` once integrated. Examples already
present in this repo include `features/home-screen`,
`features/budgets-screen`, `features/ios-voice-recognition`, and
`features/create-transaction`.

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

## Summary

This repository demonstrates how I build a Flutter codebase with long-term
maintainability in mind: modular structure, reusable design foundations,
explicit app wiring, and native-platform capability when the product needs it.
It is still evolving, but it already reflects the standards I would bring to a
real product team.
