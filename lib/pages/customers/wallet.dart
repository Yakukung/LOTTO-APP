import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lotto_app/config/internal_config.dart';
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
  late Future<UsersLoginPostResponse> loadDataUser;

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

    return PopScope(
      canPop: false,
      child: Scaffold(
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
            future: loadDataUser,
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
                    padding: EdgeInsets.only(
                        left: customPadding, top: 15, right: customPadding),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: customPadding, right: 60),
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          const LinearGradient(
                                        colors: [
                                          Color(0xFFEAAC8B),
                                          Color(0xFFE88C7D),
                                          Color(0xFFEE5566),
                                          Color(0xFFB56576),
                                          Color(0xFF6D597A),
                                          Color(0xFF355070),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds),
                                      child: const Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text('เติมเงิน',
                                        style: TextStyle(
                                            fontFamily: 'SukhumvitSet',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF000000)))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [
                                        Color(0xFFEAAC8B),
                                        Color(0xFFE88C7D),
                                        Color(0xFFEE5566),
                                        Color(0xFFB56576),
                                        Color(0xFF6D597A),
                                        Color(0xFF355070),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: const Icon(
                                      Icons.currency_exchange_outlined,
                                      size: 45,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text('โอนเงิน',
                                      style: TextStyle(
                                          fontFamily: 'SukhumvitSet',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF000000)))
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Text('รายการย้อนหลัง',
                                    style: TextStyle(
                                        fontFamily: 'SukhumvitSet',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0xFFF92A47)))
                              ],
                            ),
                            Container(
                              color: const Color(0xFFF5F5F7),
                              child: const Column(
                                children: [
                                  Row(
                                    children: [],
                                  )
                                ],
                              ),
                            )
                          ],
                        )
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

  Future<UsersLoginPostResponse> fetchUserData(int uid) async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/customers/$uid'));
    if (response.statusCode == 200) {
      return UsersLoginPostResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
