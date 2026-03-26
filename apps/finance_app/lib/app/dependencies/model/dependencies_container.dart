import 'package:core/constant/app_config.dart';
import 'package:finance_app/app/dependencies/model/permanent_data_source_dependencies.dart';
import 'package:finance_app/app/dependencies/model/remote_data_source_dependencies.dart';
import 'package:finance_app/app/dependencies/model/repository_dependencies.dart';
import 'package:finance_app/app/dependencies/model/service_dependencies.dart';
import 'package:finance_app/shared/router/app_router.dart';
import 'package:flutter/material.dart' show GlobalKey, NavigatorState;

abstract base class DependenciesContainer {
  const DependenciesContainer({
    required this.config,
    required this.navigatorKey,
    required this.router,
    required this.permanentDataSources,
    required this.remoteDataSources,
    required this.repositories,
    required this.services,
  });

  /// Application configuration.
  final AppConfig config;

  /// Global navigator key for the app.
  final GlobalKey<NavigatorState> navigatorKey;

  /// App router for navigation.
  final AppRouter router;

  /// Dependencies for permanent data sources.
  final PermanentDataSourceDependencies permanentDataSources;

  /// Dependencies for remote data sources.
  final RemoteDataSourceDependencies remoteDataSources;

  /// Dependencies for repositories.
  final RepositoryDependencies repositories;

  /// Dependencies for services.
  final ServiceDependencies services;
}

/// Main implementation of [DependenciesContainer].
final class DependenciesContainerImpl extends DependenciesContainer {
  const DependenciesContainerImpl({
    required super.config,
    required super.navigatorKey,
    required super.router,
    required super.permanentDataSources,
    required super.remoteDataSources,
    required super.repositories,
    required super.services,
  });
}
