import 'package:core/services/modal_sheet_service.dart';
import 'package:core/services/permission_service.dart';
import 'package:core/services/toast_service.dart';
import 'package:core/services/url_launcher_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Defines all services and third-party dependencies.
abstract class ServiceDependencies {
  /// Shared preferences for persistent storage.
  final SharedPreferences sharedPreferences;

  /// Secure storage for sensitive data.
  final FlutterSecureStorage secureStorage;

  /// Dio instance for HTTP requests.
  final Dio dio;

  /// Service for launching URLs.
  final UrlLauncherService urlLauncherService;

  /// Service for handling permissions.
  final PermissionService permissionService;

  /// Service for displaying toasts.
  final ToastService toastService;

  /// Service for displaying modal sheets.
  final ModalSheetService modalSheetService;

  const ServiceDependencies({
    required this.sharedPreferences,
    required this.secureStorage,
    required this.dio,
    required this.urlLauncherService,
    required this.permissionService,
    required this.toastService,
    required this.modalSheetService,
  });
}

/// Main implementation of [ServiceDependencies].
final class ServiceDependenciesImpl extends ServiceDependencies {
  const ServiceDependenciesImpl({
    required super.sharedPreferences,
    required super.secureStorage,
    required super.dio,
    required super.urlLauncherService,
    required super.permissionService,
    required super.toastService,
    required super.modalSheetService,
  });
}
