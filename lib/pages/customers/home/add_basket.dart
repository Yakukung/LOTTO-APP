import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/model/Response/LottoGetResponse.dart';
import 'package:get/get.dart';

class AddBasketPage extends StatefulWidget {
  final int uid;
  final int lid;

  const AddBasketPage({super.key, required this.uid, required this.lid});

  @override
  State<AddBasketPage> createState() => _AddBasketPageState();
}

class _AddBasketPageState extends State<AddBasketPage> {
  late Future<LottoGetResponse> loadDataLotto;
  int quantity = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadDataLotto = loadLottoData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LottoGetResponse>(
      future: loadDataLotto,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final lotto = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 410,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'หมายเลข',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF6C6C6C),
                    ),
                  ),
                  Text(
                    '${lotto.number}',
                    style: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Color(0xFF000000),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          lotto.type,
                          style: const TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF6C6C6C)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'คงเหลือ  ${lotto.lottoQuantity}${lotto.type == 'หวยชุด' ? '  ชุด' : lotto.type == 'หวยเดี่ยว' ? '  ใบ' : ''}',
                        style: const TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'จำนวน',
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF000000)),
                      ),
                      SizedBox(width: 20),
                      Text(
                        '$quantity',
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFFF92A47)),
                      ),
                      SizedBox(width: 20),
                      Text(
                        lotto.type == 'หวยชุด'
                            ? '  ชุด'
                            : lotto.type == 'หวยเดี่ยว'
                                ? '  ใบ'
                                : '',
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF000000)),
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          Container(
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onLongPressStart: (_) =>
                                      _startDecreasing(), // เพิ่มการเรียกใช้ _startDecreasing
                                  onLongPressEnd: (_) => _stopTimer(),
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(Icons.remove,
                                        size: 22, color: Colors.black),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 24,
                                  color: Colors.grey[400],
                                ),
                                GestureDetector(
                                  onLongPressStart: (_) => _startIncreasing(),
                                  onLongPressEnd: (_) => _stopTimer(),
                                  onTap: () {
                                    setState(() {
                                      if (quantity < lotto.lottoQuantity) {
                                        quantity++;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(Icons.add,
                                        size: 22, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'รวมทั้งหมด',
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF000000)),
                      ),
                      SizedBox(width: 5),
                      Row(children: [
                        Icon(
                          Icons.wallet_rounded,
                          size: 35,
                          color: Color(0xFFF92A47),
                        ),
                        Text(
                          '${lotto.price * quantity}',
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color(0xFFF92A47)),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 15),
                  FilledButton(
                    onPressed: addBasket,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFF92A47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'เพิ่มลงตะกร้า',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<LottoGetResponse> loadLottoData() async {
    final response =
        await http.get(Uri.parse('$API_ENDPOINT/lotto/${widget.lid}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return LottoGetResponse.fromJson(data);
    } else {
      throw Exception('โหลดข้อมูล LOTTO ไม่ได้');
    }
  }

  Future<void> addBasket() async {
    try {
      final LottoGetResponse lotto = await loadLottoData();
      final basketCheckResponse = await http.get(
        Uri.parse(
            '$API_ENDPOINT/check-basket?uid=${widget.uid}&lid=${widget.lid}'),
      );

      if (basketCheckResponse.statusCode == 200) {
        final basketCheckData = json.decode(basketCheckResponse.body);
        final availableQuantity = lotto.lottoQuantity;

        if (basketCheckData['exists']) {
          final currentQuantity = basketCheckData['quantity'] ?? 0;
          final newQuantity = currentQuantity + quantity;

          if (newQuantity > availableQuantity) {
            Get.snackbar(
              '',
              '',
              titleText: Text(
                'เพิ่มลงตะกร้าไม่ได้',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'SukhumvitSet',
                ),
              ),
              messageText: Text(
                'คุณเพิ่มสินค้านี้ในตะกร้าของคุณหมดแล้ว',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SukhumvitSet',
                ),
              ),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Color(0xFFF92A47),
              margin: EdgeInsets.all(30),
              borderRadius: 22,
            );
            return;
          }

          final updateBasketData = {
            'lid': widget.lid,
            'uid': widget.uid,
            'quantity': newQuantity,
          };

          final updateResponse = await http.put(
            Uri.parse('$API_ENDPOINT/update-basket'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(updateBasketData),
          );

          if (updateResponse.statusCode == 200) {
            print('Updated basket successfully');
            Get.snackbar(
              '',
              '',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.blue,
              margin: EdgeInsets.all(30),
              borderRadius: 20,
              titleText: Text(
                'เพิ่มสินค้าลงตะกร้าเรียบร้อยแล้ว',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'SukhumvitSet',
                ),
              ),
              messageText: Text(
                'หมายเลข: ${lotto.number}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SukhumvitSet',
                ),
              ),
            );
          } else {
            print('Failed to update basket: ${updateResponse.body}');
          }
        } else {
          if (quantity > availableQuantity) {
            Get.snackbar(
              '',
              '',
              titleText: Text(
                'เพิ่มลงตะกร้าไม่ได้',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'SukhumvitSet',
                ),
              ),
              messageText: Text(
                'คุณเพิ่มสินค้านี้ในตะกร้าของคุณหมดแล้ว',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SukhumvitSet',
                ),
              ),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Color(0xFFF92A47),
              margin: EdgeInsets.all(30),
              borderRadius: 22,
            );
            return;
          }

          final basketData = {
            'lid': widget.lid,
            'uid': widget.uid,
            'quantity': quantity,
          };

          final response = await http.post(
            Uri.parse('$API_ENDPOINT/add-basket'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(basketData),
          );

          if (response.statusCode == 200) {
            print('Added to basket successfully');
            Get.snackbar(
              '',
              '',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.blue,
              margin: EdgeInsets.all(30),
              borderRadius: 22,
              titleText: Text(
                'เพิ่มสินค้าลงตะกร้าเรียบร้อยแล้ว',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'SukhumvitSet',
                ),
              ),
              messageText: Text(
                'หมายเลข: ${lotto.number}',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SukhumvitSet',
                ),
              ),
            );
          } else {
            print('Failed to add to basket: ${response.body}');
          }
        }
      } else {
        throw Exception('Failed to check basket');
      }
    } catch (e) {
      print('Error adding to basket: $e');
      Get.snackbar(
        'ข้อผิดพลาด',
        'เกิดข้อผิดพลาดในการเพิ่มลงตะกร้า',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _startIncreasing() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (quantity < 100) {
        setState(() {
          quantity++;
        });
      }
    });
  }

  void _startDecreasing() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (quantity > 1) {
        // แก้ไขขีดจำกัดต่ำสุดของปริมาณ
        setState(() {
          quantity--;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }
}
