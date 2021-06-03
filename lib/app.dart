import 'package:flutter/material.dart';
import 'package:simple_flutter/category_selection.dart';
import 'package:simple_flutter/profile.dart';
import 'package:simple_flutter/update.dart';

import 'add.dart';
import 'detail.dart';
import 'detail.dart';
import 'home.dart';
import 'home.dart';
import 'home.dart';
import 'login.dart';

// final PURPLE = 0xFF8182A7;

class SimpleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        backgroundColor: Colors.white,
        accentColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.black),
        ),
      ),
      title: 'SIMPLE flutter',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
        AddPage.routeName: (context) => AddPage(),
        DetailPage.routeName: (context) => DetailPage(),
        UpdatePage.routeName: (context) => UpdatePage(),
        '/categorySelection': (context) => CategorySelectionPage(),
        '/profile': (context) => ProfilePage(),
      },

      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}