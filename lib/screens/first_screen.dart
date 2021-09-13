import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  XFile pickedImage;
  bool fill = false;
  bool check = false;
  String text;
  ImagePicker imagepicker = ImagePicker();

  Future pickImage() async {
    var image = await imagepicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = image;
        fill = true;
      });
    }
    return;
  }

  Future readImage() async {
    FirebaseVisionImage image = FirebaseVisionImage.fromFilePath(pickedImage.path);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(image);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
          String texttt = word.text;
          setState(() {
            text = texttt;
            check = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            fill
                ? Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: FileImage(File(pickedImage.path)))),
                  )
                : Container(),
            RaisedButton(
              onPressed: pickImage,
              child: Text('pick image'),
            ),
            RaisedButton(
              onPressed: readImage,
              child: Text('read image'),
            ),
            check ? Container(child: Text(text)) : Container(),
          ],
        ),
      ),
    );
  }
}
