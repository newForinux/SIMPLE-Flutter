import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final CollectionReference errands = FirebaseFirestore.instance.collection('errands');
  var user = FirebaseAuth.instance.currentUser;

  List<String> _valueList = [
    '기타', '편의점', '커피&디저트', '중고거래대행', '약국', '택배&우편물',
    '세탁소&구두', '상품교환', '짐옮기기',
  ];
  var _selectedCategory = '기타';

  final _titleController = TextEditingController();
  final _titleFormkey = GlobalKey<FormState>();
  final _rewardController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> addCard() {
    return errands.doc(user!.uid).set({
      'category':_selectedCategory,
      'title': _titleController.text,
      'description':_descriptionController.text,
      'reward': (_rewardController.text.isEmpty)? 0 : int.tryParse(_rewardController.text),
      'userId': user!.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'ongoing': false,
      'done': false,
    })
        .then((value) => print("Added"))
        .catchError((error) => print("Failed to Add: $error"));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        title: Text('Add'),
        actions: [
          TextButton(
            child: Text('SAVE'),
            onPressed: () async {
              if (_titleFormkey.currentState!.validate()) {
                await addCard();
                Navigator.pushNamed(context, '/home');
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
            Text('카테고리', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            SizedBox(height:8),
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
}
