import 'dart:async';

import 'package:core/app/logic/app_runner.dart';
import 'package:core/constant/app_config.dart';
import 'package:core/initialization/model/environment_store.dart';
import 'package:core/utils/logger.dart';

/// The entry point for the production build of the application.
void main() {
  // Create app config with environment store
  const environmentStore = EnvironmentStoreImpl();
  const config = AppConfig(
    environmentStore: environmentStore,
    logNetwork: false,
    // TODO: uncomment if project uses Firebase services
    // firebaseOptions: ProdFirebaseOptions.currentPlatform,
  );

  // Run the app within a zone to catch errors
  runZonedGuarded(
    () => const AppRunner(config: config).initializeAndRun(),
    logger.logZoneError,
  );
}
