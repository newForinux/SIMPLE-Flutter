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
    final args = ModalRoute.of(context)!.settings.arguments as String;

    CollectionReference errands = FirebaseFirestore.instance
        .collection('errands');


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddPage.routeName, arguments: args);
        },
        backgroundColor: Color(0xff3a9ad9),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: Text('실시간 게시판 목록 '),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          )
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: errands.where('category', isEqualTo: args).snapshots(),
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 180,
            child: Padding(
              padding: EdgeInsets.all(5),

              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(docs['title'],
                              style: TextStyle(
                                fontSize: 16,
                              )
                          ),
                          SizedBox(height:8),
                          Text(docs['reward'].toString() + '원',
                              style: TextStyle(
                                color: Color(0xff3a9ad9),
                                fontSize: 20,
                              )
                          ),
                          SizedBox(height:24),

                          (docs['ongoing'] == true)?
                          Row(
                            children: [
                              Text('심부름꾼 : ', style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(docs['errander'] + ' 님', style: TextStyle(color: Colors.purple),),
                            ],
                          ) : Row(
                            children: [
                              Text('심부름꾼 : ', style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(docs['errander'] + '없음', style: TextStyle(color: Colors.green),),
                            ],
                          ),

                          SizedBox(height: 8,),

                          Text('작성된 날짜 :' + docs['date'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              )
                          ),

                        ],
                      ),
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