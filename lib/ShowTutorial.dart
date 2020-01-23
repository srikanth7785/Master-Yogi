import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  List<TargetFocus> targets = List();

  GlobalKey keyButton1 = GlobalKey();
  // GlobalKey welcomekey = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();

  @override
  void initState() {
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Virtual Yoga Assistant"),centerTitle: true,),
      body: ListView(
        children: <Widget>[

          RaisedButton(
            child: Text("Start Tour"),
            onPressed: (){
              showTutorial();
            },
          ),
          
          Align(key:keyButton1, alignment: Alignment.topCenter,child: Image.asset("assets/hd_logo.jpeg", fit: BoxFit.fill, height: size.height * 0.5, width: size.width * 0.8)),
          // SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0 ),
            child: Container(
            child :Center(
              key: keyButton2,
              child: Text("\nWelcome to our Master Yogi..!",
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
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0 ),
            child: Container(
            key: keyButton3,
            child :Column(
              children: <Widget>[
                Center(child: Text("\nYour Personal Virtual Yoga Assistant.",style: GoogleFonts.pTMono(fontSize: 11.0,fontWeight: FontWeight.w100),)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("\nAn optimized application created for and by yoga enthusiasts that gives a hassle-free experience, by keeping user's needs in mind.",textAlign: TextAlign.justify,style: GoogleFonts.mcLaren(fontSize: 12.0,fontWeight: FontWeight.w100),)),
                ),
              ],
            ))),
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton.icon(
                key: keyButton4,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2))
                ),
                icon: Icon(Icons.photo),
                label: Text("Gallery"),
                onPressed:(){}
              ),

              RaisedButton.icon(
                key: keyButton5,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2))
                ),
                icon: Icon(Icons.photo_camera),
                label: Text("Camera"),
                onPressed: (){}
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initTargets() {
    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: keyButton1,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hello There..!👋",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "It's Great you took the initiative",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              // child: Text("Hello There..!👋"),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 2",
      keyTarget: keyButton2,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "We are Glad that you made it here..!\n🤩",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                ],
              ),
            )),
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: keyButton3,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Make use of our app to make yourself better",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 4",
      keyTarget: keyButton4,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Choose an Image from Gallery",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(TargetFocus(
      identify: "Target 5",
      keyTarget: keyButton5,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Choose an Image from Camera",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            )),
        ContentTarget(
            align: AlignContent.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Multiples contents",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Container(
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ))
      ],
      shape: ShapeLightFocus.Circle,
    ));
  }

  void showTutorial() {
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8, 
        finish: () async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setInt("initialvisit", 1);
      print("finish");
    }, clickTarget: (target) {
      print(target);
    }, clickSkip: () async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt("initialvisit", 1);
      print("skip");
    })
      ..show();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }
}