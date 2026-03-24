import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  const PermissionService();

  Future<PermissionStatus> cameraPermissionStatus() async => await Permission.camera.status;

  Future<PermissionStatus> requestCameraPermission() async => await Permission.camera.request();

  Future<PermissionStatus> requestLocationPermission() async => await Permission.location.request();
}
