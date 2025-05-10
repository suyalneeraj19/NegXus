class UserModel {
  String? id;
  String? name;
  String? email;
  String? profileImage;
  String? phoneNumber;

  UserModel({this.id, this.name, this.email, this.profileImage, this.phoneNumber});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profileImage'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profileImage'] = this.profileImage;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
