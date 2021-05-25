import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'app.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SimpleApp());
}