class UsersDetailGetResponse {
  int uid;
  String fullname;
  String username;
  String email;
  String phone;
  String? password; // Nullable
  int type;
  int wallet;
  String? image; // Nullable

  UsersDetailGetResponse({
    required this.uid,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    this.password, // Nullable
    required this.type,
    required this.wallet,
    this.image, // Nullable
  });

  factory UsersDetailGetResponse.fromJson(Map<String, dynamic> json) =>
      UsersDetailGetResponse(
        uid: json["uid"],
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"], // Nullable
        type: json["type"],
        wallet: json["wallet"],
        image: json["image"], // Nullable
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullname": fullname,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password, // Nullable
        "type": type,
        "wallet": wallet,
        "image": image, // Nullable
      };
}
