import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

import '../aracIsim.dart';

class AracUrunGuncelleme extends StatefulWidget {
  @override
  _AracUrunGuncellemeState createState() => _AracUrunGuncellemeState();
}

class _AracUrunGuncellemeState extends State<AracUrunGuncelleme> {
  var diziUrun = [];
  int sayac2, sayac3;
  String adet = "ADET", fiyat = "FİYAT", gramaj = "GRAMAJ";
  double adetGelen, fiyatGelen, gramajGelen;

  final List<DropdownMenuItem> itemsUrunler = [];
  String secilenUrun = "";
  @override
  void initState() {
    setState(() {
      final db = FirebaseDatabase.instance.reference();

      db
          .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String c = '${snapshot.value}';
        sayac2 = int.parse(c);
        for (var i = 0; i < sayac2; i++) {
          db
              .child(
                  ARACISMI.toString() + "/Urunler/" + i.toString() + "/UrunAdi")
              .once()
              .then((DataSnapshot snapshot) {
            String b = '${snapshot.value}';
            setState(() {
              diziUrun.add(b);
              itemsUrunler.add(DropdownMenuItem(
                child: Text(diziUrun[i]),
                value: diziUrun[i],
              ));
            });
          });
        }
      });
    });

    super.initState();
  }

  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> urunler;
    urunler = {
      "Urun Listesi": SearchableDropdown.single(
        items: itemsUrunler,
        value: secilenUrun,
        hint: "urunler",
        searchHint: "Urun Seçiniz",
        onChanged: (value) {
          setState(() {
            secilenUrun = value;
            _controller.clear();
            _controller1.clear();
            _controller2.clear();
            adetGelen = null;
            fiyatGelen = null;
            gramajGelen = null;

            guncelle();
          });
        },
        isExpanded: true,
      ),
    };

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: urunler
                  .map((k, v) {
                    return (MapEntry(
                        k,
                        Center(
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text("$k:"),
                                      v,
                                    ],
                                  ),
                                )))));
                  })
                  .values
                  .toList(),
            ),
            Text("ÜRÜN ADEDİ"),
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String uAdet) {
                    setState(() {
                      adetGelen = double.parse(uAdet);
                    });
                  },
                  obscureText: false,
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: adet,
                  ),
                )),
            Text("ÜRÜN FİYATI"),
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String ufiyat) {
                    setState(() {
                      fiyatGelen = double.parse(ufiyat);
                    });
                  },
                  obscureText: false,
                  controller: _controller1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: fiyat,
                  ),
                )),
            Text("ÜRÜN GRAMAJI"),
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String ugram) {
                    setState(() {
                      gramajGelen = double.parse(ugram);
                    });
                  },
                  obscureText: false,
                  controller: _controller2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: gramaj,
                  ),
                )),
            new Container(
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color.fromRGBO(169, 131, 7, 1),
                elevation: 2.0,
                splashColor: Colors.black,
                child: Text(
                  "URUN GUNCELLE",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  urunBilgiGuncelle();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future urunBilgiGuncelle() async {
    if (adetGelen == null && fiyatGelen == null && gramajGelen == null) {
      Toast.show("VERİLERDE HİÇ Bİ DEĞİŞİKLİK YAPMADINIZ ", context,
          duration: 5, gravity: Toast.BOTTOM);
    } else {
      if (adetGelen == null) {
        adetGelen = double.parse(adet);
      }
      if (fiyatGelen == null) {
        fiyatGelen = double.parse(fiyat);
      }
      final db = FirebaseDatabase.instance.reference();
      db
          .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String g = '${snapshot.value}';
        sayac2 = int.parse(g);
        for (var i = 0; i < sayac2; i++) {
          db
              .child(
                  ARACISMI.toString() + "/Urunler/" + i.toString() + "/UrunAdi")
              .once()
              .then((DataSnapshot snapshot) {
            String ad = '${snapshot.value}';
            if (secilenUrun == ad) {
              if (gramajGelen == null) {
                db
                    .child(ARACISMI.toString() + "/Urunler/" + i.toString())
                    .update({
                  "UrunAdedi": adetGelen,
                  "UrunFiyati": fiyatGelen,
                  "UrunGramaj": gramaj,
                });
                Toast.show("KAYDINIZ GUNCELLENMİŞTİR ", context,
                    duration: 5, gravity: Toast.BOTTOM);
              } else {
                db
                    .child(ARACISMI.toString() + "/Urunler/" + i.toString())
                    .update({
                  "UrunAdedi": adetGelen,
                  "UrunFiyati": fiyatGelen,
                  "UrunGramaj": gramajGelen,
                });
                Toast.show("KAYDINIZ GUNCELLENMİŞTİR ", context,
                    duration: 5, gravity: Toast.BOTTOM);
              }
            }
          });
        }
      });
    }
  }

  Future guncelle() async {
    final db = FirebaseDatabase.instance.reference();
    db
        .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String c = '${snapshot.value}';
      sayac2 = int.parse(c);
      for (var i = 0; i < sayac2; i++) {
        db
            .child(
                ARACISMI.toString() + "/Urunler/" + i.toString() + "/UrunAdi")
            .once()
            .then((DataSnapshot snapshot) {
          String b = '${snapshot.value}';
          if (secilenUrun == b) {
            db
                .child(ARACISMI.toString() +
                    "/Urunler/" +
                    i.toString() +
                    "/UrunAdedi")
                .once()
                .then((DataSnapshot snapshot) {
              String adt = '${snapshot.value}';
              setState(() {
                adet = adt;
              });
            });
            db
                .child(ARACISMI.toString() +
                    "/Urunler/" +
                    i.toString() +
                    "/UrunFiyati")
                .once()
                .then((DataSnapshot snapshot) {
              String fyt = '${snapshot.value}';
              setState(() {
                fiyat = fyt;
              });
            });
            db
                .child(ARACISMI.toString() +
                    "/Urunler/" +
                    i.toString() +
                    "/UrunGramaj")
                .once()
                .then((DataSnapshot snapshot) {
              String grm = '${snapshot.value}';
              setState(() {
                gramaj = grm;
              });
            });
          }
        });
      }
    });
  }
}
