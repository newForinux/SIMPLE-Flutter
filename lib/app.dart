import 'package:flutter/material.dart';
import 'package:simple_flutter/update.dart';

import 'add.dart';
import 'detail.dart';
import 'home.dart';
import 'login.dart';

final PURPLE = 0xFF8182A7;

class SimpleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(PURPLE),
          backgroundColor: Colors.white,
          accentColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.black),
          ),
      ),
      title: 'SIMPLE flutter',
      home: HomePage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/add' : (context) => AddPage(),
        //'/profile' : (context) => ProfilePage(),
        '/detail' : (context) => DetailPage(),
        '/update' : (context) => UpdatePage(),
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

