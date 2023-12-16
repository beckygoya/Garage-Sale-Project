import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:garagesale/src/feature/LogOn.dart';
import 'package:garagesale/src/feature/NewPost.dart';
import 'package:garagesale/src/feature/ItemDetail.dart';
import 'package:garagesale/src/util/Settings.dart';

// Browse posts activity page.
class BrowsePost extends StatefulWidget {
  static String id = 'browse_post_page';
  const BrowsePost({Key? key}) : super(key: key);

  @override
  BrowsePostState createState() => BrowsePostState();
}

class BrowsePostState extends State<BrowsePost> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void choiceAction<String>(String choice) {
    if (choice == Choice.addItem) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewPost()),
      );
    } else if (choice == Choice.signOut) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogOn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: Colors.indigo,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          tooltip: 'Back',
          onPressed: () {
            _auth.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogOn()),
            );
          },
        ),
        title: const Text('Item Listing'),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Choice.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ItemForm(),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add_circle),
        onPressed: () {
          _onAdd(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _onAdd(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPost()),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result successfully')));
  }
}

class Choice {
  static String addItem = 'Add Item';
  static String signOut = 'Sign Out';

  static List<String> choices = <String>[
    addItem,
    signOut,
  ];
}

class ItemForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(firebaseCollection).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final items = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final String user = item['user'];
            final String price = item['price'];
            final String title = item['title'];
            final String description = item['description'];
            final String p0 = item['p0'];
            final String p1 = item['p1'];
            final String p2 = item['p2'];
            final String p3 = item['p3'];

            return Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetail(
                          price: price,
                          user: user,
                          description: description,
                          title: title,
                          p0: p0,
                          p1: p1,
                          p2: p2,
                          p3: p3,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '$title',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '\$$price',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
