// import 'dart:html';

import 'dart:io';

import 'package:build_for_india/Instructions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './ShowTutorial.dart';

bool _imageChoosen;

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  _imageChoosen = false;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final initialvisit = sharedPreferences.getInt("initialvisit") ?? 0;
  runApp(
    MaterialApp(
      title: 'Build for Digital India',
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
        buttonTheme: ButtonThemeData(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          buttonColor: Colors.orangeAccent,
        )
      ),
      debugShowCheckedModeBanner: false,
      home: initialvisit == 0 ? Tutorial() : BuildforIndia(),
    ),
  );
}

class BuildforIndia extends StatefulWidget {
  @override
  _BuildforIndiaState createState() => _BuildforIndiaState();
}

class _BuildforIndiaState extends State<BuildforIndia> {

  VoiceController controller;
  bool _load = false;
  File _pic;
  List _result;
  String _confidence = "";
  String displayInstructions = "";
  String _pose = "";


  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }
  @override
  void initState() {
    super.initState();

    controller = FlutterTextToSpeech.instance.voiceController();


    _load = true;

    loadMyModel().then((v){
      setState(() {
        _load = false;
      });
    });

  }

  loadMyModel() async
  {
    await Tflite.loadModel(
      labels: "assets/labels.txt",
      model: "assets/virtual_assistant.tflite"
    );
  }

  chooseImagefromCamera() async
  {
    File _img = await ImagePicker.pickImage(source: ImageSource.camera);

    if(_img == null) return;

    setState(() {
      _load = true;
      _pic = _img;
      applyModelonImage(_pic);
    });
  }

  chooseImagefromGallery() async
  {
    File _img = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(_img == null) return;

    setState(() {
      _load = true;
      _pic = _img;
      applyModelonImage(_pic);
    });
  }

  applyModelonImage(File file) async
  {
    var _res = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5
    );

    setState(() {
      _load = false;
      _result = _res;
      print(_result);
      String str = _result.length == 0 ? "" : _result[0]["label"];
      
      _pose = str;
      _confidence = _result.length != 0 ? (_result[0]["confidence"]*100.0).toString().substring(0,2) + "%" : "";

      // print(str.substring(2));
      // print((_result[0]["confidence"]*100.0).toString().substring(0,2)+"%");
      // print("indexed : ${_result[0]["label"]}");
    });

    Instruction instruction = Instruction();

    int posenumber = int.parse(_pose[5]);

    print("\n\nposenumber: $posenumber\n\n");

    displayInstructions = '';

    displayInstructions = displayInstructions + instruction.ins[posenumber.toString()];

    print("\n\nDisplay Instructions:\n$displayInstructions\n\n");


    controller.init().then((_){
      controller.speak(
        displayInstructions, VoiceControllerOptions(delay: 3)
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: ()async{
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setInt("initialvisit", 0);
            },
          ),
        ],
        elevation: 0.0,
        // backgroundColor: Colors.orangeAccent,
        title: Text("Virtual Yoga Assistant"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            _load ? Container(alignment: Alignment.center,child: CircularProgressIndicator(),)
              : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _imageChoosen ? Container(): Container(color:Colors.green, child: Image.asset("assets/hd_logo.jpeg", fit: BoxFit.fill, height: size.height * 0.5, width: size.width * 0.8)),
                    SizedBox(height: 10),
                    _imageChoosen ? Container() : Container(
                      child :Center(
                        child: Text("\nWelcome to Master Yogi..!",
                          style: TextStyle(
                            fontSize: 25.0,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2,2),
                                blurRadius: 4.0,
                                color: Colors.green,
                              ),
                            ]
                          ),  
                        ),
                      )),
                    _imageChoosen ? Container() : Container(child: Text("\nYour Personal Virtual Yoga Assistant.",style: GoogleFonts.pTMono(fontSize: 11.0,fontWeight: FontWeight.w100))),

                    _imageChoosen ? Container() : Center(child: Text("\n\nAn optimized application created for and by yoga enthusiasts that gives a hassle-free experience, by keeping user's needs in mind.",textAlign: TextAlign.justify,style: GoogleFonts.mcLaren(fontSize: 12.0,fontWeight: FontWeight.w100))),

                    Center(
                      child: _pic != null ? Image.file(_pic,width: size.width*0.6,) : Container(),
                    ),
                    SizedBox(height: 10),
                    _result == null ? Container() : Text("\n$displayInstructions")
                    ],
                ),
              )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton.icon(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2))
                ),
                icon: Icon(Icons.photo),
                label: Text("Gallery"),
                onPressed:(){
                  setState(() {
                    _imageChoosen = true;
                  });
                  chooseImagefromGallery();
                },
              ),

              RaisedButton.icon(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2))
                ),
                icon: Icon(Icons.photo_camera),
                label: Text("Camera"),
                onPressed: (){
                  setState(() {
                    _imageChoosen = true;
                  });
                  chooseImagefromCamera();
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}