import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'app.dart';
import 'appState/app_state.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Modify from here (Step5)
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => MyApp(),
    ),
  );
  // to here. (Step5)
}