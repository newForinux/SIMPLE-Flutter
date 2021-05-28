import 'package:flutter/material.dart';

class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('심플'),
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 3,
          padding: EdgeInsets.all(8),
          // childAspectRatio: 2/3,
          children: [
            IconButton(
              icon: Icon(Icons.local_convenience_store),
              onPressed: () {
                // navigate to home with certain (value) to build list card view with switch(value)
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
