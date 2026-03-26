import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  const PermissionService();

  Future<PermissionStatus> cameraPermissionStatus() async => await Permission.camera.status;

  Future<PermissionStatus> requestCameraPermission() async => await Permission.camera.request();

  Future<PermissionStatus> locationPermissionStatus() async => await Permission.location.status;

  Future<PermissionStatus> requestLocationPermission() async => await Permission.location.request();

  Future<PermissionStatus> microphonePermissionStatus() async => await Permission.microphone.status;

  Future<PermissionStatus> requestMicrophonePermission() async => await Permission.microphone.request();
}
