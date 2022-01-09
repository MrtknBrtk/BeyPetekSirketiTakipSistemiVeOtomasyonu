import 'package:beypetek/aracIsim.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class AracEkleme extends StatefulWidget {
  @override
  _AracEklemeState createState() => _AracEklemeState();
}

final TextEditingController _controller = new TextEditingController();
final TextEditingController _controller1 = new TextEditingController();
final TextEditingController _controller2 = new TextEditingController();

final TextEditingController _controller3 = new TextEditingController();

class _AracEklemeState extends State<AracEkleme> {
  // ignore: avoid_init_to_null
  String urun = null, adet = null, fiyat = null, gram = null, ksn;
  int sayac;
  List<String> k = [];

  @override
  void initState() {
    setState(() {
      listeal();
    });
    super.initState();
  }

  void listeal() async {
    final db = FirebaseDatabase.instance.reference();
    db
        .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      sayac = int.parse(a);
      print(sayac);
      for (var i = 0; i < sayac; i++) {
        db
            .child(
                ARACISMI.toString() + "/Urunler/" + i.toString() + "/UrunAdi")
            .once()
            .then((DataSnapshot snapshot) {
          setState(() {
            var a = '${snapshot.value}';
            k.add(a);
          });
        });
      }
    });
  }

  urunIsmi(urunAdi) {
    setState(() {
      this.urun = urunAdi;
    });
  }

  urunAdet(uAdet) {
    setState(() {
      this.adet = uAdet;
    });
  }

  urunFiyat(uFiyat) {
    setState(() {
      this.fiyat = uFiyat;
    });
  }

  urunGram(uGram) {
    setState(() {
      this.gram = uGram;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(k);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //ürün adi
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  onChanged: (String urunAdi) {
                    setState(() {
                      urunIsmi(urunAdi);
                    });
                  },
                  obscureText: false,
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ÜRÜN ADI',
                  ),
                )),
            //Adet
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String uAdet) {
                    setState(() {
                      urunAdet(uAdet);
                    });
                  },
                  obscureText: false,
                  controller: _controller1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ADET',
                  ),
                )),
            //Fiyat
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String uFiyat) {
                    setState(() {
                      urunFiyat(uFiyat);
                    });
                  },
                  obscureText: false,
                  controller: _controller2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'FİYAT',
                  ),
                )),
            //Gram
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String uGram) {
                    setState(() {
                      urunGram(uGram);
                    });
                  },
                  obscureText: false,
                  controller: _controller3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'GRAMAJ',
                  ),
                )),
            //ekleme buttonu
            new Container(
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color.fromRGBO(169, 131, 7, 1),
                elevation: 2.0,
                splashColor: Colors.black,
                child: Text(
                  "ÜRÜNÜ EKLE",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  urunyerlestir();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future urunyerlestir() async {
    if (urun == "" || urun == null || fiyat == null || fiyat == "") {
      Toast.show("LÜTFEN BİLGİLERİ DOĞRU TAMAMLAYINIZ ", context,
          duration: 3, gravity: Toast.BOTTOM);
    } else {
      if (adet == null && gram == null) {
        Toast.show(
            "ADET YADA GRAMAJDAN BİRİNİ GİRMENİZ GEREKMEKTEDİR ", context,
            duration: 5, gravity: Toast.BOTTOM);
      } else {
        if (gram == null || gram == "") {
          print("ilk if");
          final db = FirebaseDatabase.instance.reference();
          db
              .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
              .once()
              .then((DataSnapshot snapshot) {
            String a = '${snapshot.value}';
            sayac = int.parse(a);
            print(sayac);
            if (sayac == 0) {
              sayac = 0;
              print("sıfır a girdi");
              db
                  .child(ARACISMI.toString() + "/Urunler/" + sayac.toString())
                  .set({
                "UrunAdi": urun,
                "UrunAdedi": adet,
                "UrunFiyati": fiyat,
                "UrunGramaj": "X"
              });
              sayac = sayac + 1;
              db.child(ARACISMI.toString() + "/UrunSayac/Usayac").update({
                "sayac": sayac,
              });
              _controller.clear();
              _controller1.clear();
              _controller2.clear();
              _controller3.clear();
              adet = null;
              fiyat = null;
              gram = null;
              urun = null;
              Toast.show("KAYDINIZ TAMAMLANMIŞTIR ", context,
                  duration: 5, gravity: Toast.BOTTOM);
              listeal();
            } else {
              for (var i = 0; i < k.length; i++) {
                print(k[i]);
                print(urun);
                if (k[i] == urun) {
                  ksn = "var";
                  break;
                } else {
                  ksn = "yok";
                }
              }

              print(ksn);
              if (ksn == "var") {
                Toast.show("BU İSİMDE Bİ ÜRÜN KAYIT ETMİŞTİNİZ... ", context,
                    duration: 5, gravity: Toast.BOTTOM);
              } else if (ksn == "yok") {
                db
                    .child(ARACISMI.toString() + "/Urunler/" + sayac.toString())
                    .set({
                  "UrunAdi": urun,
                  "UrunAdedi": adet,
                  "UrunFiyati": fiyat,
                  "UrunGramaj": "X"
                });
                sayac = sayac + 1;
                db.child(ARACISMI.toString() + "/UrunSayac/Usayac").update({
                  "sayac": sayac,
                });
                _controller.clear();
                _controller1.clear();
                _controller2.clear();
                _controller3.clear();
                adet = null;
                fiyat = null;
                gram = null;
                urun = null;
                Toast.show("KAYDINIZ TAMAMLANMIŞTIR ", context,
                    duration: 5, gravity: Toast.BOTTOM);
                listeal();
              }
            }
          });
        } else if (adet == null || adet == "") {
          print("ikinci if");
          final db = FirebaseDatabase.instance.reference();
          db
              .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
              .once()
              .then((DataSnapshot snapshot) {
            String a = '${snapshot.value}';
            sayac = int.parse(a);
            if (sayac == null) {
              sayac = 0;

              db
                  .child(ARACISMI.toString() + "/Urunler/" + sayac.toString())
                  .set({
                "UrunAdi": urun,
                "UrunAdedi": "X",
                "UrunFiyati": fiyat,
                "UrunGramaj": gram
              });
              sayac = sayac + 1;
              db.child(ARACISMI.toString() + "/UrunSayac/Usayac").update({
                "sayac": sayac,
              });
              _controller.clear();
              _controller1.clear();
              _controller2.clear();
              _controller3.clear();
              adet = null;
              fiyat = null;
              gram = null;
              urun = null;
              Toast.show("KAYDINIZ TAMAMLANMIŞTIR ", context,
                  duration: 5, gravity: Toast.BOTTOM);
              listeal();
            } else {
              for (var i = 0; i < k.length; i++) {
                if (k[i] == urun) {
                  ksn = "var";
                  break;
                } else {
                  ksn = "yok";
                }
              }
              if (ksn == "var") {
                Toast.show("BU İSİMDE Bİ ÜRÜN KAYIT ETMİŞTİNİZ... ", context,
                    duration: 5, gravity: Toast.BOTTOM);
                listeal();
              } else if (ksn == "yok") {
                final db = FirebaseDatabase.instance.reference();
                db
                    .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
                    .once()
                    .then((DataSnapshot snapshot) {
                  String a = '${snapshot.value}';
                  sayac = int.parse(a);
                });

                db
                    .child(ARACISMI.toString() + "/Urunler/" + sayac.toString())
                    .set({
                  "UrunAdi": urun,
                  "UrunAdedi": "X",
                  "UrunFiyati": fiyat,
                  "UrunGramaj": gram
                });
                sayac = sayac + 1;
                db.child(ARACISMI.toString() + "/UrunSayac/Usayac").update({
                  "sayac": sayac,
                });
                _controller.clear();
                _controller1.clear();
                _controller2.clear();
                _controller3.clear();
                adet = null;
                fiyat = null;
                gram = null;
                urun = null;
                Toast.show("KAYDINIZ TAMAMLANMIŞTIR ", context,
                    duration: 5, gravity: Toast.BOTTOM);
                listeal();
              }
            }
          });
        } else {
          Toast.show("İKİ DEĞERİDE DOLDURAZSINIZ", context,
              duration: 5, gravity: Toast.BOTTOM);
        }
      }
    }
  }
}
