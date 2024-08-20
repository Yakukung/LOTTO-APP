import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        initialChildSize: 0.73,
        minChildSize: 0.73,
        maxChildSize: 1.0,
        expand: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: ListView(
                controller: scrollController,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Column(
                    children: [
                      Text(
                        'ยินดีต้อนรับกลับ',
                        style: TextStyle(
                          fontSize: 43,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SukhumvitSet',
                        ),
                      ),
                      Text(
                        'เข้าสู่ระบบของคุณ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C6C6C),
                          fontFamily: 'SukhumvitSet',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF5F5F7),
                      hintText: 'ชื่อผู้ใช้ หรือ ที่อยู่อีเมล',
                      hintStyle: const TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
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
                  ),
                  SizedBox(height: 15),
                  TextField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF5F5F7),
                      hintText: 'รหัสผ่าน',
                      hintStyle: const TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
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
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'ลืมรหัสผ่าน?',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF92A47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.only(right: 8),
                        ),
                      ),
                      Text(
                        'หรือ ดำเนินต่อด้วยวิธีอื่น',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.only(left: 8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 24,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo/icons8-facebook.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 24,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo/icons8-google.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 24,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo/icons8-apple.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
