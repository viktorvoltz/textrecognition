import 'package:flutter/material.dart';
import 'package:textrecognition/screens/first_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Recognition',
      home: FirstScreen(),
    );
  }
}

