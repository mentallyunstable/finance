import 'package:dio/dio.dart';
import 'package:finance_app/app/dependencies/model/remote_data_source_dependencies.dart';

/// Defines [RemoteDataSourceDependencies] instance initialization.
abstract class RemoteDataSourceInitializer {
  /// Initialize and return [RemoteDataSourceDependencies] instance.
  RemoteDataSourceDependencies initialize({
    required Dio dio,
  });
}

/// Main implementation of [RemoteDataSourceInitializer].
final class RemoteDataSourceInitializerImpl extends RemoteDataSourceInitializer {
  @override
  RemoteDataSourceDependencies initialize({required final Dio dio}) {
    return const RemoteDataSourceDependenciesImpl();
  }
}
