import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/setting.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:numberpicker/numberpicker.dart';

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
  DatabaseReference _referenceSethumidityMin;
  DatabaseReference _referenceSethumidityMax;

  // var DatabaseReference _referenceMode = database.reference().child('FirebaseIot/mode');
  bool _isOpen = true;
  bool _isMode = true;
  var lavel0 = "0%-39% = พืชขาดน้ำ";
  var lavel1 = "40%-49% =  ดินแห้ง";
  var lavel2 = "50%-69% = พืชเจริญเติบโต";
  var lavel3 = "70%-79% = ดินแฉะ";
  var lavel4 = "80%-100% = ระดับอันตราย";
  List listItem = [
    "0%-39% = พืชขาดน้ำ",
    "40%-49% =  ดินแห้ง",
    "50%-69% = พืชเจริญเติบโต",
    "70%-79% = ดินแฉะ",
    "80%-100% = ระดับอันตราย",
  ];

  void humidityFirebase(String value) {
    var huMax = 0;
    var huMin = 0;

    if (value == lavel4) {
      huMax = 300;
      huMin = 0;
    }

    if (value == lavel3) {
      huMax = 600;
      huMin = 300;
    }

    if (value == lavel2) {
      huMax = 800;
      huMin = 600;
    }

    if (value == lavel1) {
      huMax = 900;
      huMin = 800;
    }

    if (value == lavel0) {
      huMax = 1024;
      huMin = 1000;
    }
    _referenceSethumidityMin =
        database.reference().child('FirebaseIot/autoMode/huMin');
    _referenceSethumidityMin
        .set(huMin)
        .then((value) => print("update is autoMode huMin"));

    _referenceSethumidityMax =
        database.reference().child('FirebaseIot/autoMode/huMax');
    _referenceSethumidityMax
        .set(huMax)
        .then((value) => print("update is autoMode huMax"));
  }

  var ValueChoose;

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
  Widget humidity() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 1.6),
          decoration: BoxDecoration(
            color: Colors.white,
              border: Border.all(color: Colors.green, width: 3),
              borderRadius: BorderRadius.circular(15)),
          child: DropdownButton(
            hint: Text(
              "เลือกความชื้นที่ต้องการ",
              style: GoogleFonts.prompt(),
            ),
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 36,
            underline: SizedBox(),
            style: TextStyle(color: Colors.black, fontSize: 22),
            value: ValueChoose,
            onChanged: (newValue) {
              print(newValue);
              String value = newValue as String;
              humidityFirebase(value);
              setState(() {
                ValueChoose = newValue;
              });
            },
            items: listItem.map((valueItem) {
              return DropdownMenuItem(
                value: valueItem,
                child: Text(valueItem),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

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
                            color: Colors.greenAccent.shade700,
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
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
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
                        height: 0.0,
                      ),
                      Text(
                        "Mode",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.archivo(
                          fontSize: 28,
                          color: Colors.orangeAccent.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 0,
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
                              fontSize: 22,
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
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      if (_isMode) ...{
                        Column(children: [
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
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.settings),
                              label: Text(
                                "setting",
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SettingPage();
                                }));
                              },
                            ),
                          )
                        ]),
                      } else ...{
                        humidity(),
                      }
                    ],
                  ),
                );
              }
            },
          ),
        ));
  }
}
