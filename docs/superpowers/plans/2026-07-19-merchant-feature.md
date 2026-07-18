# Merchant Feature Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an independent in-memory merchant feature with smart suggestions, merchant creation, cached SVG brand icons, category metadata, and transaction links by merchant slug.

**Architecture:** A new `merchant_feature` package owns merchant state, search/ranking, icon access, and merchant UI. The app provides its BLoC/repository and routes; `transaction_feature` consumes the merchant field and stores only `merchantSlug` as the relationship. Categories remain independent metadata and never filter merchant or transaction choices.

**Tech Stack:** Flutter 3.41.5 via FVM, Dart 3.11, `flutter_bloc`, `go_router`, `dio`, `flutter_cache_manager`, `flutter_svg`, Flutter test.

---

## Execution Prerequisite

The current working tree contains uncommitted `category_feature` extraction work that this feature depends on. Before executing this plan in an isolated worktree, first commit that category work on its owning branch, then create the merchant worktree from that commit. Do not stash, discard, or absorb those existing changes into merchant commits.

## File Map

- Create `packages/merchant_feature/`: merchant model, search, in-memory BLoC, Iconify repository, merchant field, icon widget, and add screen.
- Modify `pubspec.yaml`: register the package in the Dart workspace.
- Modify `apps/finance_app/pubspec.yaml`: depend on `merchant_feature`.
- Modify `apps/finance_app/lib/app/widget/app_bloc_provider.dart`: provide merchant repository and BLoC.
- Modify app router files: register and invoke the add-merchant route.
- Modify `packages/transaction_feature/pubspec.yaml`: depend on `merchant_feature`.
- Modify transaction model, DTO, BLoC event/handler, mocks, tests, and creation screen: replace merchant text links with `merchantSlug` and integrate selection.

### Task 1: Create The Merchant Package

**Files:**
- Create: `packages/merchant_feature/pubspec.yaml`
- Create: `packages/merchant_feature/analysis_options.yaml`
- Modify: `pubspec.yaml`
- Modify: `apps/finance_app/pubspec.yaml`
- Modify: `packages/transaction_feature/pubspec.yaml`

- [ ] **Step 1: Create the package skeleton**

Run:

```bash
fvm flutter create --template=package packages/merchant_feature
```

Expected: a package named `merchant_feature` is created without changing existing feature packages.

- [ ] **Step 2: Register dependencies**

Add the root workspace entry:

```yaml
workspace:
  - packages/merchant_feature
```

Set `packages/merchant_feature/pubspec.yaml` dependencies to:

```yaml
dependencies:
  flutter:
    sdk: flutter
  category_feature: any
  core: any
  dio: ^5.9.2
  flutter_bloc: ^9.1.1
  flutter_cache_manager: ^3.4.1
  flutter_svg: ^2.2.3
```

Add `merchant_feature: any` to both the app and transaction feature dependencies.

- [ ] **Step 3: Bootstrap and verify the package graph**

Run:

```bash
fvm dart run melos bootstrap
fvm dart run melos list
```

Expected: `merchant_feature`, `transaction_feature`, and `finance_app` resolve successfully, and the list includes `merchant_feature`.

- [ ] **Step 4: Commit package wiring**

```bash
git add pubspec.yaml pubspec.lock apps/finance_app/pubspec.yaml packages/transaction_feature/pubspec.yaml packages/merchant_feature
git commit -m "chore: add merchant feature package"
```

### Task 2: Implement Merchant Data And Smart Search

**Files:**
- Create: `packages/merchant_feature/lib/data/merchant_data.dart`
- Create: `packages/merchant_feature/lib/data/default_merchants_data.dart`
- Create: `packages/merchant_feature/lib/domain/merchant_search.dart`
- Test: `packages/merchant_feature/test/domain/merchant_search_test.dart`

- [ ] **Step 1: Write failing search and slug tests**

```dart
test('empty query returns five most-used merchants', () {
  final result = searchMerchants(defaultMerchantsData, '', limit: 5);
  expect(result, hasLength(5));
  expect(result.map((merchant) => merchant.usageCount), orderedEquals([9, 7, 5, 3, 1]));
});

test('search ranks exact, prefix, word prefix, then substring', () {
  const merchants = <MerchantData>[
    MerchantData(slug: 'mart', name: 'Mart', categoryIds: [], usageCount: 0),
    MerchantData(slug: 'market', name: 'Market', categoryIds: [], usageCount: 9),
    MerchantData(slug: 'city-mart', name: 'City Mart', categoryIds: [], usageCount: 8),
    MerchantData(slug: 'smart-shop', name: 'Smart Shop', categoryIds: [], usageCount: 7),
  ];
  expect(searchMerchants(merchants, 'mart').map((m) => m.slug), ['mart', 'market', 'city-mart', 'smart-shop']);
});

test('slug receives a numeric suffix on collision', () {
  expect(createMerchantSlug('Coffee Shop', {'coffee-shop'}), 'coffee-shop-2');
});
```

