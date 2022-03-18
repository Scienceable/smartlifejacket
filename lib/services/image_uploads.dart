import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:science_club/shared/variables.dart';

class ImageUploads extends StatefulWidget {
  ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  bool? uploaded = false;
  double? _progress = 0.0;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        setState(() {
          errorFromFirebase = 'No image is selected';
        });
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        setState(() {
          errorFromFirebase = 'No image is selected';
        });
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'photos/$fileName';

    try {
      Reference ref = FirebaseStorage.instance.ref().child(destination);
      UploadTask uploadTask = ref.putFile(_photo!);
      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        });
        if (event.state == TaskState.success) {
          _progress = null;
        }
      }).onError((error) {
        setState(() {
          errorFromFirebase = error.toString();
        });
      });
      uploadTask.then((snap) async {
        newimageURL.value = await snap.ref.getDownloadURL();
      });
      setState(() {
        errorFromFirebase = '';
      });
    } catch (e) {
      setState(() {
        errorFromFirebase = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          _photo != null
              ? Image.file(
                  _photo!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitHeight,
                )
              : Container(),
          const SizedBox(
            height: 32,
          ),
          if (_progress != 0.0)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 2.0,
                color: Colors.red,
              ),
            ),
          const SizedBox(
            height: 32,
          ),
          RaisedButton(
              color: Colors.pink[400],
              child: const Text(
                'Finish',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_photo == null) {
                  setState(() {
                    errorFromFirebase = 'No image is selected';
                  });
                } else if (_progress != null) {
                  setState(() {
                    errorFromFirebase = 'Processing is unfinished';
                  });
                } else {
                  setState(() {
                    errorFromFirebase = '';
                  });
                  Navigator.of(context).pop();
                }
              }),
          const SizedBox(
            height: 10,
          ),
          errorFromFirebase != ''
              ? Text(
                  errorFromFirebase,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                )
              : Container(),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
