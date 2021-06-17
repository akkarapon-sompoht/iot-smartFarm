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
  // var DatabaseReference _referenceIsOpen = database.reference().child('FirebaseIot/isOpen');
  // var DatabaseReference _referenceMode = database.reference().child('FirebaseIot/mode');
  bool _isOpen = true;
  @override
  void initState() { 
    super.initState();
    // database.child('FirebaseIot/mode').get()
  }
   

  pump(bool value) {
    database
        .reference()
        .child('/test')
        .set(value)
        .then((value) => print('ok'))
        .catchError((error) => print(error));
  }

  void onChangedCheckbox() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: new Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              padding: new EdgeInsets.only(top: 100.0),
              child: Text(
                "Automatic Water System",
                style: GoogleFonts.arimo(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20.0),
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
                          startValue: 250, endValue: 500, color: Colors.green),
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
                      NeedlePointer(value: 700, enableAnimation: true)
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Text("700.0",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          positionFactor: 0.5,
                          angle: 90)
                    ])
              ],
            ),
            Text("Mode"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isOpen,
                  onChanged: (bool value) {
                    onChangedCheckbox();
                  },
                ),
                Text('manual'),
                Checkbox(
                  value: !_isOpen,
                  onChanged: (bool value) {
                    onChangedCheckbox();
                  },
                ),
                Text('auto'),
              ],
            ),
            SizedBox(height: 10.0),
            if (_isOpen) 
            Column(
              children: [MaterialButton(
              height: 60,
              minWidth: 150,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(12)),
              onPressed: () => pump(true),
              child: Text(
                "Pump on",
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              color: Colors.green,
            ),
            SizedBox(height: 10.0),
            MaterialButton(
              height: 60,
              minWidth: 150,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(12)),
              onPressed: () => pump(false),
              child: Text(
                "Pump off",
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              color: Colors.red,
            ),
            ],
            ),
          ],
        ),
      ),
    );
  }
}
