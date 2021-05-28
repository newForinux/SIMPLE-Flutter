import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
  }

  // 익명 로그인
  Future<void> signInAnonymously() async {
    final UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
  }

  // 로그아웃
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}