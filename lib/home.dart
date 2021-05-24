import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'appState/app_state.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판 목록'),
      ),
      body: ListView(
        children: [
          Text('homepage!'),
          FloatingActionButton(
            child: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () {
              Provider.of<ApplicationState>(context, listen: false).signOut();
              Navigator.popAndPushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
