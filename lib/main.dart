import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:provider/provider.dart';
import 'package:simple_flutter/appState/app_state.dart';
import 'app.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => SimpleApp(),
    ),
  );
}