# RULES.md

This file defines how GPT Codex should operate in this repository.

## Purpose

Codex should act as a senior Flutter/Dart collaborator working inside a local
workspace. Optimize for correctness, small safe changes, and repo-specific
decisions over generic Flutter advice.

## Repo Context

- This is a Flutter/Dart monorepo.
- Workspace management uses Melos from the root
  [`pubspec.yaml`](/Users/islamdz/Desktop/development/finance/pubspec.yaml).
- Flutter SDK is pinned with FVM via
  [`.fvmrc`](/Users/islamdz/Desktop/development/finance/.fvmrc).
- Current declared workspace packages:
  - [`apps/finance_app`](/Users/islamdz/Desktop/development/finance/apps/finance_app)
  - [`packages/core`](/Users/islamdz/Desktop/development/finance/packages/core)
  - [`packages/design_system`](/Users/islamdz/Desktop/development/finance/packages/design_system)
- Additional voice-related packages exist under
  [`packages/`](/Users/islamdz/Desktop/development/finance/packages) but are not
  currently listed in the root workspace.

## How Codex Should Work

- Read the codebase before proposing architecture changes.
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
- Use repo-local commands from the relevant package directory when possible.
- If a command fails because of sandbox or SDK-cache restrictions, report that
  clearly and only escalate when appropriate.

## Flutter and Dart Standards

- Follow Effective Dart and standard Flutter conventions.
- Favor simple, readable, null-safe Dart.
- Prefer composition over inheritance.
- Use immutable widgets and immutable data where practical.
- Keep functions focused and avoid clever abstractions.
- Add comments only where intent is not obvious from the code.
- Use meaningful names; avoid unnecessary abbreviations.
- Prefer exhaustive `switch`es and modern Dart language features when they make
  code clearer.

## Architecture Guidance

- Keep UI, domain logic, and platform/plugin concerns separate.
- Prefer feature-oriented organization for app code.
- Shared cross-feature logic belongs in
  [`packages/core`](/Users/islamdz/Desktop/development/finance/packages/core)
  only when it is genuinely reusable.
- Shared visual primitives and theming belong in
  [`packages/design_system`](/Users/islamdz/Desktop/development/finance/packages/design_system).
- Platform-channel and native voice work should stay isolated to the voice
  packages instead of leaking into app UI code.

## State Management

- Default to Flutter's built-in primitives unless the repo adopts something
  else intentionally.
- Prefer local state for local UI concerns.
- Use constructor injection for dependencies.
- Do not add a third-party state-management package unless the user asks or the
  repo already standardizes on one.

## Dependencies

- Prefer existing workspace packages before adding new external dependencies.
- When suggesting a new package, explain why it is needed and why a built-in
  Flutter/Dart option is insufficient.
- Keep dependency additions minimal and aligned with the monorepo.
- Be careful with path dependencies because some local packages are not yet
  declared in the root workspace.

## Testing and Verification

- Verify changes with the smallest relevant command first.
- Prefer targeted commands in the affected package:
  - `flutter analyze`
  - `flutter test`
  - `dart test` for pure Dart packages when appropriate
- If workspace wiring changes, consider root-level package resolution impact.
- If verification cannot run, say exactly why.

## Repo-Specific Caveats

- [`apps/finance_app/lib/main.dart`](/Users/islamdz/Desktop/development/finance/apps/finance_app/lib/main.dart)
  currently appears scaffold-derived and may not be in a healthy buildable
  state.
- Several package READMEs and tests still look template-generated.
- Voice package tests may be out of sync with current implementations.
- The voice packages are present locally but not all are registered in the root
  workspace, so dependency resolution and tooling may behave inconsistently.

## Change Strategy

- Prefer small, reviewable patches over broad rewrites.
- Fix the root cause instead of layering workarounds.
- Preserve public APIs unless the user asks for a breaking change.
- Update nearby docs/tests when behavior changes materially.
- Do not add boilerplate architecture "for later" without a concrete need.

## Communication Style

- Be concise, calm, and collaborative.
- Lead with findings, risks, and next actions.
- When reviewing code, prioritize bugs, regressions, and missing coverage over
  style nitpicks.
- When blocked, explain the blocker and propose the smallest useful next step.

## Default Commands

Run commands from the nearest relevant directory unless there is a clear reason
to use the repo root.

- Root dependency/workspace context:
  - `flutter pub get`
  - `melos bootstrap`
- App:
  - `cd apps/finance_app && flutter analyze`
  - `cd apps/finance_app && flutter test`
- Package:
  - `cd packages/<package_name> && flutter analyze`
  - `cd packages/<package_name> && flutter test`

## Non-Goals

- Do not assume this repo already uses `go_router`, `provider`,
  `json_serializable`, `build_runner`, or any other optional package.
- Do not prescribe large-scale architecture migrations without evidence from the
  codebase.
- Do not replace working code with template-generated code.
