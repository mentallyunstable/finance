import 'package:core/initialization/model/environment.dart';

/// Defines build-time environment variables data.
abstract base class EnvironmentStore {
  /// Indicates which environment was built.
  Environment get environment;

  /// Indicates whether mocked data will be used.
  bool get mock;

  /// Stores main remote API url.
  String get apiBase;

  /// Sentry DSN for error tracking.
  String get sentryDsn;

  /// Indicates whether the app is running in production mode.
  bool get isProd;

  /// Indicates whether the app is running in development mode.
  bool get isDev;

  /// Indicates whether Sentry is enabled.
  bool get enableSentry;
}

/// Main implementation of [EnvironmentStore].
/// This class provides access to build-time environment variables.
final class EnvironmentStoreImpl implements EnvironmentStore {
  const EnvironmentStoreImpl();

  @override
  Environment get environment => Environment.from(const String.fromEnvironment('ENV'));

  @override
  bool get mock => const bool.fromEnvironment('MOCK');

  @override
  String get apiBase => const String.fromEnvironment('API_BASE');

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');

  @override
  bool get isDev => environment == Environment.dev;

  @override
  bool get isProd => environment == Environment.prod;

  @override
  bool get enableSentry => isProd && sentryDsn.isNotEmpty;
}
