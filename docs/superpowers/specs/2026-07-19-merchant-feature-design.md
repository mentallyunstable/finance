# Merchant Feature Design

## Goal

Add an independent, in-memory merchant feature that integrates with transaction creation through a stable merchant slug. The merchant field remains optional and supports the user's most-used merchants, local smart search, merchant creation, category metadata, descriptions, and remotely sourced SVG icons cached on device.

## Scope

- Add a dedicated `merchant_feature` Flutter package.
- Keep merchant records in memory for the current app session.
- Seed the pool with a small set of common merchants.
- Link an indexed merchant to `TransactionEntity` using `String? merchantSlug`.
- Do not store free-form merchant text as the transaction link.
- Keep categories and merchants independent: selecting either never filters or restricts the other.
- Store manually selected category IDs on a merchant as descriptive metadata only.
- Fetch brand SVGs from Iconify's `simple-icons` collection and cache downloaded files locally.

Persistence, merchant editing/deletion, remote merchant synchronization, and automatic category learning are outside this version.

## Architecture

`merchant_feature` owns merchant data, in-memory state, ranking/search, icon access, reusable merchant field UI, and the add-merchant screen. `transaction_feature` depends on it only for selection UI and the `merchantSlug` transaction contract. `finance_app` provides `MerchantBloc` and the icon repository at app scope and wires the add-merchant route.

`category_feature` remains independent. `merchant_feature` may read its category list in the add flow, but no BLoC filters merchants by transaction category or categories by merchant.

## Merchant Model

Each `MerchantData` contains:

- `slug`: stable, unique, URL-safe identifier.
- `name`: user-facing name.
- `description`: optional user text.
- `iconId`: optional Iconify identifier such as `simple-icons:starbucks`.
- `categoryIds`: zero or more manually selected category IDs.
- `usageCount`: number of successfully created transactions linked to the merchant in this session.

Names are unique case-insensitively. Slugs are generated from normalized names and receive a numeric suffix on collision.

## Transaction Creation UX

When the merchant field gains focus with an empty query, it shows up to five merchants ordered by `usageCount` descending and then name. Typing performs case-insensitive local ranking: exact match, name prefix, word prefix, substring, then usage and name.

Selecting a suggestion stores its slug in the form while showing its name. Editing the text after selection clears the selected slug. When non-empty text has no exact indexed match, submitting the field or attempting to create the transaction shows an actionable toast offering to add that merchant.

The add action opens a separate screen with the name prefilled. A successful add returns the new merchant, selects it in the transaction form, and keeps the entered transaction data intact. Because merchant is optional, users can clear the field and create without a merchant. A non-empty unmatched value is not silently discarded and does not create a transaction.

On successful transaction creation, the transaction screen emits a merchant-used event for the selected slug. The transaction keeps its existing title behavior, using the selected merchant name or the selected category name, while the actual merchant relationship is `merchantSlug`.

## Add Merchant Flow

The screen contains name, optional description, optional SVG icon selection, and a multi-select list of all current categories. Category selection is manual and does not affect transaction category choices.

Icon search queries Iconify with the `simple-icons` prefix. Selecting an icon stores its Iconify ID. Rendering downloads the SVG through a cache-backed repository; subsequent renders use the cached file. Network, search, or SVG rendering failures show a storefront fallback and never block saving.

Saving requires a non-empty, non-duplicate name. Duplicate names surface the existing merchant instead of creating another record.

## State And Data Flow

1. `MerchantBloc` starts with seeded merchants in memory.
2. `MerchantField` derives suggestions from current state without network access.
3. Selection returns a full merchant to the transaction form, which retains only its slug and display name.
4. Unknown text can open `AddMerchantScreen` through the app router.
5. `AddMerchantScreen` dispatches create; the BLoC adds the merchant and the route returns it.
6. `TransactionBlocEvent.create` receives nullable `merchantSlug`.
7. After transaction creation succeeds, `MerchantBloc` increments that merchant's usage count.

## Error Handling

- Empty merchant name: inline validation; stay on the add screen.
- Duplicate name: BLoC error identifies the existing merchant; do not add a duplicate.
- Unknown slug usage event: ignore without changing state.
- Icon API/cache failure: show fallback icon and allow retry through a later rebuild.
- Unknown transaction field text: actionable add toast; block only until the user adds or clears it.
- No selected merchant: valid transaction with `merchantSlug: null`.

## Testing

- Unit-test slug generation, duplicate detection, smart-search ordering, creation, and usage increments.
- Widget-test the focused top-five suggestions, search selection, unmatched add action, and returned merchant selection.
- Widget-test add-merchant validation, category multi-selection, icon fallback, and successful return.
- Update transaction BLoC tests to assert `merchantSlug` and add a transaction-screen integration test for unmatched text and usage tracking.
- Run targeted package tests and analysis, then workspace analysis because package dependencies and routing change.

## Icon Source

Use Iconify's public API restricted to the Simple Icons collection. Simple Icons supplies the brand SVGs under CC0, while the integration still keeps source attribution in project documentation and confines icon IDs to that collection.
