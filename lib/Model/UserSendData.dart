import 'dart:typed_data';

class UserModelSendData {
  String? name;
  String? rollNumber;
  Location? location;
  List<WifiNetwork>? wifiNetworks;
  Uint8List? imageUrl;
  Uint8List? audioUrl;
  String? deviceInfo;
  DateTime? createdAt;

  UserModelSendData({
    this.name,
    this.rollNumber,
    this.location,
    this.wifiNetworks,
    this.imageUrl,
    this.audioUrl,
    this.deviceInfo,
    this.createdAt,
  });

  UserModelSendData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rollNumber = json['rollNumber'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    if (json['wifiNetworks'] != null) {
      wifiNetworks = <WifiNetwork>[];
      json['wifiNetworks'].forEach((v) {
        wifiNetworks!.add(WifiNetwork.fromJson(v));
      });
    }
    imageUrl = json['imageUrl'];
    audioUrl = json['audioUrl'];
    deviceInfo = json['deviceInfo'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    data['rollNumber'] = this.rollNumber;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.wifiNetworks != null) {
      data['wifiNetworks'] = this.wifiNetworks!.map((v) => v.toJson()).toList();
    }
    data['imageUrl'] = this.imageUrl;
    data['audioUrl'] = this.audioUrl;
    data['deviceInfo'] = this.deviceInfo;
    data['createdAt'] = this.createdAt?.toIso8601String();

    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class WifiNetwork {
  String? ssid;
  int? strength;

  WifiNetwork({this.ssid, this.strength});

  WifiNetwork.fromJson(Map<String, dynamic> json) {
    ssid = json['ssid'];
    strength = json['strength'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ssid'] = this.ssid;
    data['strength'] = this.strength;

    return data;
  }
}
