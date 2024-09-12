// To parse this JSON data, do
//
//     final myLottoGetResponse = myLottoGetResponseFromJson(jsonString);

import 'dart:convert';

List<MyLottoGetResponse> myLottoGetResponseFromJson(String str) =>
    List<MyLottoGetResponse>.from(
        json.decode(str).map((x) => MyLottoGetResponse.fromJson(x)));

String myLottoGetResponseToJson(List<MyLottoGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyLottoGetResponse {
  int uid;
  int lid;
  int number;
  String type;
  String date;
  int totalQuantity;
  int totalPrice;

  MyLottoGetResponse({
    required this.uid,
    required this.lid,
    required this.number,
    required this.type,
    required this.date,
    required this.totalQuantity,
    required this.totalPrice,
  });

  factory MyLottoGetResponse.fromJson(Map<String, dynamic> json) =>
      MyLottoGetResponse(
        uid: json["uid"],
        lid: json["lid"],
        number: json["number"],
        type: json["type"],
        date: json["date"],
        totalQuantity: json["total_quantity"],
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "lid": lid,
        "number": number,
        "type": type,
        "date": date,
        "total_quantity": totalQuantity,
        "total_price": totalPrice,
      };
}
