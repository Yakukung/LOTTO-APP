import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/LottoListGetResponse.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottom.dart';
import 'package:lotto_app/sidebar/customerSidebar.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  final int uid;
  const WalletPage({super.key, required this.uid});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<UsersLoginPostResponse> userFuture;
  late Future<List<LottoListGetResponse>> lottoFuture;

  @override
  void initState() {
    super.initState();
    userFuture = fetchUserData(widget.uid);
    lottoFuture = fetchLottoListData(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double padding = isPortrait ? 20.0 : 60.0;

    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: Navbar(
          loadDataUser: userFuture,
          scaffoldKey: _scaffoldKey,
        ),
        drawer: FutureBuilder<UsersLoginPostResponse>(
          future: userFuture,
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
                currentPage: 'wallet',
              );
            } else {
              return const Drawer(
                  child: Center(child: Text('No data available')));
            }
          },
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<UsersLoginPostResponse>(
            future: userFuture,
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

              final user = snapshot.data!;

              return Column(
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFEAAC8B),
                          Color(0xFFE88C7D),
                          Color(0xFFEE5566),
                          Color(0xFFB56576),
                          Color(0xFF6D597A),
                          Color(0xFF355070),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          Text(user.wallet.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 52,
                                  color: Color(0xFFFFFFFF))),
                          const Text('ยอดวอเล็ตคงเหลือ',
                              style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF))),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: padding, vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildActionButton(
                                Icons.account_balance_wallet_outlined,
                                'เติมเงิน',
                                padding,
                                showTopUpSheet),
                            _buildActionButton(Icons.currency_exchange_outlined,
                                'โอนเงิน', padding, () {
                              // Implement the transfer functionality here
                            }),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                            height: 3, color: Colors.black.withOpacity(0.1)),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            const Row(children: [
                              Text('รายการย้อนหลัง',
                                  style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xFFF92A47)))
                            ]),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F7),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: FutureBuilder<List<LottoListGetResponse>>(
                                  future: lottoFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Center(
                                            child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'ยังไม่มีประวัติรายรับรายจ่าย',
                                            style: TextStyle(
                                              fontFamily: 'SukhumvitSet',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                        )),
                                      );
                                    }

                                    final lottoList = snapshot.data!;

                                    return Column(
                                      children: lottoList.map((lotto) {
                                        bool isTransfer = lotto.pid != null;

                                        return Container(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    isTransfer
                                                        ? 'โอนออก'
                                                        : 'โอนเข้า',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Color(0xFF000000),
                                                    ),
                                                  ),
                                                  Text(
                                                    lotto.date ??
                                                        'No Date Provided',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Color(0xFF6C6C6C),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '${isTransfer ? '-' : '+'}${lotto.totalPrice}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isTransfer
                                                          ? Colors.red
                                                          : Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: NavBottom(
          uid: widget.uid,
          selectedIndex: 3,
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, double padding, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.only(left: padding, right: 60),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFFEAAC8B),
                  Color(0xFFE88C7D),
                  Color(0xFFEE5566),
                  Color(0xFFB56576),
                  Color(0xFF6D597A),
                  Color(0xFF355070)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Icon(icon, size: 45, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(label,
                style: const TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Future<UsersLoginPostResponse> fetchUserData(int uid) async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/customers/$uid'));
    if (response.statusCode == 200) {
      return UsersLoginPostResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load user data');
  }

  Future<List<LottoListGetResponse>> fetchLottoListData(int uid) async {
    try {
      final response =
          await http.get(Uri.parse('$API_ENDPOINT/lotto_list/$uid'));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return [];
        }
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          return [];
        }

        return data.map((json) => LottoListGetResponse.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print('No data found for the given UID.');
        return [];
      } else {
        throw Exception(
            'Failed to load lotto list data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load lotto list data');
    }
  }

  void showTopUpSheet() {
    double? selectedAmount;
    final List<double> amounts = [100, 200, 500, 1000, 2000];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 350,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Padding(
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
                SizedBox(height: 15),
                const Text(
                  'เติม Wallet',
                  style: TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Background color for the dropdown container
                    borderRadius:
                        BorderRadius.circular(8), // Optional: Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<double>(
                      value: selectedAmount,
                      hint: const Text(
                        'เลือกจำนวนเงิน',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      items: amounts.map((amount) {
                        return DropdownMenuItem<double>(
                          value: amount,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.wallet_rounded,
                                  size: 24, // Adjusted size to fit better
                                  color: Color(0xFFF92A47),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${amount.toInt()}',
                                  style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFFF92A47),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAmount = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: TextButton(
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
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: TextButton(
                        onPressed: () {
                          if (selectedAmount != null && selectedAmount! > 0) {
                            Navigator.pop(context);
                            processTopUp(selectedAmount!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('กรุณากรอกจำนวนเงินที่ถูกต้อง')),
                            );
                          }
                        },
                        child: const Text(
                          'ยืนยัน',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void processTopUp(double amount) async {
    try {
      final response = await http.put(
        Uri.parse('$API_ENDPOINT/topup_wallet/${widget.uid}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'wallet': amount}),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          '',
          '',
          titleText: Text(
            'เติม Wallet สำเร็จ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'SukhumvitSet',
            ),
          ),
          messageText: Text(
            'ยอดคุณเติมคือ $amount',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'SukhumvitSet',
            ),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          margin: EdgeInsets.all(30),
          borderRadius: 22,
        );

        setState(() {
          userFuture = fetchUserData(widget.uid);
          lottoFuture = fetchLottoListData(widget.uid);
        });
      } else {
        throw Exception('Failed to top up: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }
}
