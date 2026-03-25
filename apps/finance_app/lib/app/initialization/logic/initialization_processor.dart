import 'dart:async';

import 'package:core/constant/app_config.dart';
import 'package:core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:finance_app/app/dependencies/initializer/permanent_data_source_initializer.dart';
import 'package:finance_app/app/dependencies/initializer/remote_data_source_initializer.dart';
import 'package:finance_app/app/dependencies/initializer/repository_initializer.dart';
import 'package:finance_app/app/dependencies/initializer/service_initializer.dart';
import 'package:finance_app/app/dependencies/model/dependencies_container.dart';
import 'package:finance_app/app/dependencies/model/permanent_data_source_dependencies.dart';
import 'package:finance_app/app/dependencies/model/remote_data_source_dependencies.dart';
import 'package:finance_app/app/dependencies/model/repository_dependencies.dart';
import 'package:finance_app/app/dependencies/model/service_dependencies.dart';
import 'package:finance_app/app/initialization/model/initialization_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class InitializationProcessor implements IInitializationProcessor {
  final AppConfig config;

  const InitializationProcessor({required this.config});

  @override
  Future<InitializationResult> initialize() async {
    final stopwatch = Stopwatch()..start();

    logger.info('Start initializing application...');
    logger.info('Initializing dependencies...');
    final dependencies = await _initDependencies();
    logger.info('Dependencies initialized successfully.');
    stopwatch.stop();

    return InitializationResult(
      dependencies: dependencies,
      msSpent: stopwatch.elapsedMilliseconds,
    );
  }

  Future<DependenciesContainer> _initDependencies() async {
    final rootNavigatorKey = GlobalKey<NavigatorState>();

    final services = await _initServices(config: config, navigatorKey: rootNavigatorKey);

    final permanentDataSources = _initPermanentDataSources(
      services.sharedPreferences,
      services.secureStorage,
    );

    final remoteDataSources = _initRemoteDataSources(services.dio);

    final repositories = _initRepositories(permanentDataSources, remoteDataSources);

    return DependenciesContainerImpl(
      config: config,
      navigatorKey: rootNavigatorKey,
      services: services,
      permanentDataSources: permanentDataSources,
      remoteDataSources: remoteDataSources,
      repositories: repositories,
    );
  }

  Future<ServiceDependencies> _initServices({
    required final AppConfig config,
    required final GlobalKey<NavigatorState> navigatorKey,
  }) async {
    final initializer = ServiceInitializerImpl();

    return await initializer.initialize(config: config, navigatorKey: navigatorKey);
  }

  RepositoryDependencies _initRepositories(
    final PermanentDataSourceDependencies permanentDataSources,
    final RemoteDataSourceDependencies remoteDataSources,
  ) {
    final initializer = RepositoryInitializerImpl();

    return initializer.initialize(
      remoteDataSources: remoteDataSources,
      permanentDataSources: permanentDataSources,
    );
  }

  PermanentDataSourceDependencies _initPermanentDataSources(
    final SharedPreferences sharedPreferences,
    final FlutterSecureStorage secureStorage,
  ) {
    final initializer = PermanentDataSourceInitializerImpl();

    return initializer.initialize(
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
    );
  }

  RemoteDataSourceDependencies _initRemoteDataSources(final Dio dio) {
    final initializer = RemoteDataSourceInitializerImpl();

    return initializer.initialize(dio: dio);
  }
}

abstract interface class IInitializationProcessor {
  Future<InitializationResult> initialize();
}
