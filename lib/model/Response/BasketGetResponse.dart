// To parse this JSON data, do
//
//     final basketGetResponse = basketGetResponseFromJson(jsonString);

import 'dart:convert';

List<BasketGetResponse> basketGetResponseFromJson(String str) =>
    List<BasketGetResponse>.from(
        json.decode(str).map((x) => BasketGetResponse.fromJson(x)));

String basketGetResponseToJson(List<BasketGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BasketGetResponse {
  int uid;
  int lid;
  int number;
  String type;
  int price;
  String date;
  int lottoQuantity;
  int quantity;

  BasketGetResponse({
    required this.uid,
    required this.lid,
    required this.number,
    required this.type,
    required this.price,
    required this.date,
    required this.lottoQuantity,
    required this.quantity,
  });

  factory BasketGetResponse.fromJson(Map<String, dynamic> json) =>
      BasketGetResponse(
        uid: json["uid"],
        lid: json["lid"],
        number: json["number"],
        type: json["type"],
        price: json["price"],
        date: json["date"],
        lottoQuantity: json["lotto_quantity"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "lid": lid,
        "number": number,
        "type": type,
        "price": price,
        "date": date,
        "lotto_quantity": lottoQuantity,
        "quantity": quantity,
      };
}
