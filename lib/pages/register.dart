import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_app/animation/AnimatedCheckmark.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Request/UsersRegisterPostRequest.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/pages/intro.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  bool _obscureTextCF = true;
  String errorText = '';
  TextEditingController usernameCtl = TextEditingController();
  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController confirmpasswordtCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    log(isPortrait ? 'Portrait' : 'Landscape');
    double customPadding = isPortrait ? 35.0 : 70.0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
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
              child: const Text(
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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 50, left: customPadding, right: customPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                const Text(
                  'ลงทะเบียน',
                  style: TextStyle(
                    fontSize: 43,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SukhumvitSet',
                  ),
                ),
                const Text(
                  'สร้างบัญชีใหม่ของคุณ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C6C6C),
                    fontFamily: 'SukhumvitSet',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: usernameCtl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F7),
                    hintText: 'ชื่อผู้ใช้',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF7B7B7C),
                    ),
                    prefixIcon: const Icon(Icons.person, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: fullnameCtl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F7),
                    hintText: 'ชื่อ-สกุล',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF7B7B7C),
                    ),
                    prefixIcon: const Icon(Icons.person, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailCtl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F7),
                    hintText: 'อีเมล',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF7B7B7C),
                    ),
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: phoneCtl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F7),
                    hintText: 'โทรศัพท์',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF7B7B7C),
                    ),
                    prefixIcon:
                        const Icon(Icons.phone_iphone, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordCtl,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F7),
                    hintText: 'รหัสผ่าน',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF7B7B7C),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: confirmpasswordtCtl,
                  obscureText: _obscureTextCF,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F7),
                    hintText: 'ยืนยันรหัสผ่าน',
                    hintStyle: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF7B7B7C),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextCF
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _toggleCFPasswordVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF92A47),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'ยืนยันการลงทะเบียน',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.only(right: 8),
                      ),
                    ),
                    const Text(
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
                        margin: const EdgeInsets.only(left: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
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
                    const SizedBox(width: 16),
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
                    const SizedBox(width: 16),
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 24,
                      child: Transform.translate(
                        offset: const Offset(0, -3),
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
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {});
    _obscureText = !_obscureText;
  }

  void _toggleCFPasswordVisibility() {
    setState(() {});
    _obscureTextCF = !_obscureTextCF;
  }

  Future<void> register() async {
    log('username: ${usernameCtl.text}');
    log('fullname: ${fullnameCtl.text}');
    log('email: ${emailCtl.text}');
    log('phone: ${phoneCtl.text}');
    log('password: ${passwordCtl.text}');
    log('confrimpass: ${confirmpasswordtCtl}');

    if (usernameCtl.text.isEmpty ||
        fullnameCtl.text.isEmpty ||
        emailCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        passwordCtl.text.isEmpty ||
        confirmpasswordtCtl.text.isEmpty) {
      setState(() {
        errorText = 'กรุณาใส่ข้อมูลให้ครบทุกช่อง';
      });
      _showErrorDialog('กรุณาใส่ข้อมูลให้ครบทุกช่อง');
      return;
    }
    if (confirmpasswordtCtl.text == passwordCtl.text) {
      var data = UsersRegisterPostRequest(
        username: usernameCtl.text,
        fullname: fullnameCtl.text,
        email: emailCtl.text,
        phone: phoneCtl.text,
        password: passwordCtl.text,
      );
      log('Sending data: ${jsonEncode(data.toJson())}');

      try {
        var response = await http.post(
          Uri.parse('$API_ENDPOINT/register'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(data.toJson()),
        );
        log('Status code: ${response.statusCode}');
        log('Response body: ${response.body}');

        if (response.statusCode == 200) {
          _showSuccessDialog(); // Show success dialog
        } else {
          var responseData = jsonDecode(response.body);
          log('Response data: $responseData');

          String errorMessage = 'ไม่สามารถลงทะเบียนได้ ลองใหม่อีกครั้ง';

          if (responseData is Map<String, dynamic> &&
              responseData.containsKey('error')) {
            String errorType = responseData['error'];

            if (errorType.contains('UNIQUE constraint failed')) {
              if (errorType.contains('users.username')) {
                errorMessage = 'ชื่อผู้ใช้นี้มีการใช้งานอยู่แล้ว';
              } else if (errorType.contains('users.email')) {
                errorMessage = 'อีเมลนี้มีการใช้งานอยู่แล้ว';
              } else if (errorType.contains('users.phone')) {
                errorMessage = 'หมายเลขโทรศัพท์นี้มีการใช้งานอยู่แล้ว';
              }
            }
          }

          setState(() {
            errorText = errorMessage;
          });
          _showErrorDialog(errorMessage);
        }
      } catch (e) {
        log('Error: $e');
        setState(() {
          errorText = 'ไม่สามารถลงทะเบียนได้ ลองใหม่อีกครั้ง';
        });
        _showErrorDialog(
            'ไม่สามารถลงทะเบียนได้ ลองใหม่อีกครั้ง'); // Show error dialog
      }
    } else {
      setState(() {
        errorText = 'กรุณาใส่รหัสผ่านให้เหมือนกัน';
      });
      _showErrorDialog('กรุณาใส่รหัสผ่านให้เหมือนกัน');
      return;
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              ),
              Container(
                height: 210,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    AnimatedCheckmark(isSuccess: true),
                    const SizedBox(height: 10),
                    Container(
                      child: const Text(
                        'ลงทะเบียนสำเร็จ',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'ชื่อผู้ใช้ : ${usernameCtl.text}',
                      style: const TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                            color: Color(0xffB3B3B3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                child: TextButton(
                                  child: const Text(
                                    'ตกลง',
                                    style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF007AFF),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() => IntroPage());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              ),
              Container(
                height: 210,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    AnimatedCheckmark(isSuccess: false),
                    const SizedBox(height: 10),
                    Container(
                      child: const Text(
                        'ลงทะเบียนไม่สำเร็จ',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message,
                      style: const TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                            color: Color(0xffB3B3B3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                child: TextButton(
                                  child: const Text(
                                    'ตกลง',
                                    style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF007AFF),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
