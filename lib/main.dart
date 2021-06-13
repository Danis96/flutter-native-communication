import 'package:examplenativecommunication/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter-Native example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter-Native example'),
        ),
        body: HomePage()
      ),
    );
  }
}


