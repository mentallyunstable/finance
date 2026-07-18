# Merchant Suggestion Dismissal Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close merchant suggestions and dismiss the keyboard after a user selects a suggested merchant.

**Architecture:** Keep the existing shared merchant selection logic. Add a suggestion-specific callback that commits the selection first and then unfocuses the merchant field, leaving exact-submit and add-flow behavior unchanged.

**Tech Stack:** Flutter, Dart, `RawAutocomplete`.

---

### Task 1: Dismiss Suggestions After Selection

**Files:**
- Modify: `packages/merchant_feature/lib/view/merchant_field.dart`

- [ ] **Step 1: Route suggestion selection through a dedicated callback**

Change `RawAutocomplete.onSelected` to `_selectSuggestedMerchant`.

- [ ] **Step 2: Commit selection before removing focus**

Add:

```dart
void _selectSuggestedMerchant(MerchantData merchant) {
  _selectMerchant(merchant);
  _focusNode.unfocus();
}
```

This preserves the selected merchant name and slug before closing suggestions and dismissing the keyboard.

- [ ] **Step 3: Verify without tests**

Run:

```bash
fvm dart format --output=none --set-exit-if-changed packages/merchant_feature/lib/view/merchant_field.dart
fvm dart analyze packages/merchant_feature
```

Expected: formatting reports zero changes and analysis reports no issues. Tests are excluded by request.

- [ ] **Step 4: Commit**

```bash
git add packages/merchant_feature/lib/view/merchant_field.dart
git commit -m "fix: dismiss merchant suggestions after selection"
```
