import 'dart:convert';
import 'package:intl/intl.dart';

LottoPrizeGetResponse lottoGetResponseFromJson(String str) =>
    LottoPrizeGetResponse.fromJson(json.decode(str));

String lottoGetResponseToJson(LottoPrizeGetResponse data) =>
    json.encode(data.toJson());

class LottoPrizeGetResponse {
  int lid;
  int prize;
  int walletPrize;
  int number;
  String type;
  int price;
  String date;
  int lottoQuantity;
  late String formattedDate;

  LottoPrizeGetResponse({
    required this.lid,
    required this.prize,
    required this.walletPrize,
    required this.number,
    required this.type,
    required this.price,
    required this.date,
    required this.lottoQuantity,
  }) {
    formattedDate = _formatDate(date);
  }

  factory LottoPrizeGetResponse.fromJson(Map<String, dynamic> json) {
    return LottoPrizeGetResponse(
      lid: json["lid"] ?? 0,
      prize: json["prize"] ?? 0,
      walletPrize: json["wallet_prize"] ?? 0,
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
        "wallet_prize": walletPrize,
        "number": number,
        "type": type,
        "price": price,
        "date": date,
        "lotto_quantity": lottoQuantity,
      };

  // ฟังก์ชันช่วยในการจัดรูปแบบวันที่
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('วันที่ d MMMM yyyy', 'th').format(date);
    } catch (e) {
      // ถ้าวันที่ไม่ถูกต้องหรือไม่สามารถแปลงได้
      return 'วันที่ไม่ถูกต้อง'; // ข้อความที่ต้องการแสดงในกรณีวันที่ไม่ถูกต้อง
    }
  }
}
