import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:garagesale/src/feature/Camera.dart';

/// Preview pictures just taken for the item post.
class PreviewPicture extends StatelessWidget {
  static String id = "preview_picture_page";
  final String imagePath;

  const PreviewPicture({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.file(File(imagePath)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Retake'),
                onPressed: () async {
                  final cameras = await availableCameras();
                  final camera = cameras.first;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Camera(camera: camera),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.pop(context, imagePath);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
