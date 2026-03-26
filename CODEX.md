# CODEX.md

This file defines how Codex should operate in this repository.

## Purpose

Codex should act as a senior Flutter/Dart collaborator working inside this
local monorepo. Optimize for correctness, small safe changes, and repo-specific
decisions over generic Flutter advice.

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
- Melos scans more broadly than the root workspace and currently matches
  `apps/**` and `packages/**`.

## Current Project Structure

- App:
  - [`apps/finance_app`](/Users/islamdz/Desktop/development/finance/apps/finance_app)
    is the main Flutter application.
  - App code lives mainly under
    [`apps/finance_app/lib/app`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app)
    and
    [`apps/finance_app/lib/shared`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/shared).
  - Notable app areas currently include:
    - dependency setup in
      [`apps/finance_app/lib/app/dependencies`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app/dependencies)
    - app initialization in
      [`apps/finance_app/lib/app/initialization`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app/initialization)
    - home UI in
      [`apps/finance_app/lib/app/home`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app/home)
    - routing in
      [`apps/finance_app/lib/shared/router`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/shared/router)

- Shared packages:
  - [`packages/core`](/Users/islamdz/Desktop/development/finance/packages/core)
    contains shared constants, utilities, domain models, and service helpers.
  - [`packages/design_system`](/Users/islamdz/Desktop/development/finance/packages/design_system)
    exists as a workspace package, with package assets present, but appears
    relatively light at the moment.

- Voice/plugin stack present in the repo:
  - [`packages/voice_platform_interface`](/Users/islamdz/Desktop/development/finance/packages/voice_platform_interface)
    defines the shared platform interface.
  - [`packages/voice_android`](/Users/islamdz/Desktop/development/finance/packages/voice_android)
    contains the Android plugin implementation and example app.
  - [`packages/voice_ios`](/Users/islamdz/Desktop/development/finance/packages/voice_ios)
    contains the iOS plugin implementation and example app.
  - [`packages/voice_plugin`](/Users/islamdz/Desktop/development/finance/packages/voice_plugin)
    aggregates the platform interface and platform implementations.
  - [`packages/voice_recognition_feature`](/Users/islamdz/Desktop/development/finance/packages/voice_recognition_feature)
    is a Flutter feature package with `data`, `domain`, and `view` layers.

## Workspace and Dependency Notes

- The root `workspace:` list is narrower than the full set of packages present
  under [`packages/`](/Users/islamdz/Desktop/development/finance/packages).
- Some local packages still use direct `path:` dependencies instead of relying
  on workspace resolution.
- [`apps/finance_app/pubspec.yaml`](/Users/islamdz/Desktop/development/finance/apps/finance_app/pubspec.yaml)
  uses `resolution: workspace` and depends on `core` and `design_system`.
- [`packages/core/pubspec.yaml`](/Users/islamdz/Desktop/development/finance/packages/core/pubspec.yaml)
  also uses `resolution: workspace` and currently declares a dependency on
  `finance_app`; treat cross-package moves carefully because dependency
  direction may already be tangled.

## How Codex Should Work

- Read the affected code before proposing architecture changes.
- Prefer modifying the existing structure over introducing new patterns.
- Keep explanations short and practical unless the user asks for depth.
- Make reasonable assumptions and continue unless a decision is risky or
  irreversible.
- Never invent repo capabilities, scripts, or tooling that do not exist.
- Treat the workspace as potentially dirty; do not revert unrelated user
  changes.

## Tooling Expectations

- Prefer `rg` and `rg --files` for search.
- Prefer non-interactive shell commands.
- Use `apply_patch` for manual file edits.
- Run commands from the nearest relevant package unless the root workspace is
  specifically involved.
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
- Do no pass any context or widget references into non-UI code; use callbacks or other patterns
  instead.
- Avoid global state and singletons; prefer dependency injection or local state.
- Use `const` constructors and widgets where possible for performance benefits.
- Follow existing patterns in the codebase for state management, navigation, and
  dependency injection rather than introducing new approaches without a clear need.
- Do not pass any extent data and objects to constructors or methods.

## Architecture Guidance

- Preserve the current split between app-specific code, shared packages, and
  platform/plugin packages.
- Keep finance app wiring in
  [`apps/finance_app/lib/app`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/app)
  and shared routing helpers in
  [`apps/finance_app/lib/shared`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/shared).
- Put genuinely reusable utilities, constants, models, and services in
  [`packages/core`](/Users/islamdz/Desktop/development/finance/packages/core).
- Put reusable visual primitives and themed assets in
  [`packages/design_system`](/Users/islamdz/Desktop/development/finance/packages/design_system)
  when that package is the right home.
- Keep native voice and platform-channel work isolated to the voice packages
  instead of leaking plugin details into the app layer.
- Respect the existing `data` / `domain` / `view` organization inside
  [`packages/voice_recognition_feature`](/Users/islamdz/Desktop/development/finance/packages/voice_recognition_feature).

## State Management and Navigation

- Follow the patterns already declared in package manifests before introducing
  alternatives.
- The app already depends on `flutter_bloc` and `go_router`, so prefer those
  existing choices when working in areas that use them.
- Prefer local state for strictly local UI concerns.
- Use constructor injection or existing dependency wiring rather than adding
  global singletons casually.

## Dependencies

- Prefer existing workspace or local repo packages before adding new external
  dependencies.
- Keep dependency additions minimal and aligned with the current monorepo.
- Be careful when editing package relationships because the root workspace,
  Melos package scanning, and local `path:` dependencies are not fully aligned.
- When suggesting a new package, explain why it is needed and why a built-in
  Flutter/Dart option is insufficient.

## Testing and Verification

- Verify changes with the smallest relevant command first.
- All `dart/flutter` commands should run with `fvm` prefix
- Prefer targeted commands in the affected package:
  - `flutter analyze`
  - `flutter test`
  - `dart test` for pure Dart packages when appropriate
- Useful repo-level scripts from the root include:
  - `melos run analyze`
  - `melos run test`
  - `melos run pub_get`
  - `melos run format`
- If workspace wiring or dependencies change, consider root-level resolution
  impact before stopping.
- If verification cannot run, say exactly why.

## Repo-Specific Caveats

- The repo contains both root workspace packages and additional local packages
  that are not currently listed in the root `workspace:` section.
- Some packages and examples still appear scaffold-derived or lightly fleshed
  out.
- Platform plugin packages may require platform-specific tooling that is not
  available in every environment.
- Dependency direction across packages is not perfectly clean, so broad
  refactors should start with dependency mapping rather than assumptions.

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
  - `flutter pub get`
  - `melos bootstrap`
  - `melos run analyze`
  - `melos run test`
- App:
  - `cd apps/finance_app && flutter analyze`
  - `cd apps/finance_app && flutter test`
- Shared packages:
  - `cd packages/core && flutter analyze`
  - `cd packages/core && flutter test`
  - `cd packages/design_system && flutter analyze`
  - `cd packages/design_system && flutter test`
- Voice packages:
  - `cd packages/voice_plugin && flutter analyze`
  - `cd packages/voice_platform_interface && flutter test`
  - `cd packages/voice_android && flutter test`
  - `cd packages/voice_ios && flutter test`
  - `cd packages/voice_recognition_feature && flutter test`

## Non-Goals

- Do not prescribe large-scale architecture migrations without evidence from
  the codebase.
- Do not replace working code with template-generated code.
- Do not assume every package in the repo is equally integrated into the root
  workspace.
- Do not treat stale README or scaffold text as authoritative over the current
  source tree and manifests.
