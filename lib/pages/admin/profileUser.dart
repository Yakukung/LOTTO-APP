import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/pages/admin/manageUser.dart';

class ProfileUser extends StatefulWidget {
  final int uid;

  const ProfileUser({super.key, required this.uid});
  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  TextEditingController usernameCtl = TextEditingController();
  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController walletCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();

  late Future<UsersLoginPostResponse> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double customPadding = isPortrait ? 20.0 : 60.0;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: FutureBuilder<UsersLoginPostResponse>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // แสดงการโหลด
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var user = snapshot.data!;
              usernameCtl.text = user.username;
              fullnameCtl.text = user.fullname;
              emailCtl.text = user.email;
              phoneCtl.text = user.phone;
              passwordCtl.text = user.password.toString();
              imageCtl.text = user.image.toString();
              walletCtl.text = user.wallet.toString();

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 0,
                      bottom: customPadding,
                      left: customPadding,
                      right: customPadding),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 115,
                              height: 35,
                              child: FilledButton(
                                onPressed: deleteUser,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Center content horizontally
                                  children: [
                                    Icon(Icons.delete_rounded,
                                        color: Color(0xFFFFFFFF), size: 18),
                                    SizedBox(width: 3),
                                    Text('ลบบัญชีผู้ใช้',
                                        style: TextStyle(
                                          fontFamily: 'SukhumvitSet',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFFFFFFFF),
                                        )), // Ensure text color matches
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 164,
                          height: 164,
                          child: ClipOval(
                            child: (user.image?.isNotEmpty ?? false) &&
                                    Uri.tryParse(user.image ?? '')
                                            ?.isAbsolute ==
                                        true
                                ? Image.network(
                                    user.image!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildDefaultImage();
                                    },
                                  )
                                : _buildDefaultImage(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10,
                              bottom: customPadding,
                              left: customPadding,
                              right: customPadding),
                          child: Row(
                            children: [
                              const Text(
                                'ชื่อผู้ใช้',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: usernameCtl,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF5F5F7),
                                    hintText: user.username,
                                    hintStyle: const TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF7B7B7C),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5,
                              bottom: customPadding,
                              left: customPadding,
                              right: customPadding),
                          child: Row(
                            children: [
                              const Text(
                                'ชื่อสกุล',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: fullnameCtl,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF5F5F7),
                                    hintText: user.fullname,
                                    hintStyle: const TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF7B7B7C),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5,
                              bottom: customPadding,
                              left: customPadding,
                              right: customPadding),
                          child: Row(
                            children: [
                              const Text(
                                'อีเมล',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: emailCtl,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF5F5F7),
                                    hintText: user.email,
                                    hintStyle: const TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF7B7B7C),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5,
                              bottom: customPadding,
                              left: customPadding,
                              right: customPadding),
                          child: Row(
                            children: [
                              const Text(
                                'โทรศัพท์',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: phoneCtl,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF5F5F7),
                                    hintText: user.phone,
                                    hintStyle: const TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF7B7B7C),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5,
                              bottom: customPadding,
                              left: customPadding,
                              right: customPadding),
                          child: Row(
                            children: [
                              const Text(
                                'รหัสผ่าน',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: passwordCtl,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF5F5F7),
                                    hintText: user.password,
                                    hintStyle: const TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF7B7B7C),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              customPadding, 5, customPadding, 5),
                          child: Row(
                            children: [
                              const Text(
                                'รูปภาพUrl',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: imageCtl,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF5F5F7),
                                    hintText: user.image == null ||
                                            user.image!.trim().isEmpty
                                        ? 'ใส่ Url รูปภาพที่นี่'
                                        : user.image,
                                    hintStyle: const TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF7B7B7C),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15,
                              bottom: customPadding,
                              left: customPadding,
                              right: customPadding),
                          child: Row(
                            children: [
                              const Text(
                                'wallet',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: walletCtl,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF5F5F7),
                                    hintText: user.wallet.toString(),
                                    hintStyle: const TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF7B7B7C),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              child: TextButton(
                                onPressed: saveEdit,
                                child: Text(
                                  'บันทึก',
                                  style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Future<UsersLoginPostResponse> fetchUserData() async {
    final response = await http
        .get(Uri.parse('$API_ENDPOINT/customers/detail/${widget.uid}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UsersLoginPostResponse.fromJson(data);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Widget _buildDefaultImage() {
    return Center(
      child: SizedBox(
        child: ClipOval(
          child: Image.asset(
            'assets/logo/mc.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<void> saveEdit() async {
    if (usernameCtl.text.trim().isEmpty ||
        fullnameCtl.text.trim().isEmpty ||
        emailCtl.text.trim().isEmpty ||
        walletCtl.text.trim().isEmpty ||
        phoneCtl.text.trim().isEmpty ||
        passwordCtl.text.trim().isEmpty) {
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFF92A47),
        margin: EdgeInsets.all(30),
        borderRadius: 22,
        titleText: Text(
          'แก้ไขไม่ได้!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
            fontFamily: 'SukhumvitSet',
          ),
        ),
        messageText: Text(
          'กรุณากรอกข้อมูลให้ครบ',
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
      'username': usernameCtl.text.trim(),
      'fullname': fullnameCtl.text.trim(),
      'email': emailCtl.text.trim(),
      'phone': phoneCtl.text.trim(),
      'password': passwordCtl.text.trim(),
      'image': imageCtl.text.trim(),
      'wallet': walletCtl.text.trim(),
    });

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
                    'ยืนยันอัพเดตข้อมูลผู้ใช้',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'คุณต้องการอัพเดตข้อมูลใช่ไหม?',
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
                          var res = await http.put(
                            Uri.parse(
                                '$url/customers/detail/update/${widget.uid}'),
                            headers: {'Content-Type': 'application/json'},
                            body: body,
                          );

                          if (res.statusCode == 200) {
                            log('อัพเดตข้อมูลเรียบร้อย');
                            Get.snackbar(
                              '',
                              '',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue,
                              margin: EdgeInsets.all(30),
                              borderRadius: 22,
                              titleText: Text(
                                'อัพเดตข้อมูลสำเร็จ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                              messageText: Text(
                                'แก้ไขข้อมูลของคุณเรียบร้อย',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                            );
                            setState(() {
                              userFuture = fetchUserData();
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
                        child: const Text(
                          'อัพเดตข้อมูลผู้ใช้',
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

  Future<void> deleteUser() async {
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
                    'ยืนยันลบบัญชีผู้ใช้',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'คุณต้องการลบบัญชีผู้ใช้ใช่ไหม?',
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
                          final response = await http.delete(
                            Uri.parse(
                                '$API_ENDPOINT/customers/detail/delete/${widget.uid}'),
                          );
                          if (response.statusCode == 200) {
                            GetStorage storage = GetStorage();
                            int admin_id = storage.read('uid');
                            print('Admin id: ${admin_id}');
                            Get.to(() => ManageUser(uid: admin_id));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to delete account')),
                            );
                          }
                        },
                        child: const Text(
                          'ลบบัญชีผู้ใช้',
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
