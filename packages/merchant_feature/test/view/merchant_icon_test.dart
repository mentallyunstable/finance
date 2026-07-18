import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merchant_feature/data/merchant_icon_repository.dart';
import 'package:merchant_feature/view/merchant_icon.dart';

void main() {
  testWidgets('shows the storefront fallback when iconId is null', (tester) async {
    await tester.pumpWidget(_app(const MerchantIcon(iconId: null, size: 30)));

    expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
    expect(find.byType(SvgPicture), findsNothing);
  });

  testWidgets('keeps a stable size while the icon file is loading', (tester) async {
    final fileCompleter = Completer<File>();
    final repository = _FakeMerchantIconRepository(
      getFile: (_) => fileCompleter.future,
    );

    await tester.pumpWidget(
      _app(MerchantIcon(iconId: 'simple-icons:starbucks', repository: repository, size: 32)),
    );

    final box = tester.widget<SizedBox>(
      find
          .ancestor(
            of: find.byIcon(Icons.storefront_outlined),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    expect(box.width, 32);
    expect(box.height, 32);
  });

  testWidgets('shows the storefront fallback when file loading fails', (tester) async {
    final repository = _FakeMerchantIconRepository(
      getFile: (_) => Future.error(StateError('cache failed')),
    );

    await tester.pumpWidget(
      _app(MerchantIcon(iconId: 'simple-icons:starbucks', repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
  });

  testWidgets('shows the storefront fallback when SVG rendering fails', (tester) async {
    final repository = _FakeMerchantIconRepository(
      getFile: (_) async => File('nosuchfile'),
    );

    await tester.pumpWidget(
      _app(MerchantIcon(iconId: 'simple-icons:invalid', repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
  });

  testWidgets('renders a cached SVG file without network access', (tester) async {
    final fileCompleter = Completer<File>();
    final repository = _FakeMerchantIconRepository(
      getFile: (_) => fileCompleter.future,
    );

    await tester.pumpWidget(
      _app(MerchantIcon(iconId: 'simple-icons:local', repository: repository, size: 28)),
    );
    fileCompleter.complete(File('cached.svg'));
    await tester.pump();

    final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
      picture.bytesLoader,
      isA<SvgFileLoader>().having((loader) => loader.file.path, 'file path', 'cached.svg'),
    );
  });
}

Widget _app(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

final class _FakeMerchantIconRepository implements MerchantIconRepository {
  final Future<File> Function(String iconId) _getFile;

  const _FakeMerchantIconRepository({
    required Future<File> Function(String iconId) getFile,
  }) : _getFile = getFile;

  @override
  Future<File> getFile(String iconId) => _getFile(iconId);

  @override
  Future<List<String>> search(String query) async => const [];
}
