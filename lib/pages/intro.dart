import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOTTO',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontSize: 68,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ซื้อ - ขาย ลอตเตอรี่เถื่อนที่โด่งดังที่สุดในประเทศไทย',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF92A47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(300, 50),
                    ),
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(300, 50),
                    ),
                    child: const Text(
                      'ลงทะเบียน',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
