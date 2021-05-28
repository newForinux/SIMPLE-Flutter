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

  Future<void> signInAnonymously() async {
    final UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff3a9ad9),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 100),
              Column(
                children: [
                  Text(
                    '심플',
                    style: TextStyle(
                      fontFamily: "Cafe24 Surround",
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 60,
                    child: Divider(
                      height: 0,
                      thickness: 3.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '당신의 심부름 플레이스',
                    style: TextStyle(
                      fontFamily: "Vitro Pride",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Container(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            Navigator.pushNamed(context, '/categorySelection');
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
                      ),
                    ),
                    ElevatedButton(
                        child:Text('anonymous log in'),
                        onPressed: () async {
                          signInAnonymously();
                          await Navigator.pushNamed(context, '/categorySelection');
                        }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/screen.png"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}