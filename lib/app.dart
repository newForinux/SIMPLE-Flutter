import 'package:flutter/material.dart';
import 'package:simple_flutter/category_selection.dart';
import 'package:simple_flutter/google_map.dart';
import 'package:simple_flutter/profile.dart';
import 'package:simple_flutter/update.dart';

import 'add.dart';
import 'detail.dart';
import 'detail.dart';
import 'home.dart';
import 'home.dart';
import 'home.dart';
import 'login.dart';


class SimpleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff3a9ad9),
        backgroundColor: Colors.white,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white),
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
        '/map': (context) => MapPage(),
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