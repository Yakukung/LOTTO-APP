import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_app/pages/customers/basket.dart';
import 'package:lotto_app/pages/customers/check_lotto.dart';
import 'package:lotto_app/pages/customers/home/home.dart';
import 'package:lotto_app/pages/customers/wallet.dart';

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
          Get.to(() => HomePage(uid: widget.uid));
          break;
        case 1:
          Get.to(() => CheckLotto(uid: widget.uid));
          break;
        case 2:
          Get.to(() => BasketPage(uid: widget.uid));
          break;
        case 3:
          Get.to(() => WalletPage(uid: widget.uid));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
          ),
          child: Theme(
            data: ThemeData(
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
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
                  icon: Icon(
                    Icons.house_rounded,
                    size: 30.0,
                  ),
                  label: 'หน้าหลัก',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.confirmation_number,
                    size: 30.0,
                  ),
                  label: 'ตรวจฉลาก',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.shopping_basket,
                    size: 30.0,
                  ),
                  label: 'ตะกร้า',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.wallet_rounded,
                    size: 30.0,
                  ),
                  label: 'Wallet',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
