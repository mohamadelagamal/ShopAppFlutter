class ShopLoginModel {
  bool? status;
  String? message;
  UserData? data;

  ShopLoginModel({ this.status,  this.message,  this.data});
  // fromJson method to convert json object to model object
  ShopLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
}

class UserData {
  // init variables with null to avoid null safety issues
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? points;
  int? credit;
  String? token;

  UserData({this.id, this.name, this.email, this.phone, this.image, this.points, this.credit, this.token});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    points = json['points'];
    credit = json['credit'];
    token = json['token'];
  }


}

