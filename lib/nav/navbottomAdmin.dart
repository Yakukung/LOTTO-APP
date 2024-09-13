import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_app/pages/admin/adminHome.dart';
import 'package:lotto_app/pages/admin/manageUser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBottom extends StatefulWidget {
  final int uid;
  final int selectedIndex;

  const NavBottom({super.key, required this.uid, required this.selectedIndex});

  @override
  State<NavBottom> createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Get.to(() => AdminhomePage(uid: widget.uid));
          break;
        case 1:
          Get.to(() => ManageUser(uid: widget.uid));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double customPadding;
    Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      customPadding = 130.0;
    } else {
      customPadding = 100.0;
    }
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: Container(
        height: customPadding,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
        ),
        child: Theme(
          data: ThemeData(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(
                fontFamily: 'SukhumvitSet',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'SukhumvitSet',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black.withOpacity(0.3),
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.house_rounded),
                label: 'หน้าหลัก',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.userCog),
                label: 'จัดการข้อมูลสมาชิก',
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
