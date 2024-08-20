import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  String? _selectedWalletAmount;

  final List<String> _walletAmounts = [
    '100',
    '200',
    '300',
    '500',
    '1000',
  ];

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color(0xFFEAAC8B),
                  Color(0xFFE88C7D),
                  Color(0xFFEE5566),
                  Color(0xFFB56576),
                  Color(0xFF6D597A),
                  Color(0xFF355070),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
              ).createShader(bounds),
              child: Text(
                'LOTTO',
                style: TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 70),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 50, left: 35, right: 35, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ลงทะเบียน',
                  style: TextStyle(
                    fontSize: 43,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SukhumvitSet',
                  ),
                ),
                Text(
                  'สร่างบัญชีใหม่ของคุณ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C6C6C),
                    fontFamily: 'SukhumvitSet',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF5F5F7),
                    hintText: 'ชื่อผู้ใช้',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black),
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
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF5F5F7),
                    hintText: 'ชื่อ-สกุล',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black),
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
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF5F5F7),
                    hintText: 'อีเมล',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.black),
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
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF5F5F7),
                    hintText: 'โทรศัพท์',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(Icons.phone_iphone, color: Colors.black),
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
                        _obscureText ? Icons.visibility_off : Icons.visibility,
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
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.wallet, color: Colors.black),
                      SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedWalletAmount,
                            hint: Text(
                              'เลือกจำนวน Wallet',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF000000),
                              ),
                            ),
                            items: _walletAmounts.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedWalletAmount = newValue;
                              });
                            },
                            dropdownColor: Color(0xFFF5F5F7),
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
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
                SizedBox(height: 24),
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
                      child: Transform.translate(
                        offset: Offset(0, -3),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo/icons8-apple.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
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
      ),
    );
  }
}
