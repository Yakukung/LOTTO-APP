import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottom.dart';
import 'package:lotto_app/sidebar/customerSidebar.dart';
import 'package:http/http.dart' as http;

class BasketPage extends StatefulWidget {
  final int uid;
  const BasketPage({super.key, required this.uid});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<UsersLoginPostResponse> loadDataUser;
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    loadDataUser = fetchUserData(widget.uid);
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
              currentPage: 'basket',
            );
          } else {
            return const Drawer(
                child: Center(child: Text('No data available')));
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(customPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ตะกร้าสินค้า',
                  style: TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: Color(0xFF000000),
                  ),
                ),
                const Text(
                  'เลือกซื้อล็อตเตอรี่ที่คุณเพิ่มมาได้เลย!',
                  style: TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF6C6C6C),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: selectAll,
                      onChanged: (value) {
                        setState(() {
                          selectAll = value!;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xFFF92A47);
                        }
                        return Colors.transparent;
                      }),
                    ),
                    const Text(
                      'เลือกทั้งหมด',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.all(customPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 200,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'รวมทั้งหมด',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            const Text(
                              '฿400.00',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Color(0xFFF92A47),
                              ),
                            ),
                            SizedBox(
                              width: 178, // Adjust width to fit content
                              height: 30,
                              child: FilledButton(
                                onPressed: () {},
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
                                    fontSize: 14,
                                    color: Color(0xFFFFFFFF),
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBottom(
        uid: widget.uid,
        selectedIndex: 2,
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
}
