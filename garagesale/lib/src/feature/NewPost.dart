import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:garagesale/src/feature/BrowsePost.dart';
import 'package:garagesale/src/feature/Camera.dart';
import 'package:garagesale/src/util/MyItem.dart';
import 'package:garagesale/src/util/Settings.dart';

/// New item post page.
class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);
  static const String id = 'new_post_page';

  @override
  NewPostState createState() => NewPostState();
}

class NewPostState extends State<NewPost> {
  Item current = Item();
  final _auth = FirebaseAuth.instance;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  FirebaseFirestore fireStorage = FirebaseFirestore.instance;
  User? loggedOnUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedOnUser = user;
        print(loggedOnUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HyperGarageSale'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: MyItem(
                  label: "Name of the item",
                  controller: titleController,
                ),
              ),
              const SizedBox(height:20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: MyItem(
                  label: "Price of the item",
                  controller: priceController,
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: MyItem(
                  label: "Description of the item",
                  controller: descriptionController,
                ),
              ),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 2.0, 1.0, 2.0),
                      child: current.pictures.isEmpty
                          ? null
                          : Image.file(
                        File(current.pictures[0]),
                        height: 100,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 2.0, 1.0, 2.0),
                      child: current.pictures.length <= 1
                          ? null
                          : Image.file(
                        File(current.pictures[1]),
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 2.0, 1.0, 2.0),
                      child: current.pictures.length <= 2
                          ? null
                          : Image.file(
                        File(current.pictures[2]),
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 2.0, 1.0, 2.0),
                      child: current.pictures.length <= 3
                          ? null
                          : Image.file(
                        File(current.pictures[3]),
                        height: 80,
                      ),
                    ),
                  ],
                ),
              ),
            ])),
      ),
      // add photo to the current post
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_a_photo),
          onPressed: () async {
            if (current.pictures.length > 3) {
              print("Each item can only have at most 4 pictures.");
            } else {
              final cameras = await availableCameras();
              final camera = cameras.first;
              if (cameras.isEmpty) {
                print('No Camera');
              }
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Camera(camera: camera),
                ),
              );
              print(result);
              setState(() {
                current.pictures.add(result);
              });
            }
          }),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(children: <Widget>[
          const SizedBox(width: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              descriptionController.clear();
              priceController.clear();
              titleController.clear();
              Navigator.pop(context, 'Cancel');
            },
            child: Text('Back',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 200),

          /// Post button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              try {
                current.price = priceController.text;
                current.title = titleController.text;
                current.description = descriptionController.text;
                // uploadCurrentPost();
                var timeKey = DateTime.now();
                FirebaseStorage storage = FirebaseStorage.instance;

                for (String imagePath in current.pictures) {
                  print(imagePath);
                  try {
                    // Generate image location with timestamp.
                    String imageLocation =
                        'garage_sale_images/image${timeKey.toString()}.jpg';
                    final Reference imageRef = storage.ref().child(imageLocation);
                    final UploadTask uploadTask = imageRef.putFile(File(imagePath));
                    await uploadTask.whenComplete(() => null);
                    final ref = FirebaseStorage.instance.ref().child(imageLocation);
                    var url = await ref.getDownloadURL();
                    current.urls.add(url);
                  } catch (e) {
                    print(e);
                  }
                  print("Image url = $current.url");
                }
                current.p0 = current.urls.isEmpty ? ' ' : current.urls[0];
                current.p1 = current.urls.length < 2 ? ' ' : current.urls[1];
                current.p2 = current.urls.length < 3 ? ' ' : current.urls[2];
                current.p3 = current.urls.length < 4 ? ' ' : current.urls[3];
                await fireStorage.collection(firebaseCollection).add({
                  'user': loggedOnUser?.email,
                  'title': current.title,
                  'price': current.price,
                  'description': current.description,
                  'p0': current.p0,
                  'p1': current.p1,
                  'p2': current.p2,
                  'p3': current.p3,
                }).whenComplete(() => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BrowsePost(),
                    )
                  )
                });
              } catch (e) {
                print(e);
              }
            },
            child: Text('Post',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}