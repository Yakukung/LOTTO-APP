import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/LottoGetResponse.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbottom.dart';
import 'package:lotto_app/sidebar/customerSidebar.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/nav/navbar.dart';

class CheckLotto extends StatefulWidget {
  final int uid;

  const CheckLotto({super.key, required this.uid});

  @override
  State<CheckLotto> createState() => _CheckLottoState();
}

class _CheckLottoState extends State<CheckLotto> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<UsersLoginPostResponse> loadDataUser;
  late Future<List<LottoGetResponse>> loadDataLottoPrize;
  List<LottoGetResponse> allLottoData = [];
  List<LottoGetResponse> filteredLottoData = [];

  TextEditingController searchCtl = TextEditingController();
  String searchResult = '';
  String lid = '';
  String wallet_prize = '';
  String total_lotto_prize = '';

  @override
  void initState() {
    super.initState();
    loadDataUser = fetchUserData(widget.uid);
    loadDataLottoPrize = loadDataLottoPrizeAsync().then((data) {
      setState(() {
        allLottoData = data;
        filteredLottoData = data;
      });
      return data;
    });
  }

  void checkLottoNumber(String number) {
    if (number.isEmpty) {
      setState(() {
        searchResult = '';
        lid = '';
      });
      return;
    }

    final List<LottoGetResponse> matchingLotto = allLottoData
        .where(
          (lotto) => lotto.number.toString() == number,
        )
        .toList();

    if (matchingLotto.isNotEmpty) {
      final winningLotto = matchingLotto.first;
      setState(() {
        searchResult = 'ยินดีด้วย! คุณถูกรางวัลที่ ${winningLotto.prize}';
        lid = '${winningLotto.lid}';
        wallet_prize = '${winningLotto.wallet_prize}';
      });
    } else {
      setState(() {
        searchResult = 'เสียใจด้วย คุณไม่ถูกรางวัล กินแกลบต่อไป!!!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double customPadding = isPortrait ? 20.0 : 60.0;

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
              currentPage: 'check_lotto',
            );
          }
          return const Drawer(child: Center(child: Text('No data available')));
        },
      ),
      body: FutureBuilder<List<LottoGetResponse>>(
        future: loadDataLottoPrize,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final lottoData = snapshot.data!;
            final groupedData = groupLottoByDate(lottoData);

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: customPadding,
                    right: customPadding,
                    top: 20,
                    bottom: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: searchCtl,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F5F7),
                        hintText: 'ตรวจสอบฉลาก',
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
                      onSubmitted: (value) {
                        checkLottoNumber(value);
                      },
                    ),
                    if (searchResult.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Image.asset(
                              searchResult.contains('ยินดีด้วย')
                                  ? 'assets/image/1.png'
                                  : 'assets/image/2.png',
                              width: 100,
                              height: 100,
                            ),
                            Text(
                              searchCtl.text,
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: searchResult.contains('ยินดีด้วย')
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              searchResult,
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: searchResult.contains('ยินดีด้วย')
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Text(
                          'ตรวจฉลาก LOTTO ย้อนหลัง',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ...groupedData.entries.map((entry) {
                      final date = formatDate(entry.key);
                      final items = entry.value;
                      return Container(
                        width: 350,
                        height: 360,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFEAAC8B),
                              Color(0xFFE88C7D),
                              Color(0xFFEE5566),
                              Color(0xFFB56576),
                              Color(0xFF6D597A),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Text(
                                        date,
                                        style: const TextStyle(
                                          fontFamily: 'SukhumvitSet',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: items.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 6),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'รางวัลที่ ${item.prize}',
                                              style: const TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.wallet_rounded,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  '${item.wallet_prize}',
                                                  style: const TextStyle(
                                                    fontFamily: 'SukhumvitSet',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          width: 170,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${item.number}',
                                              style: const TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('No lotto data available'));
        },
      ),
      bottomNavigationBar: NavBottom(
        uid: widget.uid,
        selectedIndex: 1,
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

  Future<List<LottoGetResponse>> loadDataLottoPrizeAsync() async {
    var config = await Configuration.getConfig();
    var res = await http.get(Uri.parse('${config['apiEndpoint']}/lotto-prize'));
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      List<LottoGetResponse> allLottoData =
          data.map((item) => LottoGetResponse.fromJson(item)).toList();
      return allLottoData;
    } else {
      throw Exception('Failed to load lotto data');
    }
  }

  Map<String, List<LottoGetResponse>> groupLottoByDate(
      List<LottoGetResponse> data) {
    Map<String, List<LottoGetResponse>> grouped = {};
    for (var item in data) {
      final date = item.date.split(' ').first;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(item);
    }
    return grouped;
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);

    const thaiMonths = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.'
    ];

    final day = parsedDate.day;
    final monthIndex = parsedDate.month - 1;

    return '$day ${thaiMonths[monthIndex]}';
  }
}
