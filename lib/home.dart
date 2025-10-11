import 'package:flutter/material.dart';
import 'package:my_flutter_app/coffee_prefs.dart';
import 'package:my_flutter_app/styled_body_text.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My First Flutter App',style: TextStyle(
            color: const Color.fromARGB(255, 58, 57, 54),
            fontWeight: FontWeight.bold,
          ),),
          backgroundColor: const Color.fromARGB(255, 185, 212, 234),
          centerTitle: true,
        ),
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 100,
            color: const Color.fromARGB(255, 157, 117, 117),
            child: StyledBodyText('央视文本')
          ),
          Container(
            width: 200,
            color: const Color.fromARGB(255, 114, 130, 165),
            child: const CoffeePrefs()
          ),
          Container(
            width: 300,
            color: const Color.fromARGB(255, 152, 162, 109),
            child: Text('three')
          ),
          Expanded(child:Image.asset('assets/img/天使.jpg',
          fit: BoxFit.fitHeight,
          alignment: AlignmentGeometry.bottomCenter),
          
          ) ,
        ],
      ),
      );
      
  }
}