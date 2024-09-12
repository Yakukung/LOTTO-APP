import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/internal_config.dart';

// Function to fetch lotto list data
Future<List<LottoListGetResponse>> fetchLottoListData(int uid) async {
  final response = await http.get(Uri.parse('$API_ENDPOINT/lotto_list/$uid'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => LottoListGetResponse.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load lotto list data');
  }
}

// Function to parse JSON to a list of LottoListGetResponse
List<LottoListGetResponse> lottoListGetResponseFromJson(String str) =>
    List<LottoListGetResponse>.from(
        json.decode(str).map((x) => LottoListGetResponse.fromJson(x)));

// Function to convert a list of LottoListGetResponse to JSON
String lottoListGetResponseToJson(List<LottoListGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Class for LottoListGetResponse
class LottoListGetResponse {
  int? wlid;
  int? uid;
  int? pid;
  int? totalPrice;
  String? date;

  LottoListGetResponse({
    this.wlid,
    this.uid,
    this.pid,
    this.totalPrice,
    this.date,
  });

  // Factory method to create an instance from JSON
  factory LottoListGetResponse.fromJson(Map<String, dynamic> json) =>
      LottoListGetResponse(
        wlid: json["wlid"] as int?,
        uid: json["uid"] as int?,
        pid: json["pid"] as int?,
        totalPrice: json["total_price"] as int?,
        date: json["date"] as String?,
      );

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => {
        "wlid": wlid,
        "uid": uid,
        "pid": pid,
        "total_price": totalPrice,
        "date": date,
      };
}
