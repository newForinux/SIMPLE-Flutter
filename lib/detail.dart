import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'update.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail';
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var user = FirebaseAuth.instance.currentUser;
  CollectionReference errands = FirebaseFirestore.instance.collection('errands');



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            // title: const Text(''),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('정말 진행하시겠습니까?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('아니요'),
                onPressed: () async {
                  await errands.doc(args.data()!['userId']).update({
                    'ongoing': false,
                    'errander': '',
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('예'),
                onPressed: () async {
                  await errands.doc(args.data()!['userId']).update({
                    'ongoing': true,
                    'errander': FirebaseAuth.instance.currentUser!.displayName,
                  });
                  final snackBar = SnackBar(
                    content: Text('심부름 시작!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Detail'),
          actions: [
            (user!.uid == args.data()!['userId']) ?
            IconButton(
              icon: Icon(Icons.create),
              onPressed: () {
                Navigator.pushNamed(context, UpdatePage.routeName, arguments: args);
              },
            ) : Text(''),
            (user!.uid == args.data()!['userId']) ?
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await errands.doc(user!.uid).delete();
                Navigator.pop(context);
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
              Text("timestamp: " + args.data()!['timestamp'].toString()),
              Text("title: " + args.data()!['title']),
              Text("userId: " + args.data()!['userId']),
              Text("ongoing: " + args.data()!['ongoing'].toString()),
              RaisedButton(
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('진행하기'),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
                onPressed: () async {
                  _showMyDialog();

                },
              ),


              Padding(
                padding: const EdgeInsets.all(8),
                child: StreamBuilder<QuerySnapshot>(
                  stream: errands.where('userId', isEqualTo: args.data()!['userId']).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // List<DocumentSnapshot> documents = snapshot.data!.docs;
                    return Column(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        return Image.network(
                          document.data()!['image'],
                          width: 200,
                        );
                      }).toList(),
                    );

                    /*
                  return Image.network(
                    args.data()!['image'],
                    width: 200,
                  );

                   */

                  },
                ),
              )
            ],
          ),
        )
    );
  }
}
