import 'package:finance_app/app/initialization/model/environment_store.dart';

/// Defines app configuration options.
final class AppConfig {
  const AppConfig({
    required this.environmentStore,
    required this.logNetwork,
    // required this.firebaseOptions,
  });

  /// Stores environment variables.
  final EnvironmentStore environmentStore;

  /// Controls whether network data will be logged.
  final bool logNetwork;

  // TODO: uncomment if project uses Firebase services
  // final FirebaseOptions firebaseOptions;
}
