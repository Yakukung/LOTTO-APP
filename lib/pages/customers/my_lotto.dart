import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/LottoPrizeIdGetResponse.dart';
import 'package:lotto_app/model/Response/MyLottoGetResponse.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/sidebar/customerSidebar.dart';
import 'package:http/http.dart' as http;

class MyLottoPage extends StatefulWidget {
  final int uid;
  const MyLottoPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<MyLottoPage> createState() => _MyLottoPageState();
}

class _MyLottoPageState extends State<MyLottoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<UsersLoginPostResponse> loadDataUser;
  late Future<List<MyLottoGetResponse>> loadDataMyLotto;
  List<MyLottoGetResponse> _allLottoList = [];
  List<MyLottoGetResponse> _filteredLottoList = [];
  TextEditingController searchCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDataUser = fetchUserData(widget.uid);
    loadDataMyLotto = fetchMyLOTTOData(widget.uid);
    searchCtl.addListener(_filterLottoList);
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double customPadding = isPortrait ? 20.0 : 60.0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Navbar(
          loadDataUser: loadDataUser,
          scaffoldKey: _scaffoldKey,
        ),
      ),
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
              currentPage: 'my_lotto',
            );
          } else {
            return const Drawer(
                child: Center(child: Text('No data available')));
          }
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: customPadding),
            child: TextField(
              controller: searchCtl,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F5F7),
                hintText: 'ค้นหาเลขล็อตเตอรี่',
                hintStyle: const TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(
                fontFamily: 'SukhumvitSet',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MyLottoGetResponse>>(
              future: loadDataMyLotto,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  _allLottoList = snapshot.data!;
                  if (_filteredLottoList.isEmpty) {
                    _filteredLottoList = List.from(_allLottoList);
                  }
                  return ListView.builder(
                    itemCount: _filteredLottoList.length,
                    itemBuilder: (context, index) {
                      final lotto = _filteredLottoList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 360,
                            height: 130,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F7),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'หมายเลข: ${lotto.number}',
                                        style: const TextStyle(
                                          fontFamily: 'SukhumvitSet',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        lotto.date,
                                        style: const TextStyle(
                                          fontFamily: 'SukhumvitSet',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                lotto.type,
                                                style: const TextStyle(
                                                  fontFamily: 'SukhumvitSet',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'จำนวน ${lotto.totalQuantity}${lotto.type == 'หวยชุด' ? '  ชุด' : lotto.type == 'หวยเดี่ยว' ? '  ใบ' : ''}',
                                            style: const TextStyle(
                                              fontFamily: 'SukhumvitSet',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Color(0xFF2D2D2D),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 90,
                                            height: 35,
                                            child: FilledButton(
                                              onPressed: () => _checkPrize(
                                                  lotto.lid, lotto.number),
                                              style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFFF92A47),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                ),
                                                padding: EdgeInsets.zero,
                                              ),
                                              child: const Text(
                                                'ตรวจสอบรางวัล',
                                                style: TextStyle(
                                                  fontFamily: 'SukhumvitSet',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<UsersLoginPostResponse> fetchUserData(int uid) async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/customers/$uid'));
    if (response.statusCode == 200) {
      return UsersLoginPostResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<MyLottoGetResponse>> fetchMyLOTTOData(int uid) async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/my_lotto/$uid'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((data) => MyLottoGetResponse.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load lotto data');
    }
  }

  @override
  void didUpdateWidget(covariant MyLottoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uid != oldWidget.uid) {
      loadDataMyLotto = fetchMyLOTTOData(widget.uid);
    }
  }

  @override
  void dispose() {
    searchCtl.removeListener(_filterLottoList);
    searchCtl.dispose();
    super.dispose();
  }

  void _filterLottoList() {
    setState(() {
      final query = searchCtl.text.toLowerCase();
      if (query.isEmpty) {
        _filteredLottoList = List.from(_allLottoList);
      } else {
        _filteredLottoList = _allLottoList
            .where((lotto) =>
                lotto.number.toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _checkPrize(int lid, int number) async {
    final checkPrizeUrl = '$API_ENDPOINT/lotto-check-prize';

    try {
      final response = await http.post(
        Uri.parse(checkPrizeUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'lid': lid, 'uid': widget.uid}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final LottoPrizeIdGetResponse data =
            lottoPrizeIdGetResponseFromJson(response.body);

        // print('Data: $data');
        final walletPrize = data.walletPrize;
        final prize = data.prize;
        final numberWin = data.number;
        final int totalQuantity = data.totalQuantity;
        final String type = data.type;

        int wallet = 0;
        if (type == "หวยเดี่ยว") {
          wallet = (walletPrize * totalQuantity).toInt();
          print("เข้าลูปหวยเดี่ยว เงินทั้งหมด = $wallet");
        } else if (type == "หวยชุด") {
          wallet = (walletPrize * (totalQuantity * 5)).toInt();
          print("เข้าลูปหวยชุด เงินทั้งหมด = $wallet");
        }

        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Stack(
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
                    height: 460,
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
                          'หมายเลข',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF6C6C6C),
                          ),
                        ),
                        Text(
                          '$numberWin',
                          style: const TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ถูกรางวัลที่ $prize',
                              style: const TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.wallet_rounded,
                                  size: 30,
                                  color: Color(0xFFF92A47),
                                ),
                                Text(
                                  '$walletPrize',
                                  style: const TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xFFF92A47),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      type,
                                      style: const TextStyle(
                                        fontFamily: 'SukhumvitSet',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'จำนวน',
                                  style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF000000)),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  '$totalQuantity',
                                  style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xFFF92A47)),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  type == 'หวยชุด'
                                      ? '  ชุด'
                                      : type == 'หวยเดี่ยว'
                                          ? '  ใบ'
                                          : '',
                                  style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF000000)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 8),
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
                        SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'รวมทั้งหมด',
                              style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF000000)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.wallet_rounded,
                                size: 35,
                                color: Color(0xFFF92A47),
                              ),
                              Text(
                                '${wallet}',
                                style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Color(0xFFF92A47)),
                              ),
                            ]),
                          ],
                        ),
                        SizedBox(height: 20),
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
                                try {
                                  final updateUrl = '$API_ENDPOINT/get-wallet';
                                  final updateResponse = await http.put(
                                    Uri.parse(updateUrl),
                                    headers: {
                                      'Content-Type': 'application/json'
                                    },
                                    body: jsonEncode({
                                      'wallet_prize': wallet,
                                      'uid': widget.uid,
                                    }),
                                  );
                                  if (updateResponse.statusCode == 200) {
                                    print('ยอด wallet เพิ่มขึ้น $wallet');
                                    final response = await http.delete(
                                      Uri.parse(
                                          '$API_ENDPOINT/get-wallet/$lid'),
                                    );
                                    if (response.statusCode == 200) {
                                      print('ลบ LOTTO ใน My LOTTO เรียบร้อย');
                                      Navigator.of(context).pop();
                                      Get.snackbar(
                                        '',
                                        '',
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: Colors.blue,
                                        margin: EdgeInsets.all(30),
                                        borderRadius: 22,
                                        titleText: Text(
                                          'รับรางวัลสำเร็จ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFFFFF),
                                            fontFamily: 'SukhumvitSet',
                                          ),
                                        ),
                                        messageText: Text(
                                          'ยอด Wallet เข้าเรียบร้อย',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFFFFFFFF),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'SukhumvitSet',
                                          ),
                                        ),
                                      );
                                      if (mounted) {
                                        setState(() {
                                          _allLottoList.removeWhere(
                                              (lotto) => lotto.lid == lid);
                                          _filteredLottoList.removeWhere(
                                              (lotto) => lotto.lid == lid);
                                        });
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Failed to delete LOTTO'),
                                        ),
                                      );
                                      print(
                                          'Failed to delete LOTTO: ${response.statusCode}');
                                    }
                                  } else {
                                    print(
                                        'Failed to update wallet: ${updateResponse.statusCode}');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to update wallet: ${updateResponse.statusCode}'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print('An error occurred: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'An error occurred, please try again later.'),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'รับรางวัล',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else if (response.statusCode == 404) {
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
                  height: 450,
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
                      Image.asset(
                        'assets/image/2.png',
                        width: 100,
                        height: 100,
                      ),
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
                        '$number',
                        style: const TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const Text(
                        'ไม่ถูกรางวัล',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 130,
                            height: 40,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFF92A47),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'ปิดเล๊ยยยยยย!',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
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
        print('Failed to load prize data: ${response.statusCode}');
      } else {
        print('Failed to load prize data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