- [ ] **Step 2: Run the tests and confirm they fail**

Run:

```bash
cd packages/merchant_feature && fvm flutter test test/domain/merchant_search_test.dart
```

Expected: FAIL because the merchant model and search functions do not exist.

- [ ] **Step 3: Add the immutable merchant model**

```dart
final class MerchantData {
  final String slug;
  final String name;
  final String? description;
  final String? iconId;
  final List<String> categoryIds;
  final int usageCount;

  const MerchantData({
    required this.slug,
    required this.name,
    this.description,
    this.iconId,
    required this.categoryIds,
    required this.usageCount,
  });

  MerchantData copyWith({int? usageCount}) => MerchantData(
    slug: slug,
    name: name,
    description: description,
    iconId: iconId,
    categoryIds: categoryIds,
    usageCount: usageCount ?? this.usageCount,
  );
}
```

Use this seed list:

```dart
const defaultMerchantsData = <MerchantData>[
  MerchantData(slug: 'starbucks', name: 'Starbucks', iconId: 'simple-icons:starbucks', categoryIds: ['food'], usageCount: 9),
  MerchantData(slug: 'uber', name: 'Uber', iconId: 'simple-icons:uber', categoryIds: ['transport', 'travel'], usageCount: 7),
  MerchantData(slug: 'amazon', name: 'Amazon', iconId: 'simple-icons:amazon', categoryIds: ['shopping', 'electronics'], usageCount: 5),
  MerchantData(slug: 'netflix', name: 'Netflix', iconId: 'simple-icons:netflix', categoryIds: ['subscriptions', 'entertainment'], usageCount: 3),
  MerchantData(slug: 'mcdonalds', name: "McDonald's", iconId: 'simple-icons:mcdonalds', categoryIds: ['food'], usageCount: 1),
];
```

- [ ] **Step 4: Implement deterministic search and slug generation**

```dart
String normalizeMerchantText(String value) => value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

String createMerchantSlug(String name, Set<String> existingSlugs) {
  final base = normalizeMerchantText(name)
      .replaceAll(RegExp('[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  final safeBase = base.isEmpty ? 'merchant' : base;
  var candidate = safeBase;
  var suffix = 2;
  while (existingSlugs.contains(candidate)) {
    candidate = '$safeBase-${suffix++}';
  }
  return candidate;
}

List<MerchantData> searchMerchants(List<MerchantData> merchants, String query, {int limit = 5}) {
  final normalized = normalizeMerchantText(query);
  int score(MerchantData merchant) {
    final name = normalizeMerchantText(merchant.name);
    if (normalized.isEmpty) return 0;
    if (name == normalized) return 0;
    if (name.startsWith(normalized)) return 1;
    if (name.split(' ').any((word) => word.startsWith(normalized))) return 2;
    if (name.contains(normalized)) return 3;
    return 99;
  }

  final result = merchants.where((merchant) => score(merchant) < 99).toList()
    ..sort((a, b) {
      final byScore = score(a).compareTo(score(b));
      if (byScore != 0) return byScore;
      final byUsage = b.usageCount.compareTo(a.usageCount);
      return byUsage != 0 ? byUsage : a.name.compareTo(b.name);
    });
  return result.take(limit).toList(growable: false);
}
```

- [ ] **Step 5: Run tests and commit**

```bash
cd packages/merchant_feature && fvm flutter test test/domain/merchant_search_test.dart
git add lib/data lib/domain test/domain
git commit -m "feat: add merchant model and smart search"
```

Expected: PASS.

### Task 3: Add The In-Memory Merchant BLoC

**Files:**
- Create: `packages/merchant_feature/lib/bloc/merchant_bloc.dart`
- Create: `packages/merchant_feature/lib/bloc/merchant_bloc_event.dart`
- Create: `packages/merchant_feature/lib/bloc/merchant_bloc_state.dart`
- Create: `packages/merchant_feature/lib/bloc/merchant_bloc_state_data.dart`
- Test: `packages/merchant_feature/test/bloc/merchant_bloc_test.dart`

- [ ] **Step 1: Write failing BLoC tests**

```dart
test('creates a merchant with normalized unique slug', () async {
  final bloc = MerchantBloc(initialMerchants: const []);
  addTearDown(bloc.close);
  bloc.add(const MerchantBlocEvent.create(name: 'Coffee Shop', description: null, iconId: null, categoryIds: ['food']));
  await expectLater(bloc.stream, emits(isA<CreatedMerchantBlocState>().having((s) => s.merchant.slug, 'slug', 'coffee-shop')));
});

test('rejects a case-insensitive duplicate name', () async {
  final bloc = MerchantBloc(initialMerchants: const [MerchantData(slug: 'uber', name: 'Uber', categoryIds: [], usageCount: 0)]);
  addTearDown(bloc.close);
  bloc.add(const MerchantBlocEvent.create(name: ' uber ', description: null, iconId: null, categoryIds: []));
  await expectLater(bloc.stream, emits(isA<ErrorMerchantBlocState>()));
});

test('increments usage for a known slug', () async {
  final bloc = MerchantBloc(initialMerchants: const [MerchantData(slug: 'uber', name: 'Uber', categoryIds: [], usageCount: 2)]);
  addTearDown(bloc.close);
  bloc.add(const MerchantBlocEvent.used(slug: 'uber'));
  await expectLater(bloc.stream, emits(predicate<MerchantBlocState>((s) => s.data.merchants.single.usageCount == 3)));
});
```

- [ ] **Step 2: Run tests and confirm failure**

```bash
cd packages/merchant_feature && fvm flutter test test/bloc/merchant_bloc_test.dart
```

Expected: FAIL because `MerchantBloc` is undefined.

- [ ] **Step 3: Define events and state contracts**

```dart
sealed class MerchantBlocEvent {
  const MerchantBlocEvent();
  const factory MerchantBlocEvent.create({required String name, String? description, String? iconId, required List<String> categoryIds}) = CreateMerchantEvent;
  const factory MerchantBlocEvent.used({required String slug}) = UseMerchantEvent;
}

final class CreateMerchantEvent extends MerchantBlocEvent {
  final String name;
  final String? description;
  final String? iconId;
  final List<String> categoryIds;
  const CreateMerchantEvent({required this.name, this.description, this.iconId, required this.categoryIds});
}

final class UseMerchantEvent extends MerchantBlocEvent {
  final String slug;
  const UseMerchantEvent({required this.slug});
}

final class MerchantBlocStateData {
  final List<MerchantData> merchants;
  const MerchantBlocStateData({required this.merchants});
  MerchantBlocStateData copyWith({List<MerchantData>? merchants}) => MerchantBlocStateData(merchants: merchants ?? this.merchants);
}
```

Define the complete state variants:

```dart
sealed class MerchantBlocState {
  final MerchantBlocStateData data;
  const MerchantBlocState({required this.data});

  const factory MerchantBlocState.initial({required MerchantBlocStateData data}) = InitialMerchantBlocState;
  const factory MerchantBlocState.created({required MerchantBlocStateData data, required MerchantData merchant}) = CreatedMerchantBlocState;
  const factory MerchantBlocState.error({required MerchantBlocStateData data, required String message, MerchantData? existingMerchant}) = ErrorMerchantBlocState;
}

final class InitialMerchantBlocState extends MerchantBlocState {
  const InitialMerchantBlocState({required super.data});
}

final class CreatedMerchantBlocState extends MerchantBlocState {
  final MerchantData merchant;
  const CreatedMerchantBlocState({required super.data, required this.merchant});
}

final class ErrorMerchantBlocState extends MerchantBlocState {
  final String message;
  final MerchantData? existingMerchant;
  const ErrorMerchantBlocState({required super.data, required this.message, this.existingMerchant});
}
```

- [ ] **Step 4: Implement create, duplicate, and usage handlers**

```dart
MerchantBloc({List<MerchantData> initialMerchants = defaultMerchantsData})
    : super(MerchantBlocState.initial(data: MerchantBlocStateData(merchants: List.unmodifiable(initialMerchants)))) {
  on<CreateMerchantEvent>(_onCreate);
  on<UseMerchantEvent>(_onUsed);
}

void _onCreate(CreateMerchantEvent event, Emitter<MerchantBlocState> emit) {
  final normalized = normalizeMerchantText(event.name);
  final existing = state.data.merchants.cast<MerchantData?>().firstWhere(
    (merchant) => normalizeMerchantText(merchant!.name) == normalized,
    orElse: () => null,
  );
  if (existing != null) {
    emit(MerchantBlocState.error(data: state.data, message: 'Merchant already exists', existingMerchant: existing));
    return;
  }
  final merchant = MerchantData(
    slug: createMerchantSlug(event.name, state.data.merchants.map((m) => m.slug).toSet()),
    name: event.name.trim(),
    description: event.description?.trim().isEmpty == true ? null : event.description?.trim(),
    iconId: event.iconId,
    categoryIds: List.unmodifiable(event.categoryIds),
    usageCount: 0,
  );
  emit(MerchantBlocState.created(data: state.data.copyWith(merchants: [...state.data.merchants, merchant]), merchant: merchant));
}

void _onUsed(UseMerchantEvent event, Emitter<MerchantBlocState> emit) {
  if (!state.data.merchants.any((merchant) => merchant.slug == event.slug)) return;
  final merchants = state.data.merchants.map((merchant) {
    return merchant.slug == event.slug
        ? merchant.copyWith(usageCount: merchant.usageCount + 1)
        : merchant;
  }).toList(growable: false);
  emit(MerchantBlocState.initial(data: state.data.copyWith(merchants: merchants)));
}
```

- [ ] **Step 5: Run tests and commit**

```bash
cd packages/merchant_feature && fvm flutter test test/bloc/merchant_bloc_test.dart
git add lib/bloc test/bloc
git commit -m "feat: add in-memory merchant state"
```

Expected: PASS.

### Task 4: Add Iconify Search And Local SVG Cache

**Files:**
- Create: `packages/merchant_feature/lib/data/merchant_icon_repository.dart`
- Create: `packages/merchant_feature/lib/view/components/merchant_icon.dart`
- Modify: `packages/merchant_feature/README.md`
- Test: `packages/merchant_feature/test/data/merchant_icon_repository_test.dart`
- Test: `packages/merchant_feature/test/view/components/merchant_icon_test.dart`

- [ ] **Step 1: Write failing repository tests with fakes**

```dart
test('search keeps only simple-icons results', () async {
  final repository = IconifyMerchantIconRepository(
    searchRequest: (_) async => {'icons': ['simple-icons:uber', 'mdi:car']},
    fileLoader: (_) => throw UnimplementedError(),
  );
  expect(await repository.search('Uber'), ['simple-icons:uber']);
});

testWidgets('icon failure renders storefront fallback', (tester) async {
  await tester.pumpWidget(MaterialApp(home: RepositoryProvider<MerchantIconRepository>.value(
    value: FailingMerchantIconRepository(),
    child: const MerchantIcon(iconId: 'simple-icons:uber'),
  )));
  await tester.pumpAndSettle();
  expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
});

final class FailingMerchantIconRepository implements MerchantIconRepository {
  @override
  Future<File> getFile(String iconId) => Future<File>.error(Exception('offline'));

  @override
  Future<List<String>> search(String query) async => const [];
}
```

- [ ] **Step 2: Run tests and confirm failure**

```bash
cd packages/merchant_feature && fvm flutter test test/data test/view/components/merchant_icon_test.dart
```

Expected: FAIL because the repository and widget do not exist.

- [ ] **Step 3: Implement the repository boundary**

```dart
typedef IconSearchRequest = Future<Map<String, dynamic>> Function(String query);
typedef IconFileLoader = Future<File> Function(String iconId);

abstract interface class MerchantIconRepository {
  Future<List<String>> search(String query);
  Future<File> getFile(String iconId);
}

final class IconifyMerchantIconRepository implements MerchantIconRepository {
  final IconSearchRequest searchRequest;
  final IconFileLoader fileLoader;

  const IconifyMerchantIconRepository({required this.searchRequest, required this.fileLoader});

  factory IconifyMerchantIconRepository.live({required Dio dio, required BaseCacheManager cacheManager}) {
    return IconifyMerchantIconRepository(
      searchRequest: (query) async {
        final response = await dio.get<Map<String, dynamic>>(
          'https://api.iconify.design/search',
          queryParameters: {'query': query, 'prefixes': 'simple-icons', 'limit': 8},
        );
        return response.data ?? const {};
      },
      fileLoader: (iconId) => cacheManager.getSingleFile('https://api.iconify.design/$iconId.svg'),
    );
  }

  @override
  Future<List<String>> search(String query) async {
    final response = await searchRequest(query);
    final icons = (response['icons'] as List? ?? const []).whereType<String>();
    return icons.where((icon) => icon.startsWith('simple-icons:')).toList(growable: false);
  }

  @override
  Future<File> getFile(String iconId) => fileLoader(iconId);
}
```

- [ ] **Step 4: Implement cached SVG rendering with fallback**

```dart
FutureBuilder<File>(
  future: context.read<MerchantIconRepository>().getFile(iconId!),
  builder: (context, snapshot) {
    if (snapshot.hasData) return SvgPicture.file(snapshot.data!, width: size, height: size);
    if (snapshot.hasError) return Icon(Icons.storefront_outlined, size: size);
    return SizedBox.square(dimension: size, child: const CircularProgressIndicator(strokeWidth: 2));
  },
)
```

Render the same fallback immediately when `iconId == null`.

- [ ] **Step 5: Run tests and commit**

Add this attribution before committing:

```markdown
## Merchant icons

Brand SVGs are fetched through [Iconify](https://iconify.design/) from the
[Simple Icons](https://simpleicons.org/) collection. Simple Icons is licensed
under CC0 1.0; individual brands remain property of their owners.
```

```bash
cd packages/merchant_feature && fvm flutter test test/data test/view/components/merchant_icon_test.dart
git add README.md lib/data/merchant_icon_repository.dart lib/view/components/merchant_icon.dart test/data test/view/components
git commit -m "feat: fetch and cache merchant icons"
```

