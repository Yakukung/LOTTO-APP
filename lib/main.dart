import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotto_app/pages/intro.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('th_TH', null);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แอพเถื่อน',
      theme: ThemeData(),
      home: const IntroPage(),
    );
  }
}
