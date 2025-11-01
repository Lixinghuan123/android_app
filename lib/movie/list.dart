import 'package:dio/dio.dart';
import 'package:flutter/material.dart';




class MovieList extends StatefulWidget {
  const MovieList({super.key,
   required this.moodsText,
     this.mt,
  });
  final String? mt;
  final String  moodsText;

  @override
  State<MovieList> createState() => _MovieState();
}

class _MovieState extends State<MovieList> {
    @override
  void initState() {
    super.initState();
    _fetchData();
    
  }
  var mlist=[];

  Future<void> _fetchData() async {
    final dio = Dio();
    try {
     final response = await dio.post(
        'http://127.0.0.1:8000/mood_summary',
        data: {
          'moods': widget.moodsText, // moodsText 是你的字符串变量
        },
        options: Options(
          headers: {'Content-Type': 'application/json; charset=utf-8'},
        ),
      );
    var result=response.data;
    
    //  print(result);
     if (mounted) {
  setState(() {
    // 更新状态
    mlist=result['summary'];
    print(mlist);
  });
}
     
    } catch (e) {
      print('请求失败: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Text('电影列表页面${widget.mt}');
  }
}