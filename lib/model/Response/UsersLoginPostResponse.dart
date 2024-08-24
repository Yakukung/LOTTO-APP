import 'dart:convert';

List<UsersLoginPostResponse> usersLoginPostResponseFromJson(String str) =>
    List<UsersLoginPostResponse>.from(
        json.decode(str).map((x) => UsersLoginPostResponse.fromJson(x)));

String usersLoginPostResponseToJson(List<UsersLoginPostResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersLoginPostResponse {
  int uid;
  String fullname;
  String username;
  String email;
  String phone;
  int type;
  int wallet;
  String? image;
  String? password; // Add password field

  UsersLoginPostResponse({
    required this.uid,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.type,
    required this.wallet,
    this.image,
    this.password, // Initialize password
  });

  factory UsersLoginPostResponse.fromJson(Map<String, dynamic> json) =>
      UsersLoginPostResponse(
        uid: json["uid"],
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        type: json["type"],
        wallet: json["wallet"],
        image: json["image"],
        password: json["password"], // Parse password
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullname": fullname,
        "username": username,
        "email": email,
        "phone": phone,
        "type": type,
        "wallet": wallet,
        "image": image,
        "password": password, // Include password
      };
}
