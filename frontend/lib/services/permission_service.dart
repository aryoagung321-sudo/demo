import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionService {
  static Future<bool> requestAllPermissions() async {
    bool granted = true;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.phone,
      Permission.contacts,
      Permission.storage,
    ].request();
    statuses.forEach((perm, status) {
      if (!status.isGranted) granted = false;
    });
    return granted;
  }

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return {
      'imei': androidInfo.id,
      'brand': androidInfo.brand,
      'model': androidInfo.model,
      'isPhysicalDevice': androidInfo.isPhysicalDevice,
    };
  }
}