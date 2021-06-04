import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var user = FirebaseAuth.instance.currentUser;
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;

    if (args.compareTo("카페/디저트") == 0)
      args = "카페";
    else if (args.compareTo("세탁/클리닝") == 0)
      args = "세탁";

    CollectionReference errands = FirebaseFirestore.instance
        .collection(args);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          )
        ),
        title: Text(
          args + " 리스트",
          style: TextStyle(
            fontFamily: "Vitro Pride",
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/add', arguments: args);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: errands.where('category', isEqualTo: args).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;

                // print("document length is " + documents.length.toString());
                return ListView.builder(
                  itemCount: 1,
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, _) {
                    return Column(
                      children: _buildListCards(context, documents),
                    );
                  },
                  //children: _buildListCards(context, documents),
                );
              },
            ),
          ),
          FloatingActionButton(
            child: Icon(
              Icons.exit_to_app,
            ),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }

  List<Card> _buildListCards(BuildContext context, List<DocumentSnapshot> documents) {
    return documents
        .map((docs) => Card (
      elevation: 20,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: docs);
        },
        child: Container(
          height: 200,
          child: Padding(
            padding: EdgeInsets.all(5),

            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(docs['title']),
                        SizedBox(height:8),
                        Text(docs['reward'].toString() + '원'),
                        SizedBox(height:32),
                        Text(docs['timestamp'].toDate().toString(),
                          style: TextStyle(color: Colors.grey),),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(docs['category'], style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )).toList();
  }
}
