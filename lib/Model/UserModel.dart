class UserModel {
  String? name;
  String? emailAddress;
  String? rollNumber;
  String? password;
  String? imageUrl;

  UserModel({
    this.name,
    this.emailAddress,
    this.rollNumber,
    this.password,
    this.imageUrl,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    emailAddress = json['emailAddress'];
    rollNumber = json['rollNumber'];
    password = json['password'];
    imageUrl = json['imageUrl'];
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['emailAddress'] = this.emailAddress;
    data['rollNumber'] = this.rollNumber;
    data['password'] = this.password;
    data['imageUrl'] = this.imageUrl;

    return data;
  }
}
