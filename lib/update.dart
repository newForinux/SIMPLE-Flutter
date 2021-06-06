import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'detail.dart';
import 'home.dart';

class UpdatePage extends StatefulWidget {
  static const routeName = '/update';
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String imageUrl = '';

  final CollectionReference errands = FirebaseFirestore.instance.collection('errands');
  var user = FirebaseAuth.instance.currentUser;

  List<String> _valueList = ['기타', '배달', '빨래'];
  var _selectedCategory = '기타';

  final _titleController = TextEditingController();
  final _update_title_formkey = GlobalKey<FormState>();
  final _rewardController = TextEditingController();
  final _descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final args_fromDetail = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    Future<void> updateCard() {

      return errands.doc(args_fromDetail.data()!['serial_num']).update({
        'title': _titleController.text,
        'description':_descriptionController.text,
        'reward': (_rewardController.text.isEmpty)? 0 : int.tryParse(_rewardController.text),
        'image': (imageUrl == '')? args_fromDetail.data()!['image'] : imageUrl,
        'date': DateFormat.Md().format(DateTime.now())
            + " " + DateFormat.Hm().format(DateTime.now().add(const Duration(hours: 9))),
        //'userId': user!.uid,
        //'timestamp': FieldValue.serverTimestamp(),

      })
          .then((value) => print("Added"))
          .catchError((error) => print("Failed to Add: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 수정'),
        actions: [
          TextButton(
            child: Text('취소', style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
              child: Text('저장', style: TextStyle(color: Colors.white),),
              onPressed: () async {
                  await updateCard();
                  final snackBar = SnackBar(
                    content: Text('업데이트 되었습니다!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pop(context);
                  Navigator.pop(context);
                //Navigator.pushNamed(context, HomePage.routeName, arguments: args_fromDetail.data()!['category']);
              }
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('카테고리: ' + args_fromDetail.data()!['category'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            SizedBox(height:8),
            Form(
              key: _update_title_formkey,
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: args_fromDetail.data()!['title'],
                  hintStyle: TextStyle(fontWeight: FontWeight.bold,),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '필수항목입니다';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                  (imageUrl == '')? args_fromDetail.data()!['image'] : imageUrl,
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                  IconButton(
                    onPressed: () => uploadImage(),
                    icon: Icon(Icons.drive_folder_upload),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: args_fromDetail.data()!['description'],
                ),
                maxLines: null,
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _rewardController,
                    decoration: InputDecoration(
                      hintText: args_fromDetail.data()!['reward'].toString(),
                    ),
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Container(
                  child: Text('  원'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    image = (await _picker.getImage(source: ImageSource.gallery))!;
    var file = File(image.path);

    if (image != null) {
      // Upload to Firebase

      var snapshot = await _storage.ref()
          .child(image.path)
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
      });
    }
  }

}
