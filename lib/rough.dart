// // import 'dart:html';

// import 'dart:io';

// import './Instructions.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:tflite/tflite.dart';
// import 'package:image_picker/image_picker.dart';


// void main()
// {
//   runApp(
//     MaterialApp(
//       title: 'Teachable Machine with Flutter',
//       home: BuildForIndia(),
//     ),
//   );
// }

// class BuildForIndia extends StatefulWidget {
//   @override
//   _BuildForIndiaState createState() => _BuildForIndiaState();
// }

// enum TtsState { playing, stopped }

// class _BuildForIndiaState extends State<BuildForIndia> {

//   FlutterTts flutterTts;

//   TtsState ttsState = TtsState.stopped;

//   get isPlaying => ttsState == TtsState.playing;

//   get isStopped => ttsState == TtsState.stopped;

//   bool _load = false;
//   File _pic;
//   List _result;
//   String _confidence = "";
//   String _pose = "";

//   String numbers = '';

//   @override
//   void dispose() {
//     super.dispose();
//     Tflite.close();
//     flutterTts.stop();
//   }
//   @override
//   void initState() {
//     super.initState();

//     initTTS();

//     _load = true;

//     loadMyModel().then((v){
//       setState(() {
//         _load = false;
//       });
//     });

//   }

//   loadMyModel() async
//   {
//     await Tflite.loadModel(
//       labels: "assets/labels.txt",
//       model: "assets/optimized_model1.tflite"
//     );
//   }

//   initTTS(){
//     flutterTts = FlutterTts();

//     flutterTts.setStartHandler(() {
//       setState(() {
//         print("playing");
//         ttsState = TtsState.playing;
//       });
//     });

//     flutterTts.setCompletionHandler(() {
//       setState(() {
//         print("Complete");
//         ttsState = TtsState.stopped;
//       });
//     });

//     flutterTts.setErrorHandler((msg) {
//       setState(() {
//         print("error: $msg");
//         ttsState = TtsState.stopped;
//       });
//     });


//   }

//   Future _speak(String msg) async{
//     var result = await flutterTts.speak(msg);
//     if (result == 1) setState(() => ttsState = TtsState.playing);
// }

//   chooseImagefromCamera() async
//   {
//     File _img = await ImagePicker.pickImage(source: ImageSource.camera);

//     if(_img == null) return;

//     setState(() {
//       _load = true;
//       _pic = _img;
//       applyModelonImage(_pic);
//     });
//   }

//   chooseImagefromGallery() async
//   {
//     File _img = await ImagePicker.pickImage(source: ImageSource.gallery);

//     if(_img == null) return;

//     setState(() {
//       _load = true;
//       _pic = _img;
//       applyModelonImage(_pic);
//     });
//   }

//   applyModelonImage(File file) async
//   {
//     var _res = await Tflite.runModelOnImage(
//       path: file.path,
//       numResults: 2,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5
//     );

//     setState(() {
//       _load = false;
//       _result = _res;
//       print("\n\nBefore\n");
//       print(_result);
//       print("\n\nAfter\n");
//       String str = _result.isEmpty ? "not Recognised" : _result[0]["label"];
      
//       _pose = str;
//       _confidence = _result.length != 0 ? (_result[0]["confidence"]*100.0).toString().substring(0,2) + "%" : "";

//       // print(str.substring(2));
//       // print((_result[0]["confidence"]*100.0).toString().substring(0,2)+"%");
//       // print("indexed : ${_result[0]["label"]}");
//     });

//     print(_pose[5]);

//     Instruction instruction = Instruction();
//     int posenumber = int.parse(_pose[5]);
//     posenumber = posenumber == 8 ? 1 : posenumber + 1;
//     print(posenumber.runtimeType);
//     // eg: if _pose = "Pose 1.Pranamasana", then posenumber = _pose[5] will be 1.
//     var b = instruction.ins[posenumber.toString()];
//     String msg = '';
//     for (var x in b){
//       msg = msg + x;
//     }
//     _speak(msg);
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Virtual Yoga Instructor"),
//       ),
//       body: Center(
//         child: ListView(
//           children: <Widget>[
//             _load ? Container(alignment: Alignment.center,child: CircularProgressIndicator(),)
//               : Container(
//                 width: size.width*0.9,
//                 height: size.height*0.7,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Center(
//                       child: _pic != null ? Image.file(_pic,width: size.width*0.6,) : Container(),
//                     ),
//                     _result == null ? Container()
//                           : Text("$_pose\nConfidence: $_confidence"),
//                   ],
//                 ),
//               )
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             RaisedButton(
//               child: Text("Gallery"),
//               onPressed: chooseImagefromGallery,
//             ),
            
//             RaisedButton(
//               child: Text("Camera"),
//               onPressed: chooseImagefromCamera,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }