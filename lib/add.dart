import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddPage extends StatefulWidget {
  static const routeName = '/add';
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  String imageUrl = 'https://blackmantkd.com/wp-content/uploads/2017/04/default-image-620x600.jpg';
  final CollectionReference errands = FirebaseFirestore.instance.collection('errands');
  var user = FirebaseAuth.instance.currentUser;

  /*
  List<String> _valueList = [
    '기타', '편의점', '커피&디저트', '중고거래대행', '약국', '택배&우편물',
    '세탁소&구두', '상품교환', '짐옮기기',
  ];
  var _selectedCategory = '기타';

   */

  final _titleController = TextEditingController();
  final _titleFormkey = GlobalKey<FormState>();
  final _rewardController = TextEditingController();
  final _descriptionController = TextEditingController();

  String formatTimestamp (int timestamp) {
    var format = DateFormat('d MMM, hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  Future<void> addCard() {
    //DateTime now = DateTime.now();
    //DateTime toUtc = DateTime(now.year, now.month, now.day).toUtc();
    return errands.doc(user!.uid).set({
      'category': 'category?',
      'title': _titleController.text,
      'description':_descriptionController.text,
      'reward': (_rewardController.text.isEmpty)? 0 : int.tryParse(_rewardController.text),
      'userId': user!.uid,
      // 'timestamp': FieldValue.serverTimestamp(),
      'timestamp': formatTimestamp(DateTime.now().millisecondsSinceEpoch),
      'ongoing': false,
      'done': false,
    })
        .then((value) => print("Added"))
        .catchError((error) => print("Failed to Add: $error"));
  }



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add'),
        actions: [
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              if (_titleFormkey.currentState!.validate()) {
                await errands.doc(user!.uid).set({
                  'category': args.toString(),
                  'title': _titleController.text,
                  'description':_descriptionController.text,
                  'reward': (_rewardController.text.isEmpty)? 0 : int.tryParse(_rewardController.text),
                  'userId': user!.uid,
                  'timestamp': FieldValue.serverTimestamp(),
                  'ongoing': false,
                  'done': false,
                  'image': imageUrl,
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data'),));
              }
            }
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('카테고리: ' + args.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            SizedBox(height:8),
            Form(
              key: _titleFormkey,
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '제목: ',
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
                    imageUrl,
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
                  hintText: '내용을 입력하세요: (시간, 장소, 진행 방식 등)',
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
                      hintText: '심부름 값:',
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

// how to use dropdown button:
/*
            Text('종류를 선택하세요', style: TextStyle(color: Colors.grey)),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                value: _selectedCategory,
                items: _valueList.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory= value.toString();
                  });
                },
              ),
            ),
            SizedBox(height:8),
            Divider(
              height: 8,
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(height:8),

             */