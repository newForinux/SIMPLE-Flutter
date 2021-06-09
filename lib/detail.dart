import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'update.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:hexcolor/hexcolor.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail';
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var user = FirebaseAuth.instance.currentUser;
  CollectionReference errands = FirebaseFirestore.instance.collection('errands');
  String userImg = 'https://www.clipartkey.com/mpngs/m/152-1520367_user-profile-default-image-png-clipart-png-download.png';

  final _commentController = TextEditingController();
  bool _isComposing = false;

  final FocusNode _focusNode = FocusNode();


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
                  await errands.doc(args.data()!['serial_num']).update({
                    'ongoing': false,
                    'errander': '',
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('예'),
                onPressed: () async {
                  await errands.doc(args.data()!['serial_num']).update({
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
                await errands.doc(args.data()!['serial_num']).delete();
                Navigator.pop(context);
              },
            ) : Text(''),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              Row(
                children: [
                  Image.network(
                    userImg,
                    width: MediaQuery.of(context).size.width / 8,
                  ),
                  SizedBox(width: 8,),
                  Column(
                    children: [
                      Text(args.data()!['creator'].toString()),
                      Text(args.data()!['date'].toString()),
                    ],
                  ),
                  SizedBox(width:MediaQuery.of(context).size.width/4),
                  Expanded(
                    child: RaisedButton(
                      color: Color(0xff3a9ad9),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(' 진행하기 ',
                              style: TextStyle(
                                  color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: Colors.white,),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        _showMyDialog();

                      },
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2,
              ),
              Text(args.data()!['title'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20
                ),
              ),
              SizedBox(height: 8,),
              Text(args.data()!['description'],
                style: TextStyle(
                    fontSize: 16,
                ),
              ),

              (args.data()!['image'] != 'https://blackmantkd.com/wp-content/uploads/2017/04/default-image-620x600.jpg')?
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: StreamBuilder<QuerySnapshot>(
                  stream: errands.where('serial_num', isEqualTo: args.data()!['serial_num']).snapshots(),
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
                          width: MediaQuery.of(context).size.width,
                        );
                      }).toList(),
                    ); //: SizedBox(height: 0);
                  },
                ),
              ): SizedBox(height:0),

              SizedBox(height: 16,),
              Text('심부름 값:  ' + args.data()!['reward'].toString() + ' 원',
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.right,
              ),

              SizedBox(height: 16,),
              Text('댓글'),
              Divider(
                thickness: 2,
              ),


              // Text(args.data()!['creator'] + args.data()!['comment']),
              StreamBuilder<QuerySnapshot>(
                stream: errands.doc(args.data()!['serial_num'])
                    .collection('comments').orderBy('timestamp', descending: false).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<DocumentSnapshot> comments = snapshot.data!.docs;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildCommentsBox(context, comments),
                  ); //: SizedBox(height: 0);
                },

              ),



              SizedBox(height: 16,),
              Container(
                decoration: BoxDecoration(
                  color: HexColor("#d3d3d3"),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _commentController,
                          onChanged: (String text) {
                            setState(() {
                              _isComposing = text.isNotEmpty;
                            });
                          },
                          // onSubmitted: _isComposing? _handleSubmitted : null,
                          focusNode: _focusNode,
                          decoration:
                          InputDecoration.collapsed(hintText: ' 댓글을 입력하세요 '),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () async {
                                await errands.doc(args.data()!['serial_num']).collection('comments').add({
                                  'commentor': user!.displayName,
                                  'comment': _commentController.text,
                                  'time': DateFormat.Hm().format(DateTime.now().add(const Duration(hours: 9))),
                                  'timestamp': DateTime.now(),
                                });
                                _commentController.clear();
                              }
                          )
                      )

                    ],
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }

  List<Row> _buildCommentsBox(BuildContext context, List<DocumentSnapshot> comments) {
    return comments
        .map((comment) => Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment['commentor']),
            Text(comment['time'].toString(), style: TextStyle(color: Colors.grey),),
          ],
        ),
        SizedBox(width:12),
        Expanded(child: Text(comment['comment'], maxLines: 10,)),

      ],
    )).toList();
  }

}

