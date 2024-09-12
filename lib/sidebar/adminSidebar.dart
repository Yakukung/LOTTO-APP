import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/pages/admin/adminHome.dart';
import 'package:lotto_app/pages/admin/manageUser.dart';
import 'package:lotto_app/pages/intro.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CustomerSidebar extends StatelessWidget {
  final String imageUrl;
  final String username;
  final int uid;
  final String currentPage;

  const CustomerSidebar({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.uid,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double customPadding = isPortrait ? 20.0 : 60.0;

    return FractionallySizedBox(
      alignment: Alignment.topLeft,
      widthFactor: 0.7,
      heightFactor: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            color: const Color(0xFFF5F5F7).withOpacity(0.85),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: const Icon(Icons.cancel),
                      color: Colors.black,
                      iconSize: 50,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: customPadding, top: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipOval(
                              child: imageUrl.isNotEmpty &&
                                      Uri.tryParse(imageUrl)?.isAbsolute == true
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return _buildDefaultImage();
                                      },
                                    )
                                  : _buildDefaultImage(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        username,
                        style: const TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildMenuItem(
                  context,
                  customPadding: customPadding,
                  icon: Icons.house_rounded,
                  text: 'หน้าหลัก',
                  page: 'adminHome',
                  onTap: () {
                    Get.to(() => AdminhomePage(uid: uid));
                  },
                ),
                _buildMenuItem(
                  context,
                  customPadding: customPadding,
                  icon: Icons.manage_accounts,
                  text: 'จัดการข้อมูลสมาชิก',
                  page: 'manageUser',
                  onTap: () {
                    Get.to(() => ManageUser(uid: uid));
                  },
                ),
                _buildMenuItem(
                  context,
                  customPadding: customPadding,
                  icon: Icons.settings_backup_restore_rounded,
                  text: 'รีเซตระบบใหม่ทั้งหมด',
                  page: 'none',
                  onTap: () {
                    _showresetUser(context);
                  },
                ),
                const Divider(),
                const SizedBox(height: 50),
                _buildMenuItem(
                  context,
                  customPadding: customPadding,
                  icon: Icons.logout_rounded,
                  text: 'ออกจากระบบ',
                  page: 'logout', // เพิ่มค่า page
                  onTap: () {
                    _showLogoutConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required double customPadding,
      required IconData icon,
      required String text,
      required String page,
      required VoidCallback onTap}) {
    bool isSelected = currentPage == page;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: customPadding, right: customPadding),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.black,
                size: 38,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isSelected
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: ClipOval(
          child: Image.asset(
            'assets/logo/mc.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
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
                    'ยืนยันออกจากระบบ',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'คุณต้องการออกจากระบบใช่ไหม?',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
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
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const IntroPage(),
                          //   ),
                          // );
                          GetStorage gs = GetStorage();
                          gs.erase();
                          Get.offAll(() => IntroPage());
                        },
                        child: Text(
                          'ออกจากระบบ',
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

  void _showresetUser(BuildContext context) {
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
                    'ยืนยันรีเซ็ตเป็นค่าเริ่มต้น',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'ดำเนินการลบสมาชิกข้อมูลทั้งหมด เหลือเพียงแต่เจ้าของระบบ',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black,
                    ),
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
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => resetLottoTable(context),
                        child: Text(
                          'รีเซ็ตค่าเริ่มต้น',
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

  void resetLottoTable(BuildContext context) async {
    final url = Uri.parse('$API_ENDPOINT/admin/reset');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        Get.snackbar(
          '',
          '',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          margin: EdgeInsets.all(30),
          borderRadius: 20,
          titleText: Text(
            'แจ้งเตือน!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
              fontFamily: 'SukhumvitSet',
            ),
          ),
          messageText: Text(
            'รีเซ็ตค่าเริ่มต้นสำเร็จแย้ววววว',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.bold,
              fontFamily: 'SukhumvitSet',
            ),
          ),
        );
        print('Table "lotto" deleted successfully');
        Navigator.of(context).pop();
      } else {
        // ถ้ามีข้อผิดพลาด
        print('Failed to delete table: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete table: ${response.body}')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}
