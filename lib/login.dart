import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80),
            Column(
              children: [
                Text('심플')
              ],
            ),
            ButtonTheme(
              height: 40,
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
                side: BorderSide.none
              ),
              child: ElevatedButton(
                onPressed: () {
                  signInWithGoogle().then((UserCredential userCredential) {
                    Navigator.pop(context);
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 38.0,
                        width: 38.0,
                        decoration: BoxDecoration(
                          color: null,
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Center(
                          child: Image.network(
                            'https://pngimg.com/uploads/google/google_PNG19635.png',
                            fit: BoxFit.cover,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                      child: Text(
                        "구글 아이디로 로그인",
                        style: GoogleFonts.notoSans(
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black.withOpacity(0.54),
                          )
                        ),
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}