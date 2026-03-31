# CODEX.md

This file defines how Codex should operate in this repository.

## Purpose

Codex should act as a senior Flutter/Dart collaborator inside this monorepo.
Optimize for correctness, small safe changes, and repo-specific decisions over
generic Flutter advice.

## Repo Context

- This is a Flutter/Dart monorepo managed from the repository root.
- Root workspace and Melos configuration live in
  [`pubspec.yaml`](/Users/islamdz/Desktop/development/finance/pubspec.yaml).
- The Flutter SDK is pinned with FVM in
  [`.fvmrc`](/Users/islamdz/Desktop/development/finance/.fvmrc) to `3.41.5`.
- The root `workspace:` currently includes:
  - [`apps/finance_app`](/Users/islamdz/Desktop/development/finance/apps/finance_app)
  - [`packages/core`](/Users/islamdz/Desktop/development/finance/packages/core)
  - [`packages/design_system`](/Users/islamdz/Desktop/development/finance/packages/design_system)
  - [`packages/home_screen`](/Users/islamdz/Desktop/development/finance/packages/home_screen)
  - [`packages/history_screen`](/Users/islamdz/Desktop/development/finance/packages/history_screen)
  - [`packages/budgets_screen`](/Users/islamdz/Desktop/development/finance/packages/budgets_screen)
  - [`packages/settings_screen`](/Users/islamdz/Desktop/development/finance/packages/settings_screen)
  - [`packages/voice_android`](/Users/islamdz/Desktop/development/finance/packages/voice_android)
  - [`packages/voice_ios`](/Users/islamdz/Desktop/development/finance/packages/voice_ios)
  - [`packages/voice_platform_interface`](/Users/islamdz/Desktop/development/finance/packages/voice_platform_interface)
  - [`packages/voice_plugin`](/Users/islamdz/Desktop/development/finance/packages/voice_plugin)
  - [`packages/voice_recognition_feature`](/Users/islamdz/Desktop/development/finance/packages/voice_recognition_feature)
  - [`packages/transaction_feature`](/Users/islamdz/Desktop/development/finance/packages/transaction_feature)
- Melos scans `apps/*` and `packages/*` from the repository root.

## Current Project Structure

- App:
  - [`apps/finance_app`](/Users/islamdz/Desktop/development/finance/apps/finance_app)
    is the main Flutter application.
  - App startup goes through
    [`apps/finance_app/lib/app/logic/app_runner.dart`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app/logic/app_runner.dart)
    and
    [`apps/finance_app/lib/app/initialization/logic/initialization_processor.dart`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app/initialization/logic/initialization_processor.dart).
  - Dependency setup lives under
    [`apps/finance_app/lib/app/dependencies`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app/dependencies).
  - Routing lives under
    [`apps/finance_app/lib/shared/router`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/shared/router)
    and currently wires:
    - `home`
    - `history`
    - `budgets`
    - `settings`
    - `voice-recognition`
    - `create-transaction`
  - The app shell in
    [`apps/finance_app/lib/app/widget/app_shell.dart`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app/widget/app_shell.dart)
    uses a bottom navigation bar plus a centered FAB that currently routes to
    the create-transaction flow.

- Shared packages:
  - [`packages/core`](/Users/islamdz/Desktop/development/finance/packages/core)
    contains app config, environment handling, logger utilities, permission
    helpers, dialogs, modal sheets, overlay helpers, toasts, and URL launcher
    services.
  - [`packages/design_system`](/Users/islamdz/Desktop/development/finance/packages/design_system)
    contains the shared Material 3 theme, color scheme, and `Manrope`
    typography assets.

- Feature packages:
  - [`packages/home_screen`](/Users/islamdz/Desktop/development/finance/packages/home_screen)
    provides the home dashboard UI, including a balance card, category
    spending chart, and recent activity preview.
  - [`packages/budgets_screen`](/Users/islamdz/Desktop/development/finance/packages/budgets_screen)
    contains a more developed budgets UI with category cards and summary
    sections.
  - [`packages/history_screen`](/Users/islamdz/Desktop/development/finance/packages/history_screen),
    [`packages/settings_screen`](/Users/islamdz/Desktop/development/finance/packages/settings_screen),
    and
    [`packages/transaction_feature`](/Users/islamdz/Desktop/development/finance/packages/transaction_feature)
    are present and wired into the app, but parts of their screen layer are
    still scaffold-level or placeholder implementations.
  - [`packages/transaction_feature`](/Users/islamdz/Desktop/development/finance/packages/transaction_feature)
    already contains reusable transaction preview components and mock data used
    by the home screen.

- Voice/plugin stack:
  - [`packages/voice_platform_interface`](/Users/islamdz/Desktop/development/finance/packages/voice_platform_interface)
    defines the shared platform contract.
  - [`packages/voice_android`](/Users/islamdz/Desktop/development/finance/packages/voice_android)
    contains the Android voice implementation.
  - [`packages/voice_ios`](/Users/islamdz/Desktop/development/finance/packages/voice_ios)
    contains the iOS voice implementation.
  - [`packages/voice_plugin`](/Users/islamdz/Desktop/development/finance/packages/voice_plugin)
    aggregates the federated voice plugin packages.
  - [`packages/voice_recognition_feature`](/Users/islamdz/Desktop/development/finance/packages/voice_recognition_feature)
    contains the BLoC-driven voice recognition flow.
  - The high-level voice domain service in
    [`packages/voice_plugin/lib/voice_service.dart`](/Users/islamdz/Desktop/development/finance/packages/voice_plugin/lib/voice_service.dart)
    is still mostly stubbed/commented out, so do not describe voice-to-domain
    transaction parsing as finished unless that code is actually implemented.

## Workspace and Dependency Notes

- The workspace is aligned through the root `workspace:` section and Melos
  package scanning.
- The app package and the shared packages use `resolution: workspace`.
- [`apps/finance_app/pubspec.yaml`](/Users/islamdz/Desktop/development/finance/apps/finance_app/pubspec.yaml)
  depends on the screen packages, `core`, `design_system`,
  `voice_recognition_feature`, and `transaction_feature`.
- Prefer existing local packages over adding new external dependencies.
- When moving code between packages, check package boundaries and dependency
  direction first instead of assuming the current graph is clean.

## How Codex Should Work

- Read the affected code before proposing architecture changes.
- Prefer modifying the existing structure over introducing new patterns.
- Keep explanations short and practical unless the user asks for depth.
- Make reasonable assumptions and continue unless a decision is risky or
  irreversible.
- Never invent repo capabilities, scripts, or tooling that do not exist.
- Treat the workspace as potentially dirty; do not revert unrelated user
  changes.
- Update nearby docs when repo structure, workflows, or feature state changes.

## Tooling Expectations

- Prefer `rg` and `rg --files` for search.
- Prefer non-interactive shell commands.
- Use `apply_patch` for manual file edits.
- Run commands from the nearest relevant package unless the root workspace is
  specifically involved.
- All Dart and Flutter commands should use the `fvm` prefix in this repo.
- If a command fails because of sandbox, SDK cache, CocoaPods, Gradle, or
  platform-tooling restrictions, report that clearly and only escalate when
  appropriate.

## Flutter and Dart Standards

- Follow Effective Dart and standard Flutter conventions.
- Favor simple, readable, null-safe Dart.
- Prefer composition over inheritance.
- Use immutable widgets and immutable data where practical.
- Keep functions focused and avoid clever abstractions.
- Add comments only where intent is not obvious from the code.
- Use meaningful names; avoid unnecessary abbreviations.
- Prefer modern Dart language features when they improve clarity.
- Do not pass `BuildContext` or widget references into non-UI layers.
- Avoid global state and casual singletons; prefer dependency injection or
  local state.
- Use `const` constructors and widgets where practical.
- Follow the existing patterns in the codebase for state management,
  navigation, and dependency injection rather than introducing new approaches
  without a clear need.
- Use `Theme.of(context).colorScheme`, `Theme.of(context).textTheme`, or the
  existing project style patterns already present in the touched files.
- Use shorthand enum values where it improves readability, for example `.start`
  instead of `CrossAxisAlignment.start`, when the surrounding code already uses
  that style.

## Architecture Guidance

- Preserve the current split between app-specific code, shared packages,
  feature packages, and federated plugin packages.
