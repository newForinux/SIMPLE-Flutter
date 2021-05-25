import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';


class SimpleApp extends StatelessWidget {
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
      home: HomePage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        //'/add' : (context) => AddPage(),
        //'/profile' : (context) => ProfilePage(),
        //'/detail' : (context) => DetailPage(),
        //'/update' : (context) => UpdatePage(),
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

