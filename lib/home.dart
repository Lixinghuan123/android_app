import 'package:flutter/material.dart';
import 'package:my_flutter_app/coffee_prefs.dart';
import 'package:my_flutter_app/styled_body_text.dart';
import './movie/list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, 
    child: Scaffold(
        appBar: AppBar(
          title: Text('My First Flutter App',style: TextStyle(
            color: const Color.fromARGB(255, 58, 57, 54),
            fontWeight: FontWeight.bold,
          ),),
          backgroundColor: const Color.fromARGB(255, 185, 212, 234),
          centerTitle: true,
        ),
        drawer:Drawer(
          backgroundColor:const Color.fromARGB(255, 210, 175, 175),
          child:ListView(
            children:[
              Text('功能1'),
              Text('功能2'),
              Text('功能3'),
            ]
          ),
        ),
        bottomNavigationBar:Container(
          decoration: BoxDecoration(
           color: Colors.black,
          ),
          height:50,
          child:TabBar(tabs:[
          Tab(text:'yemian1'),
          Tab(text:'yemian2'),
          Tab(text:'yemian3'),
        ]),
        ),
        body: TabBarView(children: [
          MovieList(moodsText:'周一：开心13次；周二：伤心2次，愤怒一次，周三：疑惑三次'),
          MovieList(moodsText:'周一：平静2次；周二：焦虑2次，愤怒一次，周三：疑惑一次'),
          MovieList(moodsText:'周一：开心2次；周二：伤心2次'),

        ])
      ),
      );
      
  }
}