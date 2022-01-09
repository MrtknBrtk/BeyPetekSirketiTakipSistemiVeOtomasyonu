import 'package:beypetek/aracIsim.dart';
import 'package:flutter/material.dart';

class AracSec extends StatefulWidget {
  @override
  _AracSecState createState() => _AracSecState();
}

class _AracSecState extends State<AracSec> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(169, 131, 7, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 60,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.black,
                  elevation: 2.0,
                  splashColor: Colors.white,
                  child: Text(
                    "120",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      ARACISMI = "ARAC1";
                    });

                    Navigator.pushNamed(context, "/IlkGiris");
                  },
                ),
                margin: EdgeInsets.only(bottom: 20),
              ),
              Container(
                width: 200,
                height: 60,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.black,
                  elevation: 2.0,
                  splashColor: Colors.white,
                  child: Text(
                    "ARAÇ 2 ",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      ARACISMI = "ARAC2";
                    });
                    Navigator.pushNamed(context, "/IlkGiris");
                  },
                ),
                margin: EdgeInsets.only(bottom: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
