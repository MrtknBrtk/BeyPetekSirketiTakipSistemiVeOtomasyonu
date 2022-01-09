import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

/* budaz musteri adları listelenecek sıonra aşağıdan düzenleme yapılarak kaydedilecek. */
class MusteriDuzenle extends StatefulWidget {
  @override
  _MusteriDuzenleState createState() => _MusteriDuzenleState();
}

class _MusteriDuzenleState extends State<MusteriDuzenle> {
  var musteriadiliste = [];
  int sayac2, sayac3;
  String sehiir = "ŞEHİR",
      adres = "ADRES",
      dukAdi = "DUKKAN ADI",
      telNo = "TELEFON NUMARASI",
      vergiNo = "VERGİ NUMARASI";
  String sehirGelen = "",
      adresGelen = "",
      dukkanadiGelen = "",
      telGelen = "",
      vergiGelen = "";

  final List<DropdownMenuItem> musteriIsim = [];
  String secilenmusteri = "";
  @override
  void initState() {
    setState(() {
      final db = FirebaseDatabase.instance.reference();

      db
          .child("MusteriSayac/Msayac/sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String c = '${snapshot.value}';
        sayac2 = int.parse(c);
        for (var i = 0; i < sayac2; i++) {
          db
              .child("Musteriler/" + i.toString() + "/MusteriAdi")
              .once()
              .then((DataSnapshot snapshot) {
            String b = '${snapshot.value}';
            setState(() {
              musteriadiliste.add(b);

              musteriIsim.add(DropdownMenuItem(
                child: Text(musteriadiliste[i]),
                value: musteriadiliste[i],
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
  final TextEditingController _controller3 = new TextEditingController();
  final TextEditingController _controller4 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> urunler;
    urunler = {
      "Musteri Listesi": SearchableDropdown.single(
        items: musteriIsim,
        value: secilenmusteri,
        hint: "Müsteriler",
        searchHint: "Müsteri Seçiniz",
        onChanged: (value) {
          setState(() {
            secilenmusteri = value;
            _controller.clear();
            _controller1.clear();
            _controller2.clear();

            _controller3.clear();
            _controller4.clear();
            sehirGelen = "";
            adresGelen = "";
            dukkanadiGelen = "";
            telGelen = "";
            vergiGelen = "";
            bilgiGetir();
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
            Text("ŞEHİR"),
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String shr) {
                    setState(() {
                      sehirGelen = shr;
                    });
                  },
                  obscureText: false,
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: sehiir,
                  ),
                )),
            Text("ADRES"),
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String adr) {
                    setState(() {
                      adresGelen = adr;
                    });
                  },
                  obscureText: false,
                  controller: _controller1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: adres,
                  ),
                )),
            Text("DüKKAN ADİ"),
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String dknadi) {
                    setState(() {
                      dukkanadiGelen = dknadi;
                    });
                  },
                  obscureText: false,
                  controller: _controller2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: dukAdi,
                  ),
                )),
            Text("TELEFON NUMARASI"),
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String tl) {
                    setState(() {
                      telGelen = tl;
                    });
                  },
                  obscureText: false,
                  controller: _controller3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: telNo,
                  ),
                )),
            Text("VERGİ NUMARASI"),
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String vrg) {
                    setState(() {
                      vergiGelen = vrg;
                    });
                  },
                  obscureText: false,
                  controller: _controller4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: vergiNo,
                  ),
                )),

            //guncellme butonu
            new Container(
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color.fromRGBO(169, 131, 7, 1),
                elevation: 2.0,
                splashColor: Colors.black,
                child: Text(
                  "MUSTERİ BİLGİSi GÜNCELLE",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  guncelle();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future bilgiGetir() async {
    final db = FirebaseDatabase.instance.reference();
    db.child("MusteriSayac/Msayac/sayac").once().then((DataSnapshot snapshot) {
      String c = '${snapshot.value}';
      sayac3 = int.parse(c);
      for (var i = 0; i < sayac3; i++) {
        db
            .child("Musteriler/" + i.toString() + "/MusteriAdi")
            .once()
            .then((DataSnapshot snapshot) {
          String b = '${snapshot.value}';
          if (secilenmusteri == b) {
            db
                .child("Musteriler/" + i.toString() + "/Il")
                .once()
                .then((DataSnapshot snapshot) {
              String il = '${snapshot.value}';
              setState(() {
                sehiir = il;
              });
            });
            db
                .child("Musteriler/" + i.toString() + "/Adres")
                .once()
                .then((DataSnapshot snapshot) {
              String adr = '${snapshot.value}';
              setState(() {
                adres = adr;
              });
            });
            db
                .child("Musteriler/" + i.toString() + "/DukkanAdi")
                .once()
                .then((DataSnapshot snapshot) {
              String dadi = '${snapshot.value}';
              setState(() {
                dukAdi = dadi;
              });
            });
            db
                .child("Musteriler/" + i.toString() + "/TelNo")
                .once()
                .then((DataSnapshot snapshot) {
              String tlno = '${snapshot.value}';
              setState(() {
                telNo = tlno;
              });
            });
            db
                .child("Musteriler/" + i.toString() + "/VergiNo")
                .once()
                .then((DataSnapshot snapshot) {
              String vrgno = '${snapshot.value}';
              setState(() {
                vergiNo = vrgno;
              });
            });
          }
        });
      }
    });
  }

  Future guncelle() async {
    final db = FirebaseDatabase.instance.reference();
    if (sehirGelen == "" &&
        adresGelen == "" &&
        dukkanadiGelen == "" &&
        telGelen == "" &&
        vergiGelen == "") {
      Toast.show("VERİLERDE HİÇ Bİ DEĞİŞİKLİK YAPMADINIZ ", context,
          duration: 5, gravity: Toast.BOTTOM);
    } else {
      if (sehirGelen == "") {
        sehirGelen = sehiir;
      }
      if (adresGelen == "") {
        adresGelen = adres;
      }
      if (dukkanadiGelen == "") {
        dukkanadiGelen = dukAdi;
      }
      if (telGelen == "") {
        telGelen = telNo;
      }
      if (vergiGelen == "") {
        vergiGelen = vergiNo;
      }

      for (var x = 0; x < sayac2; x++) {
        db
            .child("Musteriler/" + x.toString() + "/MusteriAdi")
            .once()
            .then((DataSnapshot snapshot) {
          String b = '${snapshot.value}';

          if (secilenmusteri == b) {
            db.child("Musteriler/" + x.toString()).update({
              "Adres": adresGelen,
              "DukkanAdi": dukkanadiGelen,
              "Il": sehirGelen,
              "TelNo": telGelen,
              "VergiNo": vergiGelen,
            });
            Toast.show("İŞLEMİNİZ YAPILMIŞTIR .. ", context,
                duration: 5, gravity: Toast.BOTTOM);
          }
        });
      }
    }
  }
}
