import 'package:flutter/material.dart';

import 'TodoScreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Http Client',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: TodoScreen()
    );
  }
}

