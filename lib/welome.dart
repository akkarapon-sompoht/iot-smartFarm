import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _referenceHumidity;
  DatabaseReference _referenceIsOpen;
  DatabaseReference _referenceMode;

  // var DatabaseReference _referenceMode = database.reference().child('FirebaseIot/mode');
  bool _isOpen = false;
  bool _isMode = true;

  @override
  void initState() {
    super.initState();
    _referenceHumidity = database.reference().child('FirebaseIot/humidity');
    _referenceIsOpen = database.reference().child('FirebaseIot/isOpen');
    _referenceMode = database.reference().child('FirebaseIot/mode');
    _referenceMode.once().then((snapshot) {
      setState(() {
        _isMode = snapshot.value;
      });
    });
    _referenceIsOpen.once().then((snapshot) {
      setState(() {
        _isOpen = snapshot.value;
      });
    });
  }

  pump(bool value) {
    setState(() {
      _isOpen = value;
    });
    _referenceIsOpen
        .set(value)
        .then((value) => print("update is open success"));
  }

  void onChangedCheckbox(bool value) {
    setState(() {
      _isMode = !_isMode;
    });
    _referenceMode.set(_isMode).then((value) => print("update mode success"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: StreamBuilder<Event>(
            stream: _referenceHumidity.onValue,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              } else {
                int data = snapshot.data.snapshot.value as int;
                return new Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: new EdgeInsets.only(top: 80.0),
                        child: Text(
                          "ระบบรดน้ำอัตโนมัติ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.prompt(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.0,
                      ),
                      Container(
                        child: Text(
                          _isOpen ? 'หยุดทำงานแล้ว..' : 'กำลังทำงานอยู่!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.prompt(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 0),
                      SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                              minimum: 0,
                              maximum: 1000,
                              interval: 50,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                    startValue: 0,
                                    endValue: 250,
                                    color: Colors.yellow[500]),
                                GaugeRange(
                                    startValue: 250,
                                    endValue: 500,
                                    color: Colors.green),
                                GaugeRange(
                                    startValue: 500,
                                    endValue: 750,
                                    color: Colors.blue[700]),
                                GaugeRange(
                                    startValue: 750,
                                    endValue: 1000,
                                    color: Colors.purple),
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                    value: data.toDouble(),
                                    enableAnimation: true,
                                    animationType: AnimationType.easeOutBack)
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: Text("$data",
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold)),
                                    positionFactor: 0.700,
                                    angle: 90)
                              ])
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Mode",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.archivo(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isMode,
                            onChanged: (bool value) {
                              onChangedCheckbox(value);
                            },
                          ),
                          Text(
                            'manual',
                            style: GoogleFonts.archivo(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Checkbox(
                            value: !_isMode,
                            onChanged: (bool value) {
                              onChangedCheckbox(value);
                            },
                          ),
                          Text(
                            'auto',
                            style: GoogleFonts.archivo(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      if (_isMode)
                        Column(
                          children: [
                            MaterialButton(
                              height: 60,
                              minWidth: 150,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(12)),
                              onPressed: () => pump(false),
                              child: Text(
                                "Pump on",
                                style: GoogleFonts.roboto(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.green[600],
                            ),
                            SizedBox(height: 10.0),
                            MaterialButton(
                              height: 60,
                              minWidth: 150,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(12)),
                              onPressed: () => pump(true),
                              child: Text(
                                "Pump off",
                                style: GoogleFonts.roboto(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.redAccent[700],
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              }
            },
          ),
        ));
  }
}
