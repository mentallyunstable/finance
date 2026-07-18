import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:merchant_feature/data/merchant_icon_repository.dart';

typedef IconifyJsonLoader = Future<Map<String, dynamic>> Function(Uri uri);
typedef MerchantIconFileLoader = Future<File> Function(String url);

final class IconifyMerchantIconRepository implements MerchantIconRepository {
  static const _host = 'api.iconify.design';

  final IconifyJsonLoader _jsonLoader;
  final MerchantIconFileLoader _fileLoader;

  IconifyMerchantIconRepository({
    Dio? dio,
    BaseCacheManager? cacheManager,
    IconifyJsonLoader? jsonLoader,
    MerchantIconFileLoader? fileLoader,
  }) : _jsonLoader = jsonLoader ?? _dioLoader(dio ?? Dio()),
       _fileLoader = fileLoader ?? _cacheLoader(cacheManager ?? DefaultCacheManager());

  @override
  Future<List<String>> search(String query) async {
    final uri = Uri.https(_host, '/search', {
      'query': query,
      'prefixes': 'simple-icons',
      'limit': '8',
    });
    final json = await _jsonLoader(uri);
    final icons = json['icons'];
    if (icons is! List) {
      return const [];
    }

    return icons.whereType<String>().where((iconId) => iconId.startsWith('simple-icons:')).toList(growable: false);
  }

  @override
  Future<File> getFile(String iconId) {
    final url = Uri.https(_host, '/$iconId.svg').toString();
    return _fileLoader(url);
  }

  static IconifyJsonLoader _dioLoader(Dio dio) {
    return (uri) async {
      final response = await dio.getUri<Map<String, dynamic>>(uri);
      return response.data ?? const {};
    };
  }

  static MerchantIconFileLoader _cacheLoader(BaseCacheManager cacheManager) {
    return (url) => cacheManager.getSingleFile(url);
  }
}
