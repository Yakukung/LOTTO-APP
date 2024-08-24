// navbar.dart
import 'package:flutter/material.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final Future<UsersLoginPostResponse> loadDataUser;
  final GlobalKey<ScaffoldState> scaffoldKey;

  Navbar({
    required this.loadDataUser,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white.withOpacity(0.1),
      elevation: 0, // ปิดเงา
      title: FutureBuilder<UsersLoginPostResponse>(
        future: loadDataUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error');
          }
          final user = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => scaffoldKey.currentState?.openDrawer(),
                child: Container(
                  width: 55,
                  height: 55,
                  child: ClipOval(
                    child: (user.image?.isNotEmpty ?? false) &&
                            Uri.tryParse(user.image ?? '')?.isAbsolute == true
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
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFFEAAC8B),
                    Color(0xFFE88C7D),
                    Color(0xFFEE5566),
                    Color(0xFFB56576),
                    Color(0xFF6D597A),
                    Color(0xFF355070)
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
          );
        },
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
