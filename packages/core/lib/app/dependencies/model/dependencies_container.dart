import 'package:core/app/dependencies/model/permanent_data_source_dependencies.dart';
import 'package:core/app/dependencies/model/remote_data_source_dependencies.dart';
import 'package:core/app/dependencies/model/repository_dependencies.dart';
import 'package:core/app/dependencies/model/service_dependencies.dart';
import 'package:core/constant/app_config.dart';
import 'package:flutter/material.dart' show GlobalKey, NavigatorState;

abstract base class DependenciesContainer {
  const DependenciesContainer({
    required this.config,
    required this.navigatorKey,
    required this.permanentDataSources,
    required this.remoteDataSources,
    required this.repositories,
    required this.services,
  });

  /// Application configuration.
  final AppConfig config;

  /// Global navigator key for the app.
  final GlobalKey<NavigatorState> navigatorKey;

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
    required super.permanentDataSources,
    required super.remoteDataSources,
    required super.repositories,
    required super.services,
  });
}
