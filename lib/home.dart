import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
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
      appBar: AppBar(
        title: Text('게시판 목록 (HOME) '),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text('Test: ' + args),
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
          FloatingActionButton(
            child: Icon(
              Icons.exit_to_app,
            ),
            onPressed: _signOut,
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
          Navigator.pushNamed(context, '/detail', arguments: docs);
        },
        child: Container(
          height: 200,
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
                        Text(docs['title']),
                        SizedBox(height:8),
                        Text(docs['reward'].toString() + '원'),
                        SizedBox(height:32),
                        Text(docs['timestamp'].toDate().toString(),
                          style: TextStyle(color: Colors.grey),),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
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
                          Text(docs['category'], style: TextStyle(color: Colors.white),)
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
    )).toList();
  }
}