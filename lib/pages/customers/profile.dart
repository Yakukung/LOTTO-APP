import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/pages/intro.dart';
import 'package:lotto_app/sidebar/CustomerSidebar.dart';

class ProfilePage extends StatefulWidget {
  final int uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UsersLoginPostResponse> loadDataUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController usernameCtl = TextEditingController();
  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDataUser = fetchUserData().then((user) {
      usernameCtl.text = user.username;
      fullnameCtl.text = user.fullname;
      emailCtl.text = user.email;
      phoneCtl.text = user.phone;
      passwordCtl.text = user.password!;
      imageCtl.text = user.image ?? '';
      return user;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    log(isPortrait ? 'Portrait' : 'Landscape');
    double customPadding = isPortrait ? 20.0 : 60.0;

    return FutureBuilder<UsersLoginPostResponse>(
      future: loadDataUser,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            key: _scaffoldKey,
            body: const Center(child: CircularProgressIndicator()),
            drawer: CustomerSidebar(
              imageUrl: '',
              fullname: '',
              uid: widget.uid,
              currentPage: 'profile',
            ),
          );
        }
        if (userSnapshot.hasError) {
          return Scaffold(
            key: _scaffoldKey,
            body: Center(child: Text('Error: ${userSnapshot.error}')),
            drawer: CustomerSidebar(
              imageUrl: '',
              fullname: '',
              uid: widget.uid,
              currentPage: 'profile',
            ),
          );
        }
        final user = userSnapshot.data!;

        return Scaffold(
          key: _scaffoldKey,
          drawer: CustomerSidebar(
            imageUrl: user.image ?? '',
            fullname: user.fullname,
            uid: user.uid,
            currentPage: 'profile',
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomPaint(
                  painter: HalfCirclePainter(),
                  child: Container(height: 300),
                ),
              ),
              Positioned(
                top: kToolbarHeight,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: openDrawer,
                        color: const Color(0xFF000000),
                        iconSize: 35.0,
                      ),
                      SizedBox(
                        width: 115, // Adjust width to fit content
                        height: 35,
                        child: FilledButton(
                          onPressed: deleteUser,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center content horizontally
                            children: [
                              Icon(Icons.delete_rounded,
                                  color: Color(0xFFF92A47), size: 18),
                              SizedBox(
                                  width:
                                      3), // Add some space between icon and text
                              Text('ลบบัญชีผู้ใช้',
                                  style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFFF92A47),
                                  )), // Ensure text color matches
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 30 + kToolbarHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 164,
                        height: 164,
                        child: ClipOval(
                          child: (user.image?.isNotEmpty ?? false) &&
                                  Uri.tryParse(user.image ?? '')?.isAbsolute ==
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
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
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
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
                        child: Row(
                          children: [
                            const Text(
                              'ชื่อ-สกุล',
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
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
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
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
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
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
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
                                  hintText: '${user.password}',
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
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void openDrawer() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.openDrawer();
    }
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

  Future<void> saveEdit() async {
    if (usernameCtl.text.trim().isEmpty ||
        fullnameCtl.text.trim().isEmpty ||
        emailCtl.text.trim().isEmpty ||
        phoneCtl.text.trim().isEmpty ||
        passwordCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                'อัพเดตข้อมูลเรียบร้อย',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF),
                                ),
                              )),
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
                          Navigator.of(context).pop();
                          final response = await http.delete(
                            Uri.parse(
                                '$API_ENDPOINT/customers/detail/delete/${widget.uid}'),
                          );
                          if (response.statusCode == 200) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const IntroPage(),
                              ),
                            );
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

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFFEAAC8B),
          Color(0xFFE88C7D),
          Color.fromARGB(248, 238, 85, 103),
          Color(0xFFB56576),
          Color(0xFF6D597A),
          Color(0xFF355070),
        ],
      ).createShader(Rect.fromLTRB(-50, -100, size.width, 250));

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.63)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height * 0.63)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