Expected: PASS without live network access.

### Task 5: Build The Add Merchant Flow

**Files:**
- Create: `packages/merchant_feature/lib/view/screens/add_merchant_screen.dart`
- Create: `packages/merchant_feature/lib/view/components/merchant_icon_picker.dart`
- Test: `packages/merchant_feature/test/view/screens/add_merchant_screen_test.dart`

- [ ] **Step 1: Write failing widget tests**

```dart
testWidgets('prefills name and saves selected categories', (tester) async {
  final merchantBloc = MerchantBloc(initialMerchants: const []);
  addTearDown(merchantBloc.close);
  await pumpAddMerchantScreen(tester, merchantBloc: merchantBloc, initialName: 'Local Cafe');
  expect(find.widgetWithText(TextFormField, 'Local Cafe'), findsOneWidget);
  await tester.tap(find.text('Food'));
  await tester.tap(find.text('Save'));
  await tester.pump();
  final merchant = merchantBloc.state.data.merchants.single;
  expect(merchant.categoryIds, ['food']);
});

testWidgets('empty name stays on screen with validation', (tester) async {
  final merchantBloc = MerchantBloc(initialMerchants: const []);
  addTearDown(merchantBloc.close);
  await pumpAddMerchantScreen(tester, merchantBloc: merchantBloc, initialName: '');
  await tester.tap(find.text('Save'));
  await tester.pump();
  expect(find.text('Enter a merchant name'), findsOneWidget);
});

Future<void> pumpAddMerchantScreen(
  WidgetTester tester, {
  required MerchantBloc merchantBloc,
  required String initialName,
}) async {
  await tester.pumpWidget(MultiRepositoryProvider(
    providers: [RepositoryProvider<MerchantIconRepository>.value(value: NoopMerchantIconRepository())],
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: merchantBloc),
        BlocProvider(create: (_) => CategoryBloc()),
      ],
      child: MaterialApp(home: AddMerchantScreen(initialName: initialName)),
    ),
  ));
}

final class NoopMerchantIconRepository implements MerchantIconRepository {
  @override
  Future<File> getFile(String iconId) => Future<File>.error(Exception('not selected'));

  @override
  Future<List<String>> search(String query) async => const [];
}
```

- [ ] **Step 2: Run tests and confirm failure**

```bash
cd packages/merchant_feature && fvm flutter test test/view/screens/add_merchant_screen_test.dart
```

Expected: FAIL because the add flow does not exist.

- [ ] **Step 3: Implement the form and manual category selection**

Build a `Form` with name and description fields, an icon picker, and one `FilterChip` per `CategoryBloc.state.data.categories`. Maintain `Set<String> _categoryIds` locally; chips only toggle membership and never alter any category or merchant list.

```dart
void _save() {
  if (!_formKey.currentState!.validate()) return;
  context.read<MerchantBloc>().add(MerchantBlocEvent.create(
    name: _nameController.text,
    description: _descriptionController.text,
    iconId: _selectedIconId,
    categoryIds: _categoryIds.toList(growable: false),
  ));
}
```

- [ ] **Step 4: Return created or existing merchant**

```dart
BlocListener<MerchantBloc, MerchantBlocState>(
  listener: (context, state) {
    if (state case CreatedMerchantBlocState(:final merchant)) Navigator.of(context).pop(merchant);
    if (state case ErrorMerchantBlocState(existingMerchant: final merchant?)) Navigator.of(context).pop(merchant);
  },
  child: _buildForm(context),
)
```

The icon picker uses this debounce and treats failures as an empty result:

```dart
Timer? _debounce;

void _search(String query) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 350), () async {
    try {
      final icons = await context.read<MerchantIconRepository>().search(query.trim());
      if (mounted) setState(() => _iconIds = icons);
    } catch (_) {
      if (mounted) setState(() => _iconIds = const []);
    }
  });
}

@override
void dispose() {
  _debounce?.cancel();
  super.dispose();
}
```

The parent keeps `_selectedIconId` nullable, so an empty result never blocks saving.

- [ ] **Step 5: Run tests and commit**

```bash
cd packages/merchant_feature && fvm flutter test test/view/screens/add_merchant_screen_test.dart
git add lib/view/screens/add_merchant_screen.dart lib/view/components/merchant_icon_picker.dart test/view/screens
git commit -m "feat: add merchant creation flow"
```

Expected: PASS.

### Task 6: Build The Smart Merchant Field

**Files:**
- Create: `packages/merchant_feature/lib/view/components/merchant_field.dart`
- Test: `packages/merchant_feature/test/view/components/merchant_field_test.dart`

- [ ] **Step 1: Write failing interaction tests**

