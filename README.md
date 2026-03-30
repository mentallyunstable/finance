# Finance

A modular Flutter finance app built as a public engineering case study. I use this repository to show how I approach production-minded mobile development: clean package boundaries, reusable UI foundations, reliable app initialization, and custom platform integrations.

## What this repo demonstrates

- Flutter monorepo setup with Melos and shared workspace tooling
- Feature-oriented architecture with separated app, core, design system, and plugin packages
- State management and event-driven flows with `flutter_bloc`
- Custom voice recognition integration across Android, iOS, and a shared platform interface
- Reusable theming and UI primitives for consistent product design
- Developer tooling discipline with centralized linting, formatting, and test commands

## Workspace structure

- `apps/finance_app` - main app shell, routing, initialization, and finance UI
- `packages/core` - shared config, services, utilities, logging, and environment handling
- `packages/design_system` - colors, typography, and app theme foundation
- `packages/voice_recognition_feature` - voice recognition feature built with BLoC
- `packages/voice_plugin`, `voice_android`, `voice_ios`, `voice_platform_interface` - custom federated plugin setup

## Tech stack

Flutter, Dart, Melos, FVM, `flutter_bloc`, `go_router`, Dio, Shared Preferences, Secure Storage, and federated plugin architecture.

## Run locally

```bash
fvm dart run melos bootstrap
fvm dart run melos analyze
fvm dart run melos test
cd apps/finance_app && fvm flutter run
```

This project is still evolving, but the goal is consistent: build a finance app with the same architectural care, platform depth, and maintainability standards I would bring to a real product team.
