import 'package:flutter/material.dart';
import 'package:my_flutter_app/home.dart';
import 'screens/emotitube_screen.dart';

void main() {
  runApp(const NaoZhongApp());
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
class NaoZhongApp extends StatelessWidget {
  const NaoZhongApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NaoZhongApp',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        fontFamily: 'PingFang SC',
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

