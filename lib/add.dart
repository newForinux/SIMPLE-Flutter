import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';

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

  List<String> _durationList = [
    '1일(24시간)', '2일(48시간)', '3일(72시간)', '일주일',
  ];
  var _selectedDuration = '1일(24시간)';

  final _titleController = TextEditingController();
  final _titleFormkey = GlobalKey<FormState>();
  final _rewardController = TextEditingController();
  final _descriptionController = TextEditingController();

  String formatTimestamp (int timestamp) {
    var format = DateFormat('Md, hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  String serial_num = randomAlphaNumeric(10);

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String _args = arguments['errand'];
    final String _loc = arguments['loc'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '추가하기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cafe24 Surround'
          ),
        ),
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
                  _args,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Vitro Pride',
                  ),
                ),
              ],
            ),
            SizedBox(height:8),
            Row(
              children: [
                Text(
                  '플레이스 ',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  _loc,
                  style: TextStyle(
                    fontSize: 18.0,
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
                      hintText: '1000',
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
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  '마감 기한 ',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.0),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _selectedDuration,
                    items: _durationList.map(
                          (value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDuration= value.toString();
                      });
                    },
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
                controller: _titleController,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
                decoration: InputDecoration(
                  hintText: '제목을 적어주세요',
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
                    imageUrl,
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
                  hintText: '내용을 입력하세요: (시간, 장소, 진행 방식 등)',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 250,
        child: FloatingActionButton.extended(
        backgroundColor: Color(0xff3a9ad9),
        onPressed: () async {
          if (_titleFormkey.currentState!.validate()) {
            await errands.doc(serial_num).set({
              'category': _args,
              'title': _titleController.text,
              'description':_descriptionController.text,
              'reward': (_rewardController.text.isEmpty)? 0 : int.tryParse(_rewardController.text),
              'userId': user!.uid,
              'creator': user!.displayName,
              'creator_img': user!.photoURL,
              'date': DateFormat.Md().format(DateTime.now())
                  + " " + DateFormat.Hm().format(DateTime.now().add(const Duration(hours: 9))),
              'timestamp': DateTime.now().toUtc(),
              'ongoing': false,
              'done': false,
              'image': imageUrl,
              'duration': _selectedDuration,
              'errander': '',
              'serial_num': serial_num,
              'location': _loc,
            }).then((value) => Navigator.pop(context));

          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data'),));
          }
        },

        icon: Icon(
          Icons.save_alt_outlined,
          color: Colors.white,
        ),
        label: Text(
          '심부름 등록하기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vitro Pride'
          ),
        ),
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

/*
  Future<void> addCard() {
    //DateTime now = DateTime.now();
    //DateTime toUtc = DateTime(now.year, now.month, now.day).toUtc();
    return errands.doc(_titleController.text).set({
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

   */

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