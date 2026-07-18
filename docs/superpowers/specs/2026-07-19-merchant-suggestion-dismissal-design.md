# Merchant Suggestion Dismissal Design

## Goal

Selecting a merchant from the autocomplete suggestions must complete selection, close the suggestions, dismiss the keyboard, and remove focus from the merchant field.

## Design

`MerchantField` will use a dedicated suggestion-selection callback. The callback first delegates to the existing merchant selection logic so the merchant name, slug, external controller, and parent callback are updated. It then unfocuses the field, which deterministically closes `RawAutocomplete` and dismisses the keyboard.

Exact-match submission and merchants returned by the add flow continue using the existing selection path and are otherwise unchanged.

## Verification

Run formatting and static analysis only. Tests remain excluded by request.
