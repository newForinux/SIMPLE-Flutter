import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.grey,
          backgroundColor: Colors.white,
          accentColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.black),
          )
      ),
      title: 'SIMPLE flutter',
      initialRoute: '/login',
      routes: {
        '/login' : (context) => LoginPage(),
        '/home' : (context) => HomePage(),
        //'/add' : (context) => AddPage(),
        //'/profile' : (context) => ProfilePage(),
        //'/detail' : (context) => DetailPage(),
        //'/update' : (context) => UpdatePage(),
      },

    );
  }

}