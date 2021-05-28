import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var user = FirebaseAuth.instance.currentUser;
  CollectionReference errands = FirebaseFirestore.instance.collection('errands');

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        actions: [
          (user!.uid == args.data()!['userId']) ?
              IconButton(
                icon: Icon(Icons.create),
                onPressed: () {
                  Navigator.pushNamed(context, '/update', arguments: args);
                },
              ) : Text(''),
          (user!.uid == args.data()!['userId']) ?
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await errands.doc(user!.uid).delete();
              await Navigator.popAndPushNamed(context, '/home');
            },
          ) : Text(''),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("category: " + args.data()!['category']),
            Text("description: " + args.data()!['description']),
            Text("reward: " + args.data()!['reward'].toString()),
            Text("timestamp: " + args.data()!['timestamp'].toDate().toString()),
            Text("title: " + args.data()!['title']),
            Text("userId: " + args.data()!['userId']),
          ],
        ),
      )
    );
  }
}
