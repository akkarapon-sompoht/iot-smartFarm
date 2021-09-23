import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  final database = FirebaseDatabase.instance;
  DatabaseReference _referenceisSetTimeOut;
  DatabaseReference _referencetimeOut;
  bool _isSetTimeOut = true;

  TabController tb;
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool started = true;
  bool stopped = true;
  int timeForTimer = 0;
  String timertodisplay = "";
  bool checktimer = true;

  @override
  void initState() {
    super.initState();
    tb = TabController(
      length: 2,
      vsync: this,
    );
    _referenceisSetTimeOut =
        database.reference().child('FirebaseIot/isSetTimeOut');
    _referencetimeOut = database.reference().child('FirebaseIot/timeOut');
  }

  void start() {
    _referenceisSetTimeOut
        .set(true)
        .then((value) => print("update is open success"));

    setState(() {
      started = false;
      stopped = false;
    });
    timeForTimer = ((hour * 60 * 60) + (min * 60) + sec);
    _referencetimeOut
        .set(timeForTimer * 1000)
        .then((value) => print("เรียบร้อย"));

    Timer.periodic(
        Duration(
          seconds: 1,
        ), (Timer t) {
      setState(() {
        if (timeForTimer < 1 || checktimer == false) {
          t.cancel();
          checktimer = true;
          timertodisplay = "";
        } else {
          timeForTimer = timeForTimer - 1;
        }
        timertodisplay = timeForTimer.toString();
      });
    });
  }

  void stop() {
    _referenceisSetTimeOut
        .set(false)
        .then((value) => print("update is open success"));

    setState(() {
      started = true;
      stopped = true;
      checktimer = false;
    });
  }

  Widget timer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: Text(
                          "ชั่วโมง",
                          style: GoogleFonts.prompt(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      NumberPicker(
                        value: hour,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (val) {
                          setState(() {
                            hour = val;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: Text(
                          "นาที",
                          style: GoogleFonts.prompt(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.yellow.shade800,
                          ),
                        ),
                      ),
                      NumberPicker(
                        value: min,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (val) {
                          setState(() {
                            min = val;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: Text(
                          "วินาที",
                          style: GoogleFonts.prompt(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      NumberPicker(
                        value: sec,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (val) {
                          setState(() {
                            sec = val;
                          });
                        },
                      ),
                    ],
                  )
                ],
              )),
          Expanded(
            flex: 1,
            child: Text(
              timertodisplay,
              style: GoogleFonts.prompt(
                fontSize: 35,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  onPressed: started || checktimer ? start : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 10.0,
                  ),
                  color: Colors.green,
                  child: Text(
                    "เริ่ม",
                    style: GoogleFonts.prompt(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
                MaterialButton(
                  onPressed: stopped || checktimer ? stop : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 10.0,
                  ),
                  color: Colors.red,
                  child: Text(
                    "หยุด",
                    style: GoogleFonts.prompt(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ตั้งเวลา",
          style: GoogleFonts.prompt(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: timer(),
    );
  }
}
