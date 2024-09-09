import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lotto_app/pages/intro.dart';
import 'package:lotto_app/pages/customers/home/home.dart';
import 'package:lotto_app/pages/admin/adminHome.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('th_TH', null);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await GetStorage.init();

  final GetStorage storage = GetStorage();
  final int? uid = storage.read<int>('uid');
  final int? type = storage.read<int>('type');

  runApp(MyApp(uid: uid, type: type));
}

class MyApp extends StatelessWidget {
  final int? uid;
  final int? type;

  const MyApp({super.key, this.uid, this.type});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'แอพเถื่อน',
      theme: ThemeData(),
      home: _getHomePage(),
    );
  }

  Widget _getHomePage() {
    if (type == 0 && uid != null) {
      return AdminhomePage(uid: uid!);
    }
    if (type == 1 && uid != null) {
      return HomePage(uid: uid!);
    }
    return const IntroPage();
  }
}
