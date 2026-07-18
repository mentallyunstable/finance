import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:merchant_feature/data/iconify_merchant_icon_repository.dart';

void main() {
  test('constructs the Iconify search request and filters to Simple Icons IDs', () async {
    Uri? requestedUri;
    final repository = IconifyMerchantIconRepository(
      jsonLoader: (uri) async {
        requestedUri = uri;
        return {
          'icons': [
            'simple-icons:starbucks',
            'mdi:coffee',
            42,
            'simple-icons:uber',
          ],
        };
      },
      fileLoader: (_) async => File('unused.svg'),
    );

    final result = await repository.search('coffee shop');

    expect(result, ['simple-icons:starbucks', 'simple-icons:uber']);
    expect(requestedUri?.scheme, 'https');
    expect(requestedUri?.host, 'api.iconify.design');
    expect(requestedUri?.path, '/search');
    expect(requestedUri?.queryParameters, {
      'query': 'coffee shop',
      'prefixes': 'simple-icons',
      'limit': '8',
    });
  });

  test('loads the exact Iconify SVG URL through the injected file loader', () async {
    String? requestedUrl;
    final expectedFile = File('starbucks.svg');
    final repository = IconifyMerchantIconRepository(
      jsonLoader: (_) async => const {},
      fileLoader: (url) async {
        requestedUrl = url;
        return expectedFile;
      },
    );

    final result = await repository.getFile('simple-icons:starbucks');

    expect(result, same(expectedFile));
    expect(requestedUrl, 'https://api.iconify.design/simple-icons:starbucks.svg');
  });
}
