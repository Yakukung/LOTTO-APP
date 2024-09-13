import 'dart:developer';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/model/Response/LottoPrizeGetResponse.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottomAdmin.dart';
import 'package:lotto_app/sidebar/adminSidebar.dart';
import 'package:lotto_app/config/internal_config.dart';

class AdminhomePage extends StatefulWidget {
  final int uid;
  const AdminhomePage({super.key, required this.uid});

  @override
  State<AdminhomePage> createState() => _AdminhomePageState();
}

class _AdminhomePageState extends State<AdminhomePage> {
  late Future<UsersLoginPostResponse> loadDataUser;
  late Future<List<LottoPrizeGetResponse>> loadDataLottoPrize;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int prizeValue = 0;

  @override
  void initState() {
    super.initState();
    log('Show User uid: ${widget.uid}');
    loadDataUser = fetchUserData();
    loadDataLottoPrize = loadDataLottoPrizeAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: Navbar(
        loadDataUser: loadDataUser,
        scaffoldKey: _scaffoldKey,
      ),
      drawer: FutureBuilder<UsersLoginPostResponse>(
        future: loadDataUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer(child: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return Drawer(
                child: Center(child: Text('Error: ${snapshot.error}')));
          }
          final user = snapshot.data!;
          return CustomerSidebar(
            imageUrl: user.image ?? '',
            username: user.username,
            uid: user.uid,
            currentPage: 'adminHome',
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<UsersLoginPostResponse>(
              future: loadDataUser,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                }
                final user = userSnapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ยินดีต้อนรับ กลับมา!',
                            style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF7B7B7C),
                            ),
                          ),
                          Text(
                            user.username,
                            style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<LottoPrizeGetResponse>>(
                      future: loadDataLottoPrize,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final lottoDataList = snapshot.data ?? [];

                        // Separate data by prize type
                        final prize1List = lottoDataList
                            .where((item) => item.prize == 1)
                            .toList();
                        final prize2List = lottoDataList
                            .where((item) => item.prize == 2)
                            .toList();
                        final prize3List = lottoDataList
                            .where((item) => item.prize == 3)
                            .toList();
                        final prize4List = lottoDataList
                            .where((item) => item.prize == 4)
                            .toList();
                        final prize5List = lottoDataList
                            .where((item) => item.prize == 5)
                            .toList();

                        String getNumberOrDefault(
                            List<LottoPrizeGetResponse> list, int prizeType) {
                          final item = list.firstWhere(
                            (item) => item.prize == prizeType,
                            orElse: () => LottoPrizeGetResponse(
                              lid: 0,
                              prize: prizeType,
                              walletPrize: 0,
                              number: 0,
                              type: '',
                              price: 0,
                              date: '',
                              lottoQuantity: 0,
                            ),
                          );
                          return '${item.number == 0 ? '000000' : item.number}'; // Return '000000' if number is 0
                        }

                        return Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            children: [
                              // Prize 1
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 135,
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 1, 56, 86),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'รางวัลที่ 1',
                                              style: TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 26,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Container(
                                                  width: 190,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      getNumberOrDefault(
                                                          prize1List, 1),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SukhumvitSet',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 35,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 69, 67, 67),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    _RandomPrizeLotto(
                                                        prizeValue = 1);
                                                    print('สุ่มรางวัล');
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Color.fromARGB(255,
                                                                238, 179, 30)),
                                                    foregroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Color.fromARGB(255,
                                                                1, 56, 86)),
                                                  ),
                                                  child: Text(
                                                    'สุ่ม',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 1, 56, 86),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Prize 2
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 135,
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 215, 215, 215),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'รางวัลที่ 2',
                                              style: TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 26,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Container(
                                                  width: 190,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      getNumberOrDefault(
                                                          prize2List, 2),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SukhumvitSet',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 35,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 69, 67, 67),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    _RandomPrizeLotto(
                                                        prizeValue = 2);
                                                    print('สุ่มรางวัล');
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Color.fromARGB(255,
                                                                1, 56, 86)),
                                                    foregroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                  child: Text(
                                                    'สุ่ม',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Prize 3
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 135,
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 1, 56, 86),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'รางวัลที่ 3',
                                              style: TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 26,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Container(
                                                  width: 190,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      getNumberOrDefault(
                                                          prize3List, 3),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SukhumvitSet',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 35,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 69, 67, 67),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    _RandomPrizeLotto(
                                                        prizeValue = 3);
                                                    print('สุ่มรางวัล');
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Color.fromARGB(255,
                                                                238, 179, 30)),
                                                    foregroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Color.fromARGB(255,
                                                                1, 56, 86)),
                                                  ),
                                                  child: Text(
                                                    'สุ่ม',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 1, 56, 86),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Prize 4
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 135,
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 215, 215, 215),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'รางวัลที่ 4',
                                              style: TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 26,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Container(
                                                  width: 190,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      getNumberOrDefault(
                                                          prize4List, 4),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SukhumvitSet',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 35,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 69, 67, 67),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    _RandomPrizeLotto(
                                                        prizeValue = 4);
                                                    print('สุ่มรางวัล');
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Color.fromARGB(255,
                                                                1, 56, 86)),
                                                    foregroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                  child: Text(
                                                    'สุ่ม',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Prize 5
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 135,
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 1, 56, 86),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'รางวัลที่ 5',
                                              style: TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 26,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Container(
                                                  width: 190,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      getNumberOrDefault(
                                                          prize5List, 5),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SukhumvitSet',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 35,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 69, 67, 67),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    _RandomPrizeLotto(
                                                        prizeValue = 5);
                                                    print('สุ่มรางวัล');
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Color.fromARGB(255,
                                                                238, 179, 30)),
                                                    foregroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            Color.fromARGB(255,
                                                                1, 56, 86)),
                                                  ),
                                                  child: Text(
                                                    'สุ่ม',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 1, 56, 86),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBottom(
        uid: widget.uid,
        selectedIndex: 0,
      ),
    );
  }

  Future<UsersLoginPostResponse> fetchUserData() async {
    final response =
        await http.get(Uri.parse('$API_ENDPOINT/customers/${widget.uid}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UsersLoginPostResponse.fromJson(data);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<LottoPrizeGetResponse>> loadDataLottoPrizeAsync() async {
    var config = await Configuration.getConfig();
    var res = await http.get(Uri.parse('${config['apiEndpoint']}/admin/prize'));
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      List<LottoPrizeGetResponse> allLottoData =
          data.map((item) => LottoPrizeGetResponse.fromJson(item)).toList();
      return allLottoData;
    } else {
      throw Exception('Failed to load lotto prize data');
    }
  }

  Future<void> _RandomPrizeLotto(int prizeValue) async {
    print('สุ่มรางวัลที่ $prizeValue');

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
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              padding: EdgeInsets.all(20),
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
                  SizedBox(height: 30),
                  Text(
                    'ยืนยันการสุ่มรางวัล',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'กดยืนยันเพื่อทำการสุ่มรางวัล',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final response = await http.post(
                            Uri.parse('$API_ENDPOINT/admin/random/prize'),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({'prize': prizeValue}),
                          );

                          if (response.statusCode == 200) {
                            Get.snackbar(
                              '',
                              '',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.blue,
                              margin: EdgeInsets.all(30),
                              borderRadius: 22,
                              titleText: Text(
                                'สุ่มรางวัลสำเร็จ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                              messageText: Text(
                                'สุ่มรางวัลที่ $prizeValue แล้ว',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                            );
                            final data = json.decode(response.body);
                            print('Response data: $data');
                            setState(() {
                              loadDataLottoPrize = loadDataLottoPrizeAsync();
                            });
                            Navigator.of(context).pop();
                          } else {
                            throw Exception(
                              'Failed to load prize data. Status code: ${response.statusCode}. Response body: ${response.body}',
                            );
                          }
                        },
                        child: Text(
                          'ยืนยันการสุ่ม',
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
}