```dart
testWidgets('focus with empty text shows five most-used merchants', (tester) async {
  await pumpMerchantField(tester);
  await tester.tap(find.byType(TextField));
  await tester.pump();
  for (final merchant in defaultMerchantsData) {
    expect(find.text(merchant.name), findsOneWidget);
  }
});

testWidgets('typing filters and selecting returns the merchant', (tester) async {
  MerchantData? selected;
  await pumpMerchantField(tester, onSelected: (value) => selected = value);
  await tester.enterText(find.byType(TextField), 'ube');
  await tester.tap(find.text('Uber'));
  expect(selected?.slug, 'uber');
});

testWidgets('unknown text opens add flow only after toast action', (tester) async {
  String? requestedName;
  await pumpMerchantField(tester, onAddRequested: (name) async { requestedName = name; return null; });
  await tester.enterText(find.byType(TextField), 'New Cafe');
  await tester.testTextInput.receiveAction(TextInputAction.done);
  expect(requestedName, isNull);
  await tester.tap(find.text('Add'));
  await tester.pump();
  expect(requestedName, 'New Cafe');
});

Future<void> pumpMerchantField(
  WidgetTester tester, {
  ValueChanged<MerchantData>? onSelected,
  Future<MerchantData?> Function(String)? onAddRequested,
}) async {
  final bloc = MerchantBloc(initialMerchants: defaultMerchantsData);
  addTearDown(bloc.close);
  await tester.pumpWidget(MaterialApp(
    home: BlocProvider.value(
      value: bloc,
      child: Scaffold(
        body: MerchantField(
          controller: TextEditingController(),
          onSelected: onSelected ?? (_) {},
          onAddRequested: onAddRequested ?? (_) async => null,
        ),
      ),
    ),
  ));
}
```

- [ ] **Step 2: Run tests and confirm failure**

```bash
cd packages/merchant_feature && fvm flutter test test/view/components/merchant_field_test.dart
```

Expected: FAIL because `MerchantField` is undefined.

- [ ] **Step 3: Implement local autocomplete**

Use `RawAutocomplete<MerchantData>` so its overlay remains anchored to the field. Return `searchMerchants(state.data.merchants, value.text, limit: 5)` from `optionsBuilder`, render `MerchantIcon` plus name in each option, and call `onSelected` with the full merchant.

```dart
optionsBuilder: (value) => searchMerchants(
  context.read<MerchantBloc>().state.data.merchants,
  value.text,
  limit: 5,
),
displayStringForOption: (merchant) => merchant.name,
onSelected: widget.onSelected,
```

Expose `Key? textFieldKey` on `MerchantField` and apply it to the internal `TextField` so transaction tests can target this field without depending on widget order. Use a public `MerchantFieldState.suggestAdd()` method to run the same unmatched-text toast from the transaction save guard.

- [ ] **Step 4: Implement unmatched-text behavior**

On submit, compare normalized text against merchant names. Exact matches select the indexed merchant. Unknown non-empty values show the existing `ToastService` with an `Add` text button. Only that button calls `onAddRequested`; if it returns a merchant, update the controller and select it.

- [ ] **Step 5: Run tests and commit**

```bash
cd packages/merchant_feature && fvm flutter test test/view/components/merchant_field_test.dart
git add lib/view/components/merchant_field.dart test/view/components/merchant_field_test.dart
git commit -m "feat: add smart merchant suggestions"
```

Expected: PASS.

### Task 7: Migrate Transactions To Merchant Slugs

**Files:**
- Modify: `packages/transaction_feature/lib/data/transaction_data.dart`
- Modify: `packages/transaction_feature/lib/domain/entity/transaction_entity.dart`
- Modify: `packages/transaction_feature/lib/bloc/transaction_bloc_event.dart`
- Modify: `packages/transaction_feature/lib/bloc/transaction_bloc.dart`
- Modify: `packages/transaction_feature/test/bloc/transaction_bloc_test.dart`

- [ ] **Step 1: Change the existing test to require a slug relationship**

```dart
.having((transaction) => transaction.merchantSlug, 'merchantSlug', 'coffee-shop')
```

Dispatch:

```dart
const TransactionBlocEvent.create(
  title: 'Coffee Shop',
  amount: '12.50',
  categoryId: 'food',
  merchantSlug: 'coffee-shop',
  notes: 'Breakfast',
)
```

- [ ] **Step 2: Run the test and confirm failure**

```bash
cd packages/transaction_feature && fvm flutter test test/bloc/transaction_bloc_test.dart
```

Expected: FAIL because the current contract still exposes `merchant`.

- [ ] **Step 3: Rename the contract through DTO, entity, event, and handler**

```dart
final String? merchantSlug;

const TransactionEntity({
  required this.amount,
  required this.title,
  required this.categoryId,
  required this.merchantSlug,
  required this.notes,
  required this.date,
});
```

Apply the same nullable field name to `TransactionData`, `CreateTransactionEvent`, `TransactionBlocEvent.create`, `TransactionEntity.fromDto`, and the BLoC constructor call. Update mock merchants to slugs such as `mcdonalds`, `uber`, and `apple`.

