class UserModelDto {
  String? name;
  String? emailAddress;
  String? rollNumber;
  String? imageUrl;

  UserModelDto({this.name, this.emailAddress, this.rollNumber, this.imageUrl});

  UserModelDto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    emailAddress = json['emailAddress'];
    rollNumber = json['rollNumber'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    data['emailAddress'] = this.emailAddress;
    data['rollNumber'] = this.rollNumber;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
