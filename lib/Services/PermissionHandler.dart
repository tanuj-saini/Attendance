import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  var status = await Permission.locationWhenInUse.status;
  if (!status.isGranted) {
    await Permission.locationWhenInUse.request();
  }

  if (!await Permission.locationWhenInUse.isGranted) {
    print('Location permission is required to scan Wi-Fi networks.');
    return;
  }

  // Check if location services are enabled on the device
  if (!await Permission.location.serviceStatus.isEnabled) {
    print('Location services are disabled. Please enable them.');
    // Optionally, direct the user to the location settings
  }
}
