import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final CollectionReference errands = FirebaseFirestore.instance
  .collection('errands');
  var user = FirebaseAuth.instance.currentUser;

  List<String> _valueList = ['첫 번째', '두 번째', '세 번째'];
  var _selectedValue = '첫 번째';

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

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
              Map <String, dynamic> data = {
                'name':_nameController.text,
              };
              // await products.add({'name': _nameController.text});
              // await products.add(data);
              await errands.doc(user!.uid).set(data);
              await Navigator.popAndPushNamed(context, '/home');
              //addProduct(_nameController.text, _priceController.text,
              // _descriptionController.text, imageUrl);
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Text('카테고리'),
          DropdownButton(
            value: _selectedValue,
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
                _selectedValue= value.toString();
              });
            },
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Errand Name',
              hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              hintText: 'Price',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
          ),
        ],
      ),
    );
  }
}
