import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference errands = FirebaseFirestore.instance
        .collection('errands');

    return Scaffold(
      appBar: AppBar(
        title: Text('게시판 목록'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/add');
            },
          ),
        ],
      ),
      body: ListView(

        children: [
          /*
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: errands.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                List<DocumentSnapshot> documents = snapshot.data!.docs;
                if(snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }
                return ListView(
                  children: _buildListCards(context, documents),
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
          */

        ],

      ),
    );
  }

  List<Card> _buildListCards(BuildContext context, List<DocumentSnapshot> documents) {
    return documents
        .map((docs) => Card (
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: docs);
        },
        child: Card(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Text(docs['title']),
                    Text(docs['description']),
                    TextButton(
                      child: Text('More', style: TextStyle(fontSize: 10)),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/detail', arguments: docs);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    )).toList();
  }
}
