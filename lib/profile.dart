import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        actions: [
          IconButton(
            onPressed: () async {
              _signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                
                aspectRatio: 5.0 / 2.0,
                child: Image.network(
                  auth.currentUser!.photoURL.toString(),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Text(auth.currentUser!.displayName.toString()),
            Text(auth.currentUser!.email.toString()),
            Text(auth.currentUser!.uid),
          ],
        )

    );
  }
}
