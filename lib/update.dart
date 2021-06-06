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

  final _titleController = TextEditingController();
  final _update_title_formkey = GlobalKey<FormState>();
  final _titleFormkey = GlobalKey<FormState>();
  final _rewardController = TextEditingController();
  final _descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final args_fromDetail = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;


    // 바뀐게 없으면 args_fromDetail 이용해서 원래 내용을 저장, 만약 유저가 수정한 부분이 있으면 해당 부분 저장
    Future<void> updateCard() {

      return errands.doc(args_fromDetail.data()!['serial_num']).update({
        'title': (_titleController.text.isEmpty)?
          args_fromDetail.data()!['title'] : _titleController.text,
        'description': _descriptionController.text.isEmpty?
          args_fromDetail.data()!['description'] : _descriptionController.text,
        'reward': (_rewardController.text.isEmpty)?
          args_fromDetail.data()!['reward'] : int.tryParse(_rewardController.text),
        'image': (imageUrl == '')? args_fromDetail.data()!['image'] : imageUrl,
        'date': DateFormat.Md().format(DateTime.now())
            + " " + DateFormat.Hm().format(DateTime.now().add(const Duration(hours: 9))),
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
            Row(
              children: [
                Text(
                  '카테고리 ',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  args_fromDetail.data()!['category'],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Vitro Pride',
                  ),
                ),
              ],
            ),
            SizedBox(height:8),
            Row(
              children: [
                Text(
                  '지급 비용 ',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  width: 100,
                  child: TextField(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Color(0xff3a9ad9),
                    ),
                    controller: _rewardController,
                    decoration: InputDecoration(
                      hintText: args_fromDetail.data()!['reward'].toString(),
                      hintStyle: TextStyle(
                        color: Color(0xff3a9ad9),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),

                Container(
                  child: Text(
                    ' 원',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),

                ),
              ],
            ),

            SizedBox(
              height: 16.0,
            ),
            Form(
              key: _titleFormkey,
              child: TextFormField(
                maxLength: 16,
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
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(
                            width: 2.0,
                            color: Colors.black,
                          )
                      ),
                      onPressed: () => uploadImage(),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Image.network(
                    (imageUrl == '')? args_fromDetail.data()!['image'] : imageUrl,
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 300,
              color: Colors.grey[200],
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: args_fromDetail.data()!['description'],
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                maxLines: null,
              ),
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
