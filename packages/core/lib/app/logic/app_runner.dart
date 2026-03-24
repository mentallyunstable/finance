// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:core/app/widget/app_widget.dart';
import 'package:core/constant/app_config.dart';
import 'package:core/initialization/logic/initialization_processor.dart';
import 'package:core/initialization/widget/initialization_failed_app.dart';
import 'package:core/utils/app_bloc_observer.dart';
import 'package:core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A class which is responsible for initialization and running the app.
/// {@endtemplate}
final class AppRunner {
  final AppConfig config;

  /// {@macro app_runner}
  const AppRunner({required this.config});

  /// Start the initialization and in case of success run application
  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();

    // TODO: uncomment if project uses Firebase services
    // Initialize Firebase
    // if (Firebase.apps.isEmpty) {
    //   await Firebase.initializeApp(
    //     options: config.firebaseOptions,
    //   );
    // }

    // TODO: uncomment if project uses easy_localization package
    // Initialize localization
    // await EasyLocalization.ensureInitialized();
    // EasyLocalization.logger.enableLevels = [LevelMessages.error, LevelMessages.warning];

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Preserve splash screen
    binding.deferFirstFrame();

    // Override logging
    FlutterError.onError = logger.logFlutterError;
    WidgetsBinding.instance.platformDispatcher.onError = logger.logPlatformDispatcherError;

    // Setup bloc observer and transformer
    Bloc.observer = AppBlocObserver(logger: logger);

    // TODO: uncomment if project uses chucker_flutter package
    // ChuckerFlutter.showNotification = false;
    // ChuckerFlutter.showOnRelease = config.environmentStore.environment == Environment.dev;

    // TODO: uncomment if project uses sentry_flutter package
    // // Enable Sentry for prod builds
    // if (config.environmentStore.enableSentry) {
    //   final dsn = config.environmentStore.sentryDsn;
    //
    //   if (dsn.isNotEmpty) {
    //     await SentryFlutter.init(
    //       (options) {
    //         options.dsn = dsn;
    //       },
    //     );
    //   }
    // }

    final processor = InitializationProcessor(config: config);

    // Run the app
    await _initializeAndRun(binding, processor);
  }

  Future<void> _initializeAndRun(
    final WidgetsBinding binding,
    final IInitializationProcessor initializationProcessor,
  ) async {
    try {
      final result = await initializationProcessor.initialize();
      // Attach this widget to the root of the tree.
      runApp(AppWidget(result: result));
    } catch (exception, stackTrace) {
      logger.error('Initialization failed', exception: exception, stackTrace: stackTrace);
      runApp(
        InitializationFailedApp(
          exception: exception,
          stackTrace: stackTrace,
          retryInitialization: initializeAndRun,
        ),
      );
    } finally {
      // Allow rendering
      binding.allowFirstFrame();
    }
  }
}