- Keep app wiring and initialization in
  [`apps/finance_app/lib/app`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app).
- Keep routing-related changes in
  [`apps/finance_app/lib/shared/router`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/shared/router)
  unless there is a strong reason to move them.
- Put reusable utilities, constants, models, and services in
  [`packages/core`](/Users/islamdz/Desktop/development/finance/packages/core).
- Put reusable theme, color, and typography primitives in
  [`packages/design_system`](/Users/islamdz/Desktop/development/finance/packages/design_system).
- Keep native voice and platform-channel work isolated to the voice packages.
- Respect the existing `bloc`, `view`, `data`, and `domain` splits where they
  already exist.

## State Management and Navigation

- The app already depends on `flutter_bloc` and `go_router`, so prefer those
  existing choices when working in areas that use them.
- Prefer local state for strictly local UI concerns.
- Use constructor injection or the existing dependency initialization flow
  rather than adding global access patterns.
- Keep navigation additions consistent with the existing route helpers and app
  shell structure.

## Git Workflow Notes

- Current local and remote refs indicate a lightweight branching model with:
  - `main`
  - `dev`
  - `features/*`
- Feature work appears to land on `features/*`, get integrated through `dev`,
  and then move to `main`.
- Do not assume GitFlow release or hotfix branches exist unless the user asks
  for them.
- If the user asks for git help, prefer working with this observed branch model
  unless they explicitly want a different flow.

## Testing and Verification

- Verify changes with the smallest relevant command first.
- Prefer targeted commands in the affected package:
  - `fvm flutter analyze`
  - `fvm flutter test`
  - `fvm dart test` for pure Dart packages when appropriate
- Useful repo-level scripts from the root include:
  - `fvm dart run melos pub_get`
  - `fvm dart run melos analyze`
  - `fvm dart run melos test`
  - `fvm dart run melos format`
  - `fvm dart run melos build_runner`
  - `fvm dart run melos clean`
- If workspace wiring or dependencies change, consider repo-wide impact before
  stopping.
- If verification cannot run, say exactly why.

## Repo-Specific Caveats

- Some packages are fully active, while others are still close to scaffold
  state.
- The routed screens are not all equally implemented; avoid describing
  placeholder screens as feature-complete.
- There are TODO hooks for Firebase, localization, and related production
  integrations that are not currently enabled.
- Platform plugin packages may require platform-specific tooling that is not
  available in every environment.

## Change Strategy

- Prefer small, reviewable patches over broad rewrites.
- Fix the root cause instead of layering workarounds.
- Preserve public APIs unless the user asks for a breaking change.
- Update nearby docs and tests when behavior changes materially.
- Do not add speculative architecture or boilerplate without a concrete need.

## Communication Style

- Be concise, calm, and collaborative.
- Lead with findings, risks, and next actions.
- When reviewing code, prioritize bugs, regressions, and missing coverage over
  style nitpicks.
- When blocked, explain the blocker and propose the smallest useful next step.

## Default Commands

Run commands from the nearest relevant directory unless there is a clear reason
to use the repo root.

- Root workspace context:
  - `fvm dart run melos pub_get`
  - `fvm dart run melos analyze`
  - `fvm dart run melos test`
  - `fvm dart run melos format`
- App:
  - `cd apps/finance_app && fvm flutter analyze`
  - `cd apps/finance_app && fvm flutter test`
  - `cd apps/finance_app && fvm flutter run`
- Shared packages:
  - `cd packages/core && fvm flutter analyze`
  - `cd packages/core && fvm flutter test`
  - `cd packages/design_system && fvm flutter analyze`
  - `cd packages/design_system && fvm flutter test`
- Feature packages:
  - `cd packages/home_screen && fvm flutter analyze`
  - `cd packages/budgets_screen && fvm flutter analyze`
  - `cd packages/voice_recognition_feature && fvm flutter analyze`
  - `cd packages/transaction_feature && fvm flutter analyze`
- Voice packages:
  - `cd packages/voice_plugin && fvm flutter analyze`
  - `cd packages/voice_android && fvm flutter analyze`
  - `cd packages/voice_ios && fvm flutter analyze`
  - `cd packages/voice_platform_interface && fvm flutter test`
