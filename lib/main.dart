// import 'dart:html';

import 'dart:io';

import 'package:build_for_india/Instructions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';


void main()
{
  runApp(
    MaterialApp(
      title: 'Build for Digital India',
      showSemanticsDebugger: false,
      home: BuildforIndia(),
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

    // posenumber = posenumber == 8 ? 1 : posenumber + 1;
    // var b = instruction.ins[posenumber.toString()];
    // String msg = '';
    // displayInstructions = '';
    // for (var x in b){
    //   msg = msg + x + '\n';
    //   // displayInstructions = displayInstructions + x + '\n\n';
    // }

    // displayInstructions = displayInstructions.substring(0,displayInstructions.length-2);

    // displayInstructions = displayInstructions + msg;

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
        title: Text("Virtual Yoga Assistant"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            _load ? Container(alignment: Alignment.center,child: CircularProgressIndicator(),)
              : Container(
                width: size.width*0.9,
                height: size.height*0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: _pic != null ? Image.file(_pic,width: size.width*0.6,) : Container(),
                    ),
                    SizedBox(height: 10),
                    _result == null ? Container()
                          : Container(
                            // color: Colors.green,
                            height:MediaQuery.of(context).size.height * 0.3,
                          // child: ListView(children:<Widget>[ Center(child: Text("$_pose\n\nConfidence: $_confidence\n\n$displayInstructions"))])),
                          child: ListView(children:<Widget>[ Center(child: Text("\n$displayInstructions"))])),
                  ],
                ),
              )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text("Gallery"),
              onPressed: chooseImagefromGallery,
            ),

            RaisedButton(
              child: Text("Camera"),
              onPressed: chooseImagefromCamera,
            ),
          ],
        ),
      ),
    );
  }
}