import 'dart:convert';
import 'package:intl/intl.dart';

LottoGetResponse lottoGetResponseFromJson(String str) =>
    LottoGetResponse.fromJson(json.decode(str));

String lottoGetResponseToJson(LottoGetResponse data) =>
    json.encode(data.toJson());

class LottoGetResponse {
  int lid;
  int prize;
  int wallet_prize;
  int number;
  String type;
  int price;
  String date;
  int lottoQuantity;
  late String formattedDate;

  LottoGetResponse({
    required this.lid,
    required this.prize,
    required this.wallet_prize,
    required this.number,
    required this.type,
    required this.price,
    required this.date,
    required this.lottoQuantity,
  }) {
    formattedDate =
        DateFormat('วันที่ d MMMM yyyy', 'th').format(DateTime.parse(date));
  }

  factory LottoGetResponse.fromJson(Map<String, dynamic> json) {
    return LottoGetResponse(
      lid: json["lid"] ?? 0,
      prize: json["prize"] ?? 0,
      wallet_prize: json["wallet_prize"] ?? 0,
      number: json["number"] ?? 0,
      type: json["type"] ?? '',
      price: json["price"] ?? 0,
      date: json["date"] ?? DateTime.now().toString(),
      lottoQuantity: json["lotto_quantity"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "lid": lid,
        "prize": prize,
        "wallet_prize": wallet_prize,
        "number": number,
        "type": type,
        "price": price,
        "date": date,
        "lotto_quantity": lottoQuantity,
      };
}
