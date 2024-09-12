// To parse this JSON data, do
//
//     final detailUsersPutRequest = detailUsersPutRequestFromJson(jsonString);

import 'dart:convert';

DetailUsersPutRequest detailUsersPutRequestFromJson(String str) =>
    DetailUsersPutRequest.fromJson(json.decode(str));

String detailUsersPutRequestToJson(DetailUsersPutRequest data) =>
    json.encode(data.toJson());

class DetailUsersPutRequest {
  String fullname;
  String username;
  String email;
  String phone;
  String password;
  dynamic image;

  DetailUsersPutRequest({
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.image,
  });

  factory DetailUsersPutRequest.fromJson(Map<String, dynamic> json) =>
      DetailUsersPutRequest(
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password,
        "image": image,
      };
}
