// To parse this JSON data, do
//
//     final lottoPrizeIdGetResponse = lottoPrizeIdGetResponseFromJson(jsonString);

import 'dart:convert';

LottoPrizeIdGetResponse lottoPrizeIdGetResponseFromJson(String str) =>
    LottoPrizeIdGetResponse.fromJson(json.decode(str));

String lottoPrizeIdGetResponseToJson(LottoPrizeIdGetResponse data) =>
    json.encode(data.toJson());

class LottoPrizeIdGetResponse {
  int lid;
  int prize;
  int walletPrize;
  int number;
  String type;
  String date;
  int totalQuantity;

  LottoPrizeIdGetResponse({
    required this.lid,
    required this.prize,
    required this.walletPrize,
    required this.number,
    required this.type,
    required this.date,
    required this.totalQuantity,
  });

  factory LottoPrizeIdGetResponse.fromJson(Map<String, dynamic> json) =>
      LottoPrizeIdGetResponse(
        lid: json["lid"],
        prize: json["prize"],
        walletPrize: json["wallet_prize"],
        number: json["number"],
        type: json["type"],
        date: json["date"],
        totalQuantity: json["total_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "lid": lid,
        "prize": prize,
        "wallet_prize": walletPrize,
        "number": number,
        "type": type,
        "date": date,
        "total_quantity": totalQuantity,
      };
}
