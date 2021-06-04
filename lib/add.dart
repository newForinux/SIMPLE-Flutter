import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_flutter/app.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final CollectionReference errands = FirebaseFirestore.instance.collection('errands');
  var user = FirebaseAuth.instance.currentUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _productImageUrl = "";


  late File _image;
  final picker = ImagePicker();
  final _titleController = TextEditingController();
  final _titleFormKey = GlobalKey<FormState>();
  final _rewardController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image selected.");
      }
    });
  }


  Future<void> addCard(String category) {
    if (category.compareTo("카페/디저트") == 0)
      category = "카페";
    else if (category.compareTo("세탁/클리닝") == 0)
      category = "세탁";

    return FirebaseFirestore.instance.collection(category).add({
      'category': category,
      'title': _titleController.text,
      'description':_descriptionController.text,
      'reward': (_rewardController.text.isEmpty)? 1000 : int.tryParse(_rewardController.text),
      'userId': user!.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'ongoing_list': [],
      'image': _productImageUrl,
      'ongoing': false,
      'done': false,
    })
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("Failed to Add: $error"));
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('심부름 등록'),
        actions: [
          TextButton(
            child: Text(
              '등록',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              if (_titleFormKey.currentState!.validate()) {
                await addCard(argument);
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
            Row(
              children: [
                Text(
                  '카테고리',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                SizedBox(width: 15),
                Text(
                  argument,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Vitro Pride',
                  ),
                )
                // DropdownButtonHideUnderline(
                //   child: DropdownButton(
                //     value: _selectedCategory,
                //     items: _errandsList.map((value) {
                //         return DropdownMenuItem(
                //           value: value,
                //           child: Text(value),
                //         );
                //       },
                //     ).toList(),
                //     onChanged: (value) {
                //       setState(() {
                //         _selectedCategory= value.toString();
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                    '지급 비용',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                SizedBox(width: 15),
                Flexible(
                  child: Container(
                    width: 100,
                    child: TextField(
                      style: TextStyle(
                        color: Color(PURPLE),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: _rewardController,
                      decoration: InputDecoration(
                        hintText: '1000',
                        hintStyle: TextStyle(
                          color: Color(PURPLE),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Text(
                      '  원',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            Form(
              key: _titleFormKey,
              child: TextFormField(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '무엇이 필요하신가요?',
                  hintStyle: TextStyle(fontWeight: FontWeight.bold,),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '필수 항목입니다.';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              child: ElevatedButton(
                onPressed: getImage,
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black,
                ),
                style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.black, width: 2.0),
                    padding: EdgeInsets.all(10.0),
                    primary: Colors.white
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              color: Colors.grey[200],
              child: TextField(
                style: TextStyle(
                    fontSize: 16
                ),
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: '심부름을 위한 자세한 내용이 필요해요!\n(시간, 장소, 진행 방식 등)',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
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
}
