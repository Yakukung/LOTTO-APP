import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/BasketGetResponse.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottom.dart';
import 'package:lotto_app/sidebar/customerSidebar.dart';

class BasketPage extends StatefulWidget {
  final int uid;
  const BasketPage({super.key, required this.uid});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<UsersLoginPostResponse> loadDataUser;
  late Future<List<BasketGetResponse>> loadBasketLotto;
  bool selectAll = false;
  List<BasketGetResponse> basketItems = [];
  List<bool> itemSelectionStatus = [];
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    loadDataUser = fetchUserData(widget.uid);
    loadBasketLotto = loadBasketData();
    loadBasketLotto.then((items) {
      setState(() {
        basketItems = items;
        itemSelectionStatus = List.generate(items.length, (_) => false);
        updateTotalPrice();
      });
    }).catchError((error) => print("Error loading basket data: $error"));
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = basketItems
          .asMap()
          .entries
          .where((entry) => itemSelectionStatus[entry.key])
          .fold(0,
              (sum, entry) => sum + entry.value.price * entry.value.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double customPadding = isPortrait ? 20.0 : 60.0;

    double EndPadding = isPortrait ? 160 : 10;

    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: Navbar(loadDataUser: loadDataUser, scaffoldKey: _scaffoldKey),
        drawer: FutureBuilder<UsersLoginPostResponse>(
          future: loadDataUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Drawer(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasError) {
              return Drawer(
                  child: Center(child: Text('Error: ${snapshot.error}')));
            }
            if (snapshot.hasData) {
              final user = snapshot.data!;
              return CustomerSidebar(
                imageUrl: user.image ?? '',
                fullname: user.fullname,
                uid: user.uid,
                currentPage: 'basket',
              );
            }
            return const Drawer(
                child: Center(child: Text('No data available')));
          },
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: customPadding,
                          left: customPadding,
                          right: customPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ตะกร้าสินค้า',
                              style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28)),
                          const Text('เลือกซื้อล็อตเตอรี่ที่คุณเพิ่มมาได้เลย!',
                              style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF6C6C6C))),
                          const SizedBox(height: 10),
                          Container(
                              height: 3,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: customPadding, right: customPadding),
                      child: Column(
                        children: [
                          FutureBuilder<List<BasketGetResponse>>(
                              future: loadBasketLotto,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  print(
                                      "Error loading basket data: ${snapshot.error}");
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.shopping_basket,
                                            size: 100, color: Colors.grey[400]),
                                        const SizedBox(height: 20),
                                        Text(
                                          'ยังไม่มีสินค้าในตะกร้า',
                                          style: TextStyle(
                                            fontFamily: 'SukhumvitSet',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: selectAll,
                                          onChanged: (value) {
                                            setState(() {
                                              selectAll = value!;
                                              itemSelectionStatus =
                                                  List.generate(
                                                      basketItems.length,
                                                      (_) => selectAll);
                                              updateTotalPrice();
                                            });
                                          },
                                          fillColor:
                                              WidgetStateProperty.resolveWith(
                                                  (states) => states.contains(
                                                          WidgetState.selected)
                                                      ? const Color(0xFFF92A47)
                                                      : Colors.transparent),
                                        ),
                                        const Text(
                                          'เลือกทั้งหมด',
                                          style: TextStyle(
                                            fontFamily: 'SukhumvitSet',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...basketItems.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          width: 370,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            color: const Color(0xFFF5F5F7),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: const Offset(1, 1),
                                              )
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value:
                                                    itemSelectionStatus[index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    itemSelectionStatus[index] =
                                                        value!;
                                                    selectAll =
                                                        itemSelectionStatus
                                                            .every((status) =>
                                                                status);
                                                    updateTotalPrice();
                                                  });
                                                },
                                                fillColor: WidgetStateProperty
                                                    .resolveWith((states) =>
                                                        states.contains(
                                                                WidgetState
                                                                    .selected)
                                                            ? const Color(
                                                                0xFFF92A47)
                                                            : Colors
                                                                .transparent),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            'หมายเลข : ${item.number}',
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'SukhumvitSet',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20)),
                                                        IconButton(
                                                          onPressed: () async {
                                                            await deleteLoto(
                                                                item.lid);
                                                            loadBasketLotto =
                                                                loadBasketData();
                                                            loadBasketLotto
                                                                .then((items) {
                                                              setState(() {
                                                                basketItems =
                                                                    items;
                                                                itemSelectionStatus =
                                                                    List.generate(
                                                                        items
                                                                            .length,
                                                                        (_) =>
                                                                            false);
                                                                updateTotalPrice();
                                                              });
                                                            });
                                                          },
                                                          icon: const Icon(
                                                              Icons
                                                                  .delete_forever_rounded,
                                                              size: 30,
                                                              color: Color(
                                                                  0xFFF92A47)),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 65,
                                                          height: 25,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.white),
                                                          child: Center(
                                                              child: Text(
                                                                  item.type,
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'SukhumvitSet',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12))),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                            'คงเหลือ  ${item.lottoQuantity}${item.type == 'หวยชุด' ? '  ชุด' : item.type == 'หวยเดี่ยว' ? '  ใบ' : ''}',
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'SukhumvitSet',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xFF2D2D2D))),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .wallet_rounded,
                                                                size: 30,
                                                                color: Color(
                                                                    0xFFF92A47)),
                                                            Text(
                                                                '${item.price * item.quantity}',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'SukhumvitSet',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18,
                                                                    color: Color(
                                                                        0xFFF92A47))),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text('จำนวน',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'SukhumvitSet',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16)),
                                                            const SizedBox(
                                                                width: 20),
                                                            Text(
                                                                '${item.quantity}',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'SukhumvitSet',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                    color: Color(
                                                                        0xFFF92A47))),
                                                            const SizedBox(
                                                                width: 20),
                                                            Container(
                                                              width: 80,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                          .grey[
                                                                      200],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (item.quantity >
                                                                          1) {
                                                                        setState(
                                                                            () {
                                                                          item.quantity--;
                                                                          updateTotalPrice();
                                                                        });
                                                                      }
                                                                    },
                                                                    child: const Padding(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                8),
                                                                        child: Icon(
                                                                            Icons
                                                                                .remove,
                                                                            size:
                                                                                22)),
                                                                  ),
                                                                  Container(
                                                                      width: 1,
                                                                      height:
                                                                          24,
                                                                      color: Colors
                                                                              .grey[
                                                                          400]),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (item.quantity <
                                                                          item.lottoQuantity) {
                                                                        setState(
                                                                            () {
                                                                          item.quantity++;
                                                                          updateTotalPrice();
                                                                        });
                                                                      }
                                                                    },
                                                                    child: const Padding(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                8),
                                                                        child: Icon(
                                                                            Icons
                                                                                .add,
                                                                            size:
                                                                                22)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                    SizedBox(height: EndPadding),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  width: 220,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'รวมทั้งหมด',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wallet_rounded,
                              size: 40,
                              color: Color(0xFFF92A47),
                            ),
                            Text(
                              '$totalPrice',
                              style: const TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Color(0xFFF92A47),
                              ),
                            ),
                            // SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: FilledButton(
                            onPressed: _Payment,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF92A47),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'ชำระเงิน',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavBottom(
          uid: widget.uid,
          selectedIndex: 2,
        ),
      ),
    );
  }

  Future<UsersLoginPostResponse> fetchUserData(int uid) async {
    final response = await http.get(
      Uri.parse('$API_ENDPOINT/customers/$uid'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return UsersLoginPostResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<BasketGetResponse>> loadBasketData() async {
    try {
      final response =
          await http.get(Uri.parse('$API_ENDPOINT/basket/${widget.uid}'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((jsonItem) => BasketGetResponse.fromJson(jsonItem))
            .toList();
      } else {
        print('Failed to load basket data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print("Error in loadBasketData: $e");
      return [];
    }
  }

  Future<void> deleteLoto(int lid) async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: 280,
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
                  const SizedBox(height: 30),
                  const Text(
                    'ยืนยันลบออกจากตะกร้า',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'คุณต้องการลบหมายเลขนี้ออกจากตะกร้าใช่ไหม?',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'ยกเลิก',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          var res = await http.delete(
                            Uri.parse('$url/basket/$lid'),
                            headers: {'Content-Type': 'application/json'},
                          );
                          if (res.statusCode == 200) {
                            loadBasketLotto = loadBasketData();
                            loadBasketLotto.then((items) {
                              setState(() {
                                basketItems = items;
                                itemSelectionStatus =
                                    List.generate(items.length, (_) => false);
                                updateTotalPrice();
                              });
                            });
                            Get.snackbar(
                              '',
                              '',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.blue,
                              margin: EdgeInsets.all(30),
                              borderRadius: 22,
                              titleText: Text(
                                'ลบสินค้าสำเร็จ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                              messageText: Text(
                                'ลบสินค้าออกจากตะกร้าของคุณเรียบร้อย',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                            );
                          } else {
                            // Handle the case where deletion failed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'ลบออกจากตะกร้าไม่ได้: ${res.reasonPhrase}')),
                            );
                          }
                        },
                        child: const Text(
                          'ลบออกจากตะกร้า',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _Payment() {}
}
