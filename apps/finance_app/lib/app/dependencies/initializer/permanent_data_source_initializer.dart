import 'package:finance_app/app/dependencies/model/permanent_data_source_dependencies.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Defines [PermanentDataSourceDependencies] instance initialization.
abstract class PermanentDataSourceInitializer {
  /// Initialize and return [PermanentDataSourceDependencies] instance.
  PermanentDataSourceDependencies initialize({
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage secureStorage,
  });
}

/// Main implementation of [PermanentDataSourceInitializer].
final class PermanentDataSourceInitializerImpl extends PermanentDataSourceInitializer {
  @override
  PermanentDataSourceDependencies initialize({
    required final SharedPreferences sharedPreferences,
    required final FlutterSecureStorage secureStorage,
  }) {
    return const PermanentDataSourceDependenciesImpl();
  }
}
