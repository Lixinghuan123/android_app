import 'package:flutter/material.dart';
import 'package:my_flutter_app/home.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Home()
    ),
  );
}
class Sandbox extends StatelessWidget {
  const Sandbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandbox'),
        backgroundColor: Colors.grey,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            color: Colors.redAccent,
            child: Text('one')
          ),
          Container(
            height: 200,
            color: const Color.fromARGB(255, 137, 118, 118),
            child: Text('two')
          ),
          Container(
            height: 300,
            color: const Color.fromARGB(255, 199, 145, 145),
            child: Text('three')
          ),
        ],
      ),
    );
  }
}
