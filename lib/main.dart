import 'package:flutter/material.dart';
import 'screens/emotitube_screen.dart';

void main() {
  runApp(const EmotiTubeApp());
}

class EmotiTubeApp extends StatelessWidget {
  const EmotiTubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EmotiTube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'PingFang SC',
      ),
      home: const EmotiTubeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

