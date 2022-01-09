import 'package:beypetek/aracIsim.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class IlkGiris extends StatefulWidget {
  @override
  _IlkGirisState createState() => _IlkGirisState();
}

class _IlkGirisState extends State<IlkGiris> {
  @override
  Widget build(BuildContext context) {
    print(ARACISMI);
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
                    "ARAÇ STOK",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/AracStok");
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
                    "SATIŞ ",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/satis");
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
                    "MÜŞTERİ CARİ BİLGİSİ",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/musteriCari");
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
                    "MÜŞTERİ EKLE",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/musteriAnaSayfa");
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
                    "GÜN SONU ",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/gunSonu");
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
                    "ARACI TEMİZLE ",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _showMyDialog();
                    //Navigator.pushNamed(context, "/gunSonu");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("KONTROL"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Araç ismi ( " +
                    ARACISMI +
                    " ) olan arabanın içini boşaltmak istediğine emin misin "),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('GERİ GEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('TEMİZLE'),
              onPressed: () {
                final db = FirebaseDatabase.instance.reference();
                db.child(ARACISMI.toString() + "/Urunler").remove();
                db.child(ARACISMI.toString() + "/UrunSayac/Usayac").update({
                  "sayac": 0,
                });
                Toast.show("ARACINIZ BOŞALTILMIŞTIR", context,
                    duration: 3, gravity: Toast.BOTTOM);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
