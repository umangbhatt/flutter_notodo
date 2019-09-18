import 'package:flutter/material.dart';
import 'package:todo_app/ui/notodo_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.black54,
      ),
      home: NoToDoScreen(),
    
    );
  }
}

