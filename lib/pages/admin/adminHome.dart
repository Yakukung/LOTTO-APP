import 'dart:developer';

import 'package:flutter/material.dart';

class AdminhomePage extends StatefulWidget {
  final int uid;
  const AdminhomePage({super.key, required this.uid});

  @override
  State<AdminhomePage> createState() => _AdminhomePageState();
}

class _AdminhomePageState extends State<AdminhomePage> {
  void initState() {
    super.initState();
    log('Show User uid: ${widget.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Container(
        child: Column(
          children: [Text('Uid: ${widget.uid}')],
        ),
      ),
    );
  }
}
