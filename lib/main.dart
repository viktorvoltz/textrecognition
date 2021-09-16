import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  XFile pickedImage;
  bool fill = false;
  bool check = false;
  String text;
  List<String> textBlock = [];
  ImagePicker imagepicker = ImagePicker();
  final messangerKey = GlobalKey<ScaffoldMessengerState>();

  Future pickImage() async {
    var image = await imagepicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = image;
        fill = true;
        textBlock.clear();
      });
    }
    return;
  }

  Future readImage() async {
    FirebaseVisionImage image =
        FirebaseVisionImage.fromFilePath(pickedImage.path);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(image);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
          textBlock.add(word.text);
          setState(() {
            check = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple, accentColor: Colors.deepPurple),
      title: 'Text Recognition',
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: messangerKey,
          appBar: AppBar(
            title: Text('Text recognition'),
            backwardsCompatibility: false,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.deepPurple),
            bottom: const TabBar(
              tabs: [Tab(text: 'Image text'), Tab(text: 'Console')],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    fill
                        ? Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                  File(pickedImage.path),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: pickImage,
                          child: Text('pick image'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: readImage,
                          child: Text('read image'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              check
                  ? Container(
                      color: Colors.black,
                      child: SingleChildScrollView(
                        child: GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(
                                ClipboardData(text: textBlock.join(" ")));
                              messangerKey.currentState.showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Text copied to clipboard',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                          },
                          child: Container(
                            color: Colors.black,
                            child: Text(
                              textBlock.join(" "),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