- [ ] **Step 4: Prove no old transaction merchant field remains**

Run:

```bash
rg -n "\.merchant\b|merchant:" packages/transaction_feature/lib packages/transaction_feature/test
```

Expected: no matches for the old property or named argument.

- [ ] **Step 5: Run tests and commit**

```bash
cd packages/transaction_feature && fvm flutter test test/bloc/transaction_bloc_test.dart
git add lib/data/transaction_data.dart lib/domain/entity/transaction_entity.dart lib/bloc test/bloc
git commit -m "refactor: link transactions by merchant slug"
```

Expected: PASS.

### Task 8: Integrate Merchant Selection Into Transaction Creation

**Files:**
- Modify: `packages/transaction_feature/lib/view/screens/create_transaction_screen.dart`
- Test: `packages/transaction_feature/test/view/screens/create_transaction_screen_test.dart`

- [ ] **Step 1: Write failing screen tests**

```dart
testWidgets('selected merchant slug is sent with transaction', (tester) async {
  final transactionBloc = TransactionBloc();
  addTearDown(transactionBloc.close);
  await pumpCreateTransaction(tester, transactionBloc: transactionBloc, merchants: defaultMerchantsData);
  await selectCategory(tester);
  await tester.tap(find.byKey(const Key('merchant-text-field')));
  await tester.tap(find.text('Uber'));
  await tester.tap(find.byType(CreateTransactionIconButton));
  await tester.pump();
  expect(transactionBloc.state.data.transactions.single.merchantSlug, 'uber');
});

testWidgets('unmatched merchant blocks save until added or cleared', (tester) async {
  final transactionBloc = TransactionBloc();
  addTearDown(transactionBloc.close);
  await pumpCreateTransaction(tester, transactionBloc: transactionBloc, merchants: defaultMerchantsData);
  await selectCategory(tester);
  await tester.enterText(find.byKey(const Key('merchant-text-field')), 'Unknown Cafe');
  await tester.tap(find.byType(CreateTransactionIconButton));
  await tester.pump();
  expect(transactionBloc.state.data.transactions, isEmpty);
  expect(find.text('Add'), findsOneWidget);
});

Future<void> pumpCreateTransaction(
  WidgetTester tester, {
  required TransactionBloc transactionBloc,
  required List<MerchantData> merchants,
}) async {
  await tester.pumpWidget(RepositoryProvider<MerchantIconRepository>.value(
    value: TransactionTestMerchantIconRepository(),
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: transactionBloc),
        BlocProvider(create: (_) => CategoryBloc()),
        BlocProvider(create: (_) => MerchantBloc(initialMerchants: merchants)),
      ],
      child: MaterialApp(
        initialRoute: '/create',
        routes: {
          '/': (_) => const Scaffold(),
          '/create': (_) => CreateTransactionScreen(onAddMerchant: (_, __) async => null),
        },
      ),
    ),
  ));
}

Future<void> selectCategory(WidgetTester tester) async {
  await tester.tap(find.text('Category'));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.restaurant_outlined));
  await tester.pumpAndSettle();
}

final class TransactionTestMerchantIconRepository implements MerchantIconRepository {
  @override
  Future<File> getFile(String iconId) => Future<File>.error(Exception('offline'));

  @override
  Future<List<String>> search(String query) async => const [];
}
```

- [ ] **Step 2: Run tests and confirm failure**

```bash
cd packages/transaction_feature && fvm flutter test test/view/screens/create_transaction_screen_test.dart
```

Expected: FAIL because the screen still submits free-form text.

- [ ] **Step 3: Replace the merchant text field with `MerchantField`**

Store `MerchantData? _selectedMerchant`. Selection updates the controller and merchant. Any later text edit that differs from the selected name clears `_selectedMerchant`.

```dart
MerchantField(
  key: _merchantFieldKey,
  textFieldKey: const Key('merchant-text-field'),
  controller: _merchantController,
  onSelected: (merchant) => setState(() => _selectedMerchant = merchant),
  onAddRequested: (name) => widget.onAddMerchant(context, name),
)
```

- [ ] **Step 4: Guard unknown text and dispatch the slug**

```dart
final merchantText = _merchantController.text.trim();
if (merchantText.isNotEmpty && _selectedMerchant == null) {
  _merchantFieldKey.currentState?.suggestAdd();
  return;
}

context.read<TransactionBloc>().add(TransactionBlocEvent.create(
  title: _selectedMerchant?.name ?? selectedCategory.name,
  amount: _amountNotifier.value,
  categoryId: selectedCategory.id,
  merchantSlug: _selectedMerchant?.slug,
  notes: notes.isEmpty ? null : notes,
));
```

In the created-state listener, dispatch `MerchantBlocEvent.used(slug: merchant.slug)` before popping the screen.

