import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

import 'package:attendence/Model/UserSendData.dart';
import 'package:attendence/Screen/Controller/UserProfileController.dart';

import 'package:attendence/Utils/Colors.dart';
import 'package:attendence/Services/FilePicker.dart';
import 'package:attendence/Screen/Controller/SignContoller.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class UserDashBoard extends StatefulWidget {
  UserDashBoard({super.key});
  @override
  State<StatefulWidget> createState() {
    return _UserDashBoard();
  }
}

class _UserDashBoard extends State<UserDashBoard> {
  final Userprofilecontroller userRepos = Get.put((Userprofilecontroller()));
  final SignViewModelContoller signController =
      Get.put(SignViewModelContoller());

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _filePath;
  Uint8List? _filePathBytes;
  Uint8List? _imageBytes;
  String? dicveInfo;
  List<WiFiAccessPoint> networks = [];
  Position? _currentPosition;
  List<String> courseCodes = [
    "CS301",
    "CS361",
    "CS303",
    "CS363",
    "IK101*",
    "CS305",
    "CS307",
    "CS367",
    "CS309",
    "CS369",
    "CS391",
    "IT301",
    "IT361",
    "IT307",
    "IT367",
    "IT309",
    "IT391",
  ];
  String selectedCourse = "CS307"; //default

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _recorder = FlutterSoundRecorder();
    _initRecorder();
    scanNetworks();
    getDeviceInfo();
  }

  int _start = 50; // Initial time
  bool _isButtonDisabled = false;
  Timer? _timer;

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel any existing timer
    }

    setState(() {
      _isButtonDisabled = true;
      _start = 50; // Reset the timer
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        setState(() {
          _isButtonDisabled = false;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _requestPermissions() async {
    // Request both microphone and location permissions together
    var micPermission = await Permission.microphone.request();
    var locationPermission = await Permission.locationWhenInUse.request();

    if (micPermission.isDenied || locationPermission.isDenied) {
      // Show a dialog if any permission is denied
      _showPermissionDialog();
    }

    if (locationPermission.isGranted) {
      _determinePosition();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permissions Required'),
        content: Text(
            'Microphone and Location permissions are required. Please grant them in the app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _initRecorder() async {
    await _recorder!.openRecorder();
  }

  Future<void> _selectImage() async {
    Uint8List? imageBytes = await pickImageAsByte(ImageSource.camera);
    if (imageBytes != null) {
      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String androidDevice =
          'Android Device: ${androidInfo.model} - MAC Address: ${androidInfo.hardware}';
      setState(() {
        dicveInfo = androidDevice;
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      String iosDevice =
          'iOS Device: ${iosInfo.name} - Model: ${iosInfo.utsname.machine}';
      setState(() {
        dicveInfo = iosDevice;
      });
    }
    return 'Unknown Device';
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> scanNetworks() async {
    var locationPermission = await Permission.locationWhenInUse.status;
    if (!locationPermission.isGranted) {
      await _requestPermissions();
    }

    var canScan = await WiFiScan.instance.canStartScan();
    // if (!canScan) {
    //   print('Device does not support Wi-Fi scanning or it\'s restricted.');
    //   return;
    // }

    var scanResult = await WiFiScan.instance.startScan();
    if (scanResult == true) {
      print('Scanning started...');
      await Future.delayed(Duration(seconds: 30)); //can be ajustable
      var results = await WiFiScan.instance.getScannedResults();
      setState(() {
        networks = results;
        print('Scanned Networks: ${results.length}');
      });
    } else {
      print('Scan failed to start. Reason: $scanResult');
    }
  }

  Future<void> _startRecording() async {
    try {
      userRepos.setIsLoadingData(true.obs);

      Directory tempDir = await getTemporaryDirectory();
      _filePath = '${tempDir.path}/audio_record.m4a';
      await _recorder!.startRecorder(toFile: _filePath, codec: Codec.aacMP4);
      setState(() {
        _isRecording = true;
      });

      Future.delayed(const Duration(seconds: 30), () async {
        if (_isRecording) {
          await _stopRecording();
        }
      });
    } catch (e) {
      userRepos.setIsLoadingData(false.obs);
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      userRepos.setIsLoadingData(false.obs);
      await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });

      if (_filePath != null) {
        // Read the file into Uint8List
        Uint8List audioBytes = await File(_filePath!).readAsBytes();

        // Now you can use `audioBytes` to store or send the audio data as needed.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio recorded and stored as Uint8List!')),
        );
        setState(() {
          _filePathBytes = audioBytes;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error retrieving file path.')),
        );
      }
    } catch (e) {
      userRepos.setIsLoadingData(false.obs);
      print('Error stopping recording: $e');
    }
  }

  void logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure to LogOut?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.navy,
                  letterSpacing: 1,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences getPref =
                    await SharedPreferences.getInstance();
                getPref.setString("jwtToken", "");
                signController.logoutUser();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.navy,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  logout();
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
          title: Text(
            "Hi! ${userRepos.userModelU.value.name}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.navy),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header Section
            UserAccountsDrawerHeader(
              accountName: Text('${userRepos.userModelU.value.name}'),
              accountEmail: Text('${userRepos.userModelU.value.emailAddress}'),
              currentAccountPicture: CircleAvatar(
                radius: 50, // Customize the radius
                backgroundImage: userRepos.userModelU.value.imageUrl != null &&
                        userRepos.userModelU.value.imageUrl!.isNotEmpty
                    ? NetworkImage(userRepos.userModelU.value.imageUrl!)
                    : AssetImage('assets/Logo.svg'), // Fallback image
                backgroundColor: Colors.transparent,
              ),
              decoration: BoxDecoration(
                color: AppColors.navy,
              ),
            ),
            // Profile Details Card
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('${userRepos.userModelU.value.name}'),
                    subtitle:
                        Text('${userRepos.userModelU.value.emailAddress}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Password'),
                    subtitle: Text('••••••••'),
                  ),
                ],
              ),
            ),
            // Logout Button
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: TextEditingController(
                text: userRepos.userModelU.value.name ?? 'Name',
              ),
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: TextEditingController(
                text: userRepos.userModelU.value.rollNumber ?? 'Roll Number',
              ),
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Roll Number',
                hintText: 'Roll Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => TextFormField(
                      cursorColor: AppColors.navy,
                      controller: userRepos.classNumberController.value,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.navy, // Color when focused
                            width: 2.0, // Width of the outline when focused
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Classroom Number (*optional)',
                        hintText: 'Classroom Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.05,
                ),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.navy,
                        width: 2.0,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCourse,
                        icon: Icon(Icons.arrow_drop_down,
                            color: Colors.blueAccent),
                        iconSize: 28,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCourse = newValue!;
                          });
                        },
                        dropdownColor: Colors.white,
                        items: courseCodes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _selectImage,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 4],
                strokeCap: StrokeCap.round,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imageBytes == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Click a Photo',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _imageBytes!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 35),
            Center(
              child: SizedBox(
                  width: screenWidth * 0.6,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Check for permissions
                      var micPermission = await Permission.microphone.request();
                      var locationPermission =
                          await Permission.locationWhenInUse.request();

                      // If any permission is denied, show an error and return
                      if (micPermission.isDenied ||
                          locationPermission.isDenied) {
                        Get.snackbar("Permissions Denied",
                            "Please provide microphone and location permissions to proceed.");
                        return;
                      }

                      // If permissions are granted, continue with operations
                      if (micPermission.isGranted &&
                          locationPermission.isGranted) {
                        if (_filePathBytes == null) {
                          _isButtonDisabled ? null : _startTimer;
                          await scanNetworks();
                          await _startRecording();
                        }
                        if (dicveInfo == null) {
                          Get.snackbar("Device Info Error",
                              "Unable to retrieve device information.");
                          await getDeviceInfo();
                        }

                        if (_imageBytes == null) {
                          Get.snackbar(
                              "No Photo Found", "Please click a photo.");
                          await _selectImage();
                        }

                        if (_currentPosition == null) {
                          await _determinePosition();
                          Get.snackbar("Location Error",
                              "Location permission is required.");
                        }

                        if (networks.isEmpty) {
                          await scanNetworks();
                          Get.snackbar("WiFi Error",
                              "No networks found or permission denied.");
                        }

                        if (_filePathBytes != null &&
                            _imageBytes != null &&
                            _currentPosition != null &&
                            networks.isNotEmpty &&
                            dicveInfo != null) {
                          // Construct and send the data
                          UserModelSendData userSendData = UserModelSendData(
                            audioUrl: _filePathBytes,
                            createdAt: DateTime.now(),
                            deviceInfo: dicveInfo,
                            imageUrl: _imageBytes,
                            location: Location(
                              latitude: _currentPosition!.latitude,
                              longitude: _currentPosition!.longitude,
                            ),
                            name: userRepos.userModelU.value.name ?? "",
                            rollNumber:
                                userRepos.userModelU.value.rollNumber ?? "",
                            wifiNetworks: networks
                                .map((e) => WifiNetwork(
                                      ssid: e.ssid,
                                      strength: e.level,
                                    ))
                                .toList(),
                          );

                          print(userSendData.toJson().toString());
                          userRepos.sendUserDataBytes(userSendData);
                        } else {
                          print("Some required data is missing.");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Obx(() => userRepos.isLoadingData.value == false
                        ? Text(
                            "Mark Attendance",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          )
                        : CircularProgressIndicator()),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
