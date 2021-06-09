import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  CollectionReference errands = FirebaseFirestore.instance
      .collection('errands');
  FirebaseAuth auth = FirebaseAuth.instance;
  var user = FirebaseAuth.instance.currentUser;


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
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),

              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/8,
                decoration: BoxDecoration(
                  color: Color(0xff3a9ad9),
                  borderRadius: BorderRadius.circular(4),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 3.0 / 2.0,
                        child: Image.network(
                          auth.currentUser!.photoURL.toString(),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('  ' + auth.currentUser!.displayName.toString(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        SizedBox(height: 16,),
                        Text('  ' + auth.currentUser!.email.toString(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user!.displayName.toString() + ' 님이 요청한 심부름 ',
                    style: TextStyle(fontFamily: "Vitro Pride", fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(height: 8,),
                  StreamBuilder<QuerySnapshot>(
                    stream: errands.where('userId', isEqualTo: user!.uid).where('done', isEqualTo: false).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return Text('현재 ' + snapshot.data!.size.toString() + '개의 심부름을 요청 중입니다.',
                          style: TextStyle(fontSize: 20, color: Color(0xff3a9ad9)),);
                      }
                      return Center(child: CircularProgressIndicator(),);
                    },
                  ),
                  SizedBox(height: 16,),
                  Text(user!.displayName.toString() + ' 님이 진행중인 심부름  ',
                      style: TextStyle(fontFamily: "Vitro Pride", fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8,),
                  StreamBuilder<QuerySnapshot>(
                    stream: errands.where('errander', isEqualTo: user!.displayName).where('done', isEqualTo: false).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return Text('현재 ' + snapshot.data!.size.toString() + '개의 심부름을 진행 중입니다.',
                            style: TextStyle(fontSize: 20, color: Color(0xff3a9ad9)));
                      }
                      return Center(child: CircularProgressIndicator(),);
                    },
                  ),
                ],
              ),
            ),

          ],
        )

      /*Column(
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

       */

    );
  }
}