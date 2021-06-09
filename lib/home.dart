import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add.dart';
import 'detail.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  static const routeName = '/home';
  //final String category;
  // const HomePage({Key? key, required this.category}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var user = FirebaseAuth.instance.currentUser;
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String args = arguments['category'];
    final String addr = arguments['address'];

    CollectionReference errands = FirebaseFirestore.instance
        .collection('errands');


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddPage.routeName, arguments: {'category': args, 'address': addr});
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: AppBar(
        centerTitle: true,
        title: Text(args),
        actions: [
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16,),
          Text('실시간 게시판 목록', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Vitro Pride"),),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // .orderBy('timestamp', descending: true)
              // .where('category', isEqualTo: args)
              stream: errands.where('category', isEqualTo: args).orderBy('timestamp', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;

                // print("document length is " + documents.length.toString());
                return ListView.builder(
                  itemCount: 1,
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, _) {
                    return Column(
                      children: _buildListCards(context, documents),
                    );
                  },
                  //children: _buildListCards(context, documents),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Card> _buildListCards(BuildContext context, List<DocumentSnapshot> documents) {
    return documents
        .map((docs) => Card (
      elevation: 20,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, DetailPage.routeName, arguments: docs);
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 5,
            child: Padding(
              padding: EdgeInsets.all(16),

              child: Row(
                children: [
                  Container(
                    // width: MediaQuery.of(context).size.width/2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.add_alert, color: Colors.orange,),
                            Text("  " + docs['creator'],
                              style: TextStyle(
                                fontFamily: "Vitro Pride",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(' 님의 심부름 요청', style: TextStyle(fontSize: 14),),
                          ],
                        ),
                        SizedBox(height: 12,),
                        Text(docs['title'],
                            style: TextStyle(
                              fontFamily: "Vitro Pride",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )
                        ),

                        SizedBox(height:8),
                        Text(docs['reward'].toString() + ' 원',
                            style: TextStyle(
                              color: Color(0xff3a9ad9),
                              fontSize: 16,
                            )
                        ),
                        SizedBox(height:12),

                        (docs['ongoing'] == true)?
                        Row(
                          children: [
                            Icon(Icons.person_pin_circle_sharp, color: Color(0xff3a9ad9),),
                            Text(' 심부름꾼 : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                            Text(docs['errander'] + ' 님', style: TextStyle(color: Colors.purple, fontSize: 12),),
                          ],
                        ) : Row(
                          children: [
                            Icon(Icons.person_pin_circle_sharp, color: Color(0xff3a9ad9),),
                            Text(' 심부름꾼 : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                            // Text(docs['errander'], style: TextStyle(color: Colors.green),),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    //padding: const EdgeInsets.all(8.0),
                    child: (docs['ongoing'] == true)? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text('진행중',
                              style: TextStyle(
                                color: Colors.white, fontFamily: "RobotoMono",
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Text("작성시간: " + docs['date'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            )
                        )
                      ],
                    ) :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text('진행가능',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Text("작성시간: " + docs['date'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )).toList();
  }
}