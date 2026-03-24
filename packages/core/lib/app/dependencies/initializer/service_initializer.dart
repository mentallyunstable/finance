import 'package:core/app/dependencies/model/service_dependencies.dart';
import 'package:core/constant/app_config.dart';
import 'package:core/services/modal_sheet_service.dart';
import 'package:core/services/permission_service.dart';
import 'package:core/services/toast_service.dart';
import 'package:core/services/url_launcher_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Defines [ServiceDependencies] instance initialization.
abstract class ServiceInitializer {
  /// Initialize and return [ServiceDependencies] instance.
  Future<ServiceDependencies> initialize({
    required AppConfig config,
    required GlobalKey<NavigatorState> navigatorKey,
  });
}

/// Main implementation of [ServiceInitializer].
final class ServiceInitializerImpl extends ServiceInitializer {
  @override
  Future<ServiceDependencies> initialize({
    required final AppConfig config,
    required final GlobalKey<NavigatorState> navigatorKey,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    const secureStorage = FlutterSecureStorage();

    const timeoutDuration = Duration(seconds: 15);
    final dio = Dio(
      BaseOptions(
        baseUrl: config.environmentStore.apiBase,
        connectTimeout: timeoutDuration,
        receiveTimeout: timeoutDuration,
        sendTimeout: timeoutDuration,
      ),
    );

    dio.interceptors.addAll([
      PrettyDioLogger(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ),
    ]);

    const urlLauncherService = UrlLauncherService();

    const permissionService = PermissionService();

    final toastService = ToastService(fToast: FToast());

    const modalSheetService = ModalSheetService();

    return ServiceDependenciesImpl(
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
      dio: dio,
      urlLauncherService: urlLauncherService,
      permissionService: permissionService,
      toastService: toastService,
      modalSheetService: modalSheetService,
    );
  }
}