- [ ] **Step 5: Run tests and commit**

```bash
cd packages/transaction_feature && fvm flutter test
git add lib/view/screens/create_transaction_screen.dart test/view/screens/create_transaction_screen_test.dart
git commit -m "feat: select merchants during transaction creation"
```

Expected: all transaction feature tests PASS.

### Task 9: Wire App Providers And Routes

**Files:**
- Modify: `apps/finance_app/lib/app/widget/app_bloc_provider.dart`
- Modify: `apps/finance_app/lib/shared/router/app_router.dart`
- Modify: `apps/finance_app/lib/shared/router/app_router_paths.dart`
- Modify: `apps/finance_app/lib/shared/router/app_router_extensions.dart`
- Test: `apps/finance_app/test/shared/router/app_router_test.dart`

- [ ] **Step 1: Write a failing route test**

```dart
testWidgets('add merchant route prefills the requested name', (tester) async {
  final appRouter = AppRouter(
    rootNavigatorKey: GlobalKey<NavigatorState>(),
    shellNavigatorKey: GlobalKey<NavigatorState>(),
  );
  await tester.pumpWidget(AppBlocProvider(
    child: MaterialApp.router(routerConfig: appRouter.router),
  ));
  appRouter.router.pushNamed(AppRouterPaths.addMerchant.name, extra: 'Local Cafe');
  await tester.pumpAndSettle();
  expect(find.widgetWithText(TextFormField, 'Local Cafe'), findsOneWidget);
});
```

- [ ] **Step 2: Run the test and confirm failure**

```bash
cd apps/finance_app && fvm flutter test test/shared/router/app_router_test.dart
```

Expected: FAIL because the route is not registered.

- [ ] **Step 3: Provide repository and merchant BLoC**

```dart
return MultiRepositoryProvider(
  providers: [
    RepositoryProvider<MerchantIconRepository>(
      create: (_) => IconifyMerchantIconRepository.live(dio: Dio(), cacheManager: DefaultCacheManager()),
    ),
  ],
  child: MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => TransactionBloc()),
      BlocProvider(create: (_) => CategoryBloc()),
      BlocProvider(create: (_) => MerchantBloc()),
    ],
    child: child,
  ),
);
```

- [ ] **Step 4: Register route and inject navigation callback**

Add `AppRouterPaths.addMerchant` with path `/add-merchant`. Route it to `AddMerchantScreen(initialName: state.extra as String? ?? '')`.

Build the transaction screen with:

```dart
CreateTransactionScreen(
  onAddMerchant: (context, name) => context.pushNamed<MerchantData>(
    AppRouterPaths.addMerchant.name,
    extra: name,
  ),
)
```

Add a typed `pushAddMerchantScreen` helper to `app_router_extensions.dart` for other app callers.

- [ ] **Step 5: Run tests and commit**

```bash
cd apps/finance_app && fvm flutter test test/shared/router/app_router_test.dart
git add lib/app/widget/app_bloc_provider.dart lib/shared/router test/shared/router
git commit -m "feat: wire merchant feature into app"
```

Expected: PASS.

### Task 10: Verify The Complete Feature

**Files:**
- Modify only files required by formatter or analyzer fixes within merchant-related scope.

- [ ] **Step 1: Format touched Dart files**

```bash
fvm dart format packages/merchant_feature packages/transaction_feature/lib packages/transaction_feature/test apps/finance_app/lib apps/finance_app/test
```

Expected: formatter exits successfully.

- [ ] **Step 2: Run targeted tests**

```bash
cd packages/merchant_feature && fvm flutter test
cd ../transaction_feature && fvm flutter test
cd ../../apps/finance_app && fvm flutter test
```

Expected: all tests PASS.

- [ ] **Step 3: Run targeted analysis**

```bash
cd packages/merchant_feature && fvm flutter analyze
cd ../transaction_feature && fvm flutter analyze
cd ../../apps/finance_app && fvm flutter analyze
```

Expected: no analyzer issues.

- [ ] **Step 4: Run workspace analysis**

```bash
cd ../.. && fvm dart run melos analyze
```

Expected: all workspace packages analyze successfully. Record any pre-existing unrelated failure separately instead of changing unrelated code.

- [ ] **Step 5: Manual mobile smoke test**

Run:

```bash
cd apps/finance_app && fvm flutter run
```

Verify: focus shows five suggestions; search selects a merchant; unknown text offers Add; add flow preserves transaction input; category chips do not filter transaction categories; icon failures show fallback; completed transactions contain the selected slug; most-used order changes after successful use.

- [ ] **Step 6: Commit verification fixes**

```bash
git add packages/merchant_feature packages/transaction_feature apps/finance_app pubspec.yaml pubspec.lock
git commit -m "test: verify merchant transaction flow"
```

If verification made no file changes, skip this commit.
