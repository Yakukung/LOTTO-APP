import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
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
            body: Center(child: CircularProgressIndicator()),
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: openDrawer,
                        color: Color(0xFF000000),
                        iconSize: 35.0,
                      ),
                      Text(
                        user.fullname,
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF000000),
                        ),
                      ),
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
                      SizedBox(height: 30),
                      Container(
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
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
                        child: Row(
                          children: [
                            Text(
                              'ชื่อผู้ใช้',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: usernameCtl,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF5F5F7),
                                  hintText: '${user.username}',
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
                            SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
                        child: Row(
                          children: [
                            Text(
                              'ชื่อ-สกุล',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: fullnameCtl,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF5F5F7),
                                  hintText: '${user.fullname}',
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
                            SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
                        child: Row(
                          children: [
                            Text(
                              'อีเมล',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: emailCtl,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF5F5F7),
                                  hintText: '${user.email}',
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
                            SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
                        child: Row(
                          children: [
                            Text(
                              'โทรศัพท์',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: phoneCtl,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF5F5F7),
                                  hintText: '${user.phone}',
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
                            SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
                        child: Row(
                          children: [
                            Text(
                              'รหัสผ่าน',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: passwordCtl,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF5F5F7),
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
                            SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            customPadding, 5, customPadding, 5),
                        child: Row(
                          children: [
                            Text(
                              'รูปภาพUrl',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: imageCtl,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF5F5F7),
                                  hintText: '${user.image}',
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
                            SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: saveEdit,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF92A47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
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
      print('ข้อมูล :${data}');
      return UsersLoginPostResponse.fromJson(data);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> saveEdit() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var body = jsonEncode({
      'username': usernameCtl.text,
      'fullname': fullnameCtl.text,
      'email': emailCtl.text,
      'phone': phoneCtl.text,
      'password': passwordCtl.text,
      'image': imageCtl.text,
    });

    var res = await http.put(
      Uri.parse('$url/customers/detail/update/${widget.uid}'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (res.statusCode == 200) {
      log('อัพเดตข้อมูลเรียบร้อย');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('อัพเดตข้อมูลเรียบร้อย')),
      );
      setState(() {
        loadDataUser = fetchUserData(); // รีเฟรชข้อมูลหลังจากบันทึก
      });
    } else {
      log('อัพเดตข้อมูลไม่ได้');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('อัพเดตข้อมูลไม่ได้ : ${res.reasonPhrase}')),
      );
    }
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
      ..shader = LinearGradient(
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
