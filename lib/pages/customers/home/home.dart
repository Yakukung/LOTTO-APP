import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/LottoGetResponse.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottom.dart';
import 'package:lotto_app/sidebar/CustomerSidebar.dart';
import 'package:lotto_app/pages/customers/home/add_basket.dart';

class HomePage extends StatefulWidget {
  final int uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UsersLoginPostResponse> loadDataUser;
  late Future<List<LottoGetResponse>> loadDataLotto;
  late Future<List<LottoGetResponse>> loadDataLottoPrize;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedType = 'ทั้งหมด';
  List<LottoGetResponse> filteredLottoData = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadDataUser = fetchUserData();
    loadDataLotto = fetchAllLotto();
    loadDataLottoPrize = loadDataLottoPrizeAsync();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double customPadding = isPortrait ? 20.0 : 60.0;

    double cardWidth = isPortrait
        ? (MediaQuery.of(context).size.width / 2) - 20
        : (MediaQuery.of(context).size.width / 3) - 60;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      key: _scaffoldKey,
      appBar: Navbar(loadDataUser: loadDataUser, scaffoldKey: _scaffoldKey),
      drawer: FutureBuilder<UsersLoginPostResponse>(
        future: loadDataUser,
        builder: (context, snapshot) => snapshot.hasData
            ? CustomerSidebar(
                imageUrl: snapshot.data!.image ?? '',
                fullname: snapshot.data!.fullname,
                uid: snapshot.data!.uid,
                currentPage: 'home',
              )
            : const Center(child: CircularProgressIndicator()),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<UsersLoginPostResponse>(
          future: loadDataUser,
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = userSnapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(user),
                _buildSearchBar(customPadding),
                _buildLottoPrizeSection(customPadding),
                _buildLottoTypeButtons(customPadding),
                Center(child: _buildLottoGrid(user, cardWidth)),
                SizedBox(height: 20)
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: NavBottom(
        uid: widget.uid,
        selectedIndex: 0,
      ),
    );
  }

  Widget _buildWelcomeSection(UsersLoginPostResponse user) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ยินดีต้อนรับ กลับมา!',
              style: TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF7B7B7C))),
          Text(user.fullname,
              style: const TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFF000000))),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double customPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customPadding, vertical: 16),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF5F5F7),
          hintText: 'ค้นหาเลขล็อตเตอรี่',
          prefixIcon: const Icon(Icons.search_rounded),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
        style: const TextStyle(
            fontFamily: 'SukhumvitSet',
            fontWeight: FontWeight.bold,
            fontSize: 16),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildLottoPrizeSection(double customPadding) {
    return FutureBuilder<List<LottoGetResponse>>(
      future: loadDataLottoPrize,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: customPadding),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final lottoData = snapshot.data![index];
              return Container(
                height: 134,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFEAAC8B),
                      Color(0xFFE88C7D),
                      Color(0xFFEE5566),
                      Color(0xFFB56576),
                      Color(0xFF6D597A)
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(lottoData.formattedDate,
                        style: const TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white)),
                    Text('รางวัลที่ ${lottoData.prize}',
                        style: const TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.w600,
                            fontSize: 26,
                            color: Colors.white)),
                    Container(
                      width: 190,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                          child: Text('${lottoData.number}',
                              style: const TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Colors.black))),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLottoTypeButtons(double customPadding) {
    return FutureBuilder<List<LottoGetResponse>>(
      future: loadDataLotto,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final lottoTypes =
            snapshot.data!.map((type) => type.type).toSet().toList();
        return Padding(
          padding: EdgeInsets.only(left: customPadding),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTypeButton('ทั้งหมด'),
              ...lottoTypes.map((type) => _buildTypeButton(type)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeButton(String type) {
    return ElevatedButton(
      onPressed: () => setState(() => selectedType = type),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selectedType == type ? Colors.black : Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 0,
      ),
      child: Text(
        type,
        style: TextStyle(
          fontFamily: 'SukhumvitSet',
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: selectedType == type ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildLottoGrid(UsersLoginPostResponse user, double cardWidth) {
    return FutureBuilder<List<LottoGetResponse>>(
      future: loadDataLotto,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        filteredLottoData = snapshot.data!
            .where((lotto) =>
                (selectedType == 'ทั้งหมด' || lotto.type == selectedType) &&
                lotto.number.toString().contains(searchQuery))
            .toList();
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: filteredLottoData
              .map((lotto) => _buildLottoCard(lotto, user, cardWidth))
              .toList(),
        );
      },
    );
  }

  Widget _buildLottoCard(
      LottoGetResponse lotto, UsersLoginPostResponse user, double cardWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: cardWidth,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(3, 4))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'หมายเลข',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF6C6C6C),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      lotto.type,
                      style: const TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${lotto.number}',
                style: const TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0000),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'คงเหลือ  ${lotto.lottoQuantity}${lotto.type == 'หวยชุด' ? '  ชุด' : lotto.type == 'หวยเดี่ยว' ? '  ใบ' : ''}',
                style: const TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.wallet,
                        size: 26,
                        color: Color(0xFFF92A47),
                      ),
                      Text(
                        '${lotto.price}',
                        style: const TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFFF92A47),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 70,
                    height: 27,
                    child: FilledButton(
                      onPressed: () => addBasket(user.uid, lotto.lid),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF92A47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'เพิ่มลงตะกร้า',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
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
      ),
    );
  }

  Future<UsersLoginPostResponse> fetchUserData() async {
    final response =
        await http.get(Uri.parse('$API_ENDPOINT/customers/${widget.uid}'));
    if (response.statusCode == 200) {
      return UsersLoginPostResponse.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load user data');
  }

  Future<List<LottoGetResponse>> loadDataLottoPrizeAsync() async {
    var config = await Configuration.getConfig();
    var res = await http.get(Uri.parse('${config['apiEndpoint']}/lotto-prize'));
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      List<LottoGetResponse> allLottoData =
          data.map((item) => LottoGetResponse.fromJson(item)).toList();
      DateTime mostRecentDate = allLottoData
          .map((data) => DateTime.parse(data.date))
          .reduce((a, b) => a.isAfter(b) ? a : b);
      return allLottoData
          .where((data) =>
              DateTime.parse(data.date).isAtSameMomentAs(mostRecentDate) &&
              data.prize == 1)
          .toList();
    }
    throw Exception('Failed to load lotto data');
  }

  Future<List<LottoGetResponse>> fetchAllLotto() async {
    var config = await Configuration.getConfig();
    var res = await http.get(Uri.parse('${config['apiEndpoint']}/lotto'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((item) => LottoGetResponse.fromJson(item))
          .toList();
    }
    throw Exception('Failed to load lotto prize data');
  }

  void addBasket(int uid, int lid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBasketPage(uid: uid, lid: lid),
    );
  }
}
