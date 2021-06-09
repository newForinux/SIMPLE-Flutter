import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

import 'update.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:hexcolor/hexcolor.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail';
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  bool _isComposing = false;
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference errands = FirebaseFirestore.instance.collection('errands');
  String userImg = 'https://www.clipartkey.com/mpngs/m/152-1520367_user-profile-default-image-png-clipart-png-download.png';

  final _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    String comment_serial = randomAlphaNumeric(10);

    DateTime deadline = args.data()!['deadline'].toDate();
    Duration remaining = deadline.difference(DateTime.now());

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
          IconButton(
            icon: (comment['commentor'] == user!.displayName.toString())? Icon(Icons.delete) : SizedBox(height: 0,),
            onPressed: () async {
              await errands.doc(args.data()!['serial_num'])
                  .collection('comments').doc(comment['comment_serial'].toString()).delete();
            },
          ),
        ],
      )).toList();
    }

    Future<void> _showCompleteDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('심부름 완료'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('심부름이 마무리되셨나요?'),
                  Text('(완료된 심부름은 다시 진행할 수 없습니다.)'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('아니요'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('예'),
                onPressed: () async {
                  await errands.doc(args.data()!['serial_num']).update({
                    'done': true,
                  });
                  final snackBar = SnackBar(
                    content: Text('심부름 완료!'),
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

    Future<void> _showProceedDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            // title: const Text(''),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('정말 진행/취소 하시겠습니까?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () async {
                  await errands.doc(args.data()!['serial_num']).update({
                    'ongoing': false,
                    'errander': '',
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('진행'),
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
          title: Text('심부름'),
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
              (user!.uid == args.data()!['userId'])?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '완료된 심부름은 완료 버튼을 꼭 눌러주세요!',
                    style: TextStyle(
                      color: Colors.pink, fontSize: 12, fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    child: Row(
                      children: [
                        Text('완료', style: TextStyle(fontWeight: FontWeight.bold),),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                        ),
                      ],
                    ),
                    onPressed: () {
                      _showCompleteDialog();
                    },
                  )
                ],
              ) : SizedBox(height: 0,),
              SizedBox(height: 8,),
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

              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '종료까지  ',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Vitro Pride',
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SlideCountdownClock(
                    duration: remaining,
                    slideDirection: SlideDirection.Down,
                    separator: ' : ',
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cafe24 surround',
                      color: Color(0xff3a9ad9),
                    ),
                  ),
                  Text(
                    '  남았어요!',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Vitro Pride',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Container(
                // ongoing: false 일때 보여짐, ongoing: true일때 errander한테만 보여짐
                // 안보이는 경우: ongoing: true && currentUser != errander && done: true ?
                child: ((args.data()!['ongoing'] == true && user!.displayName != args.data()!['errander']) || args.data()!['done'] == true) ?
                 SizedBox(height: 0,) :
                RaisedButton(
                  color: Color(0xff3a9ad9),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(' 심부름 진행/취소 ',
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
                    _showProceedDialog();

                  },
                ),
              ),
              
              SizedBox(height: 16,),
              Text('댓글'),
              Divider(
                thickness: 2,
              ),

              SizedBox(height: 16),
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
                                await errands.doc(args.data()!['serial_num']).collection('comments').doc(comment_serial).set({
                                  'commentor': user!.displayName,
                                  'comment': _commentController.text,
                                  'time': DateFormat.Hm().format(DateTime.now().add(const Duration(hours: 9))),
                                  'timestamp': DateTime.now(),
                                  'comment_serial': comment_serial,
                                });
                                _commentController.clear();
                              }
                          )
                      )

                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
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
            ],
          ),
        )
    );
  }

}

