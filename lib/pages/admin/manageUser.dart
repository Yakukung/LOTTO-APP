import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottomAdmin.dart';
import 'package:lotto_app/pages/admin/profileUser.dart';
import 'package:lotto_app/sidebar/adminSidebar.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/allUserGetResponse.dart';

class ManageUser extends StatefulWidget {
  final int uid;
  const ManageUser({super.key, required this.uid});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  late Future<UsersLoginPostResponse> loadDataUser;
  late Future<List<UsergetAlldata>>
      loadAlldataUser; // เปลี่ยนชนิดข้อมูลให้ถูกต้อง
  List<UsergetAlldata> userGetResponses = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String url = '';
  TextEditingController setWalletCtl = TextEditingController();
  @override
  void initState() {
    super.initState();
    log('Show User uid: ${widget.uid}');
    loadDataUser = fetchUserData();
    loadAlldataUser = fetchAllUser();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    log(isPortrait ? 'Portrait' : 'Landscape');
    double cardwidth = isPortrait
        ? (MediaQuery.of(context).size.width / 2) - 20
        : (MediaQuery.of(context).size.width / 3) - 20;

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
            final user = snapshot.data!;
            return CustomerSidebar(
              imageUrl: user.image ?? '',
              username: user.username,
              uid: user.uid,
              currentPage: 'manageUser',
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  }
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 5, right: 15),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'มาจัดการคนซื้อหวยกันเถอะ!',
                                    style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF7B7B7C),
                                    ),
                                  ),
                                  const Text(
                                    'จัดการข้อมูลสมาชิก',
                                    style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: 220,
                                            child: ElevatedButton(
                                              onPressed: _setWallet,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFFF92A47),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.edit_rounded,
                                                      color: Colors.white,
                                                      size: 20),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    'กำหนดค่าเริ่มต้น Wallet',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Color(0xFFFFFFFF),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ])),
                        FutureBuilder<List<UsergetAlldata>>(
                          future: loadAlldataUser,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            final List<UsergetAlldata> users = snapshot.data!;
                            return Center(
                              child: Container(
                                child: Wrap(
                                  spacing: 5.0,
                                  runSpacing: 5.0,
                                  children:
                                      List.generate(users.length, (index) {
                                    final user = users[index];
                                    Color cardColor = index % 2 == 0
                                        ? const Color.fromARGB(255, 1, 56, 86)
                                        : const Color.fromARGB(255, 243, 241,
                                            241); // ใช้สีตามลำดับ
                                    Color fontColor = index % 2 == 0
                                        ? const Color.fromARGB(
                                            255, 255, 255, 255)
                                        : const Color.fromARGB(255, 1, 56, 86);

                                    return SizedBox(
                                      width: cardwidth,
                                      height: 150,
                                      child: Card(
                                        color: cardColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.wallet,
                                                    color: Color.fromARGB(
                                                        228, 226, 174, 15),
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    '${user.wallet}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          228, 226, 174, 15),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    onPressed: () {
                                                      _showProfile(user.uid);
                                                    },
                                                    icon: const Icon(
                                                      Icons.more_horiz,
                                                      color: Color.fromARGB(
                                                          228,
                                                          226,
                                                          174,
                                                          15), // ตั้งค่าสีของไอคอนปุ่ม
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Center(
                                                child: Text(
                                                  user.username,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'SukhumvitSet',
                                                    fontWeight: FontWeight.w700,
                                                    color: fontColor,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 8),
                                                child: Center(
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 1.5,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              228,
                                                              226,
                                                              174,
                                                              15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'ชื่อ-สกุล : ${user.fullname}',
                                                style: TextStyle(
                                                  fontFamily: 'SukhumvitSet',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11,
                                                  color: fontColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
                          },
                        )
                      ]);
                }),
          ],
        )),
        bottomNavigationBar: NavBottom(
          uid: widget.uid,
          selectedIndex: 1,
        ),
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

  Future<List<UsergetAlldata>> fetchAllUser() async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/allusers'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => UsergetAlldata.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _showProfile(int uid) {
    Get.to(() => ProfileUser(uid: uid));
  }

  Future<void> _setWallet() async {
    final setWalletCtl = TextEditingController();

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
              height: 380,
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
                    'กำหนดค่าเริ่มต้น Wallet',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'คุณสามารถกำหนดค่าเริ่มต้น Wallet ได้ที่นี่',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // ช่องกรอกข้อความ
                  TextField(
                    controller: setWalletCtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF5F5F7),
                      hintText: 'ใส่จำนวนที่ต้องการ',
                      hintStyle: const TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(
                        Icons.wallet_rounded,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    onChanged: (value) {},
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
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final setWallet = setWalletCtl.text;
                          if (setWallet.isEmpty ||
                              double.tryParse(setWallet) == null) {
                            Get.snackbar(
                              '',
                              '',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Color(0xFFF92A47),
                              margin: EdgeInsets.all(30),
                              borderRadius: 22,
                              titleText: Text(
                                'แก้ไขไม่สำเร็จ!!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                              messageText: Text(
                                'กรุณาใส่ตัวเลขเพื่อกำหนดค่าเริ่มต้น Wallet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                            );
                            return;
                          }

                          var config = await Configuration.getConfig();
                          var url = config['apiEndpoint'];
                          var body = jsonEncode({
                            'wallet': setWallet,
                          });

                          var res = await http.put(
                            Uri.parse('$url/set-wallet'),
                            headers: {'Content-Type': 'application/json'},
                            body: body,
                          );

                          if (res.statusCode == 200) {
                            log('อัพเดตข้อมูลเรียบร้อย');
                            Get.snackbar(
                              '',
                              '',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.blue,
                              margin: EdgeInsets.all(30),
                              borderRadius: 22,
                              titleText: Text(
                                'กำหนดค่าเริ่มต้น Wallet สำเร็จ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                              messageText: Text(
                                'ยอด Wallet เริ่มต้น ${setWallet}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                            );
                            setState(() {
                              loadDataUser = fetchUserData();
                            });
                            Navigator.of(context).pop();
                          } else {
                            log('อัพเดตข้อมูลไม่ได้');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'อัพเดตข้อมูลไม่ได้ : ${res.reasonPhrase}')),
                            );
                          }
                        },
                        child: Text(
                          'ยืนยัน',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
        );
      },
    );
  }
}
