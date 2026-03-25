import 'package:finance_app/app/dependencies/model/permanent_data_source_dependencies.dart';
import 'package:finance_app/app/dependencies/model/remote_data_source_dependencies.dart';
import 'package:finance_app/app/dependencies/model/repository_dependencies.dart';

/// Defines [RepositoryDependencies] instance initialization.
abstract class RepositoryInitializer {
  /// Initialize and return [RepositoryDependencies] instance.
  RepositoryDependencies initialize({
    required PermanentDataSourceDependencies permanentDataSources,
    required RemoteDataSourceDependencies remoteDataSources,
  });
}

/// Main implementation of [RepositoryInitializer].
final class RepositoryInitializerImpl extends RepositoryInitializer {
  @override
  RepositoryDependencies initialize({
    required final PermanentDataSourceDependencies permanentDataSources,
    required final RemoteDataSourceDependencies remoteDataSources,
  }) {
    return const RepositoryDependenciesImpl();
  }
}
