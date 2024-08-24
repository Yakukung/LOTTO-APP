// To parse this JSON data, do
//
//     final detailUsersGetRespons = detailUsersGetResponsFromJson(jsonString);

import 'dart:convert';

List<DetailUsersGetRespons> detailUsersGetResponsFromJson(String str) =>
    List<DetailUsersGetRespons>.from(
        json.decode(str).map((x) => DetailUsersGetRespons.fromJson(x)));

String detailUsersGetResponsToJson(List<DetailUsersGetRespons> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailUsersGetRespons {
  int uid;
  String fullname;
  String username;
  String email;
  String phone;
  String password;
  int type;
  int wallet;
  String? image;

  DetailUsersGetRespons({
    required this.uid,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.type,
    required this.wallet,
    required this.image,
  });

  factory DetailUsersGetRespons.fromJson(Map<String, dynamic> json) =>
      DetailUsersGetRespons(
        uid: json["uid"],
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        type: json["type"],
        wallet: json["wallet"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullname": fullname,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password,
        "type": type,
        "wallet": wallet,
        "image": image,
      };
}
