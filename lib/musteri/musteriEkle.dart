import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class MusteriEkle extends StatefulWidget {
  @override
  _MusteriEkleState createState() => _MusteriEkleState();
}

final TextEditingController _controller = new TextEditingController();
final TextEditingController _controller1 = new TextEditingController();
final TextEditingController _controller2 = new TextEditingController();

final TextEditingController _controller3 = new TextEditingController();
final TextEditingController _controller4 = new TextEditingController();
final TextEditingController _controller5 = new TextEditingController();
final TextEditingController _controller6 = new TextEditingController();

class _MusteriEkleState extends State<MusteriEkle> {
  String musteriAdi = "",
      dukkanAdi = "",
      telNo = "",
      adres = "",
      vergiNo = "",
      il = "";
  int sayac;
  List mtr = [];
  String test;
  double cari = 0.0;
  @override
  void initState() {
    setState(() {
      musterileriCek();
    });
    super.initState();
  }

  void musterileriCek() async {
    final db = FirebaseDatabase.instance.reference();
    db.child("MusteriSayac/Msayac/sayac").once().then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      sayac = int.parse(a);
      for (var i = 0; i < sayac; i++) {
        db
            .child("Musteriler/" + i.toString() + "/MusteriAdi")
            .once()
            .then((DataSnapshot snapshot) {
          setState(() {
            mtr.add('${snapshot.value}');
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Müsteri Adi
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  onChanged: (String mAdi) {
                    setState(() {
                      musteriAdi = mAdi;
                    });
                  },
                  obscureText: false,
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'MÜSTERİ ADI - SOYADI',
                  ),
                )),
            //DÜkkan adi
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  onChanged: (String dAdi) {
                    setState(() {
                      dukkanAdi = dAdi;
                    });
                  },
                  obscureText: false,
                  controller: _controller1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'DÜKKAN ADI',
                  ),
                )),
            //telno
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String tel) {
                    setState(() {
                      telNo = tel;
                    });
                  },
                  obscureText: false,
                  controller: _controller2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'TELEFON NUMARASI',
                  ),
                )),
            //VERGİ NO
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String vNo) {
                    setState(() {
                      vergiNo = vNo;
                    });
                  },
                  obscureText: false,
                  controller: _controller3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'VERGİ NUMARASI',
                  ),
                )),
            //İL BilGisi
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  onChanged: (String ili) {
                    setState(() {
                      il = ili;
                    });
                  },
                  obscureText: false,
                  controller: _controller4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'İL BİLGİSİ',
                  ),
                )),
            //açık ADRESİİ
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  onChanged: (String adress) {
                    setState(() {
                      adres = adress;
                    });
                  },
                  obscureText: false,
                  controller: _controller5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ADRES BİLGİSİ',
                  ),
                )),
            //CARİ BAKİYESİ
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String car) {
                    setState(() {
                      cari = double.parse(car);
                    });
                  },
                  obscureText: false,
                  controller: _controller6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CARİ BAKİYESİ',
                  ),
                )),
            Text(
              "Bu alanı boş bırakırsanız otomatik olarak 0 girilecektir",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue),
            ),
            //ekleme buttonu
            new Container(
              margin: EdgeInsets.only(top: 20),
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color.fromRGBO(169, 131, 7, 1),
                elevation: 2.0,
                splashColor: Colors.black,
                child: Text(
                  "MÜŞTERİ KAYDET",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  musteriKaydet();
                },
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future musteriKaydet() async {
    if (musteriAdi == null ||
        musteriAdi == "" ||
        dukkanAdi == null ||
        dukkanAdi == "" ||
        telNo == null ||
        telNo == "" ||
        adres == null ||
        adres == "" ||
        vergiNo == null ||
        vergiNo == "" ||
        il == null ||
        il == "") {
      Toast.show(
          "HİÇ Bİ DEĞER BOŞ BIRAKILMAMALI LÜTFEN TEKRAR DENEYİNİZ ", context,
          duration: 6, gravity: Toast.BOTTOM);
    } else {
      final db = FirebaseDatabase.instance.reference();
      db
          .child("MusteriSayac/Msayac/sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String a = '${snapshot.value}';
        sayac = int.parse(a);
        print(sayac);
        if (sayac == null || sayac == 0) {
          sayac = 0;
          print(sayac);
          db.child("Musteriler/" + sayac.toString()).set({
            "MusteriAdi": musteriAdi,
            "DukkanAdi": dukkanAdi,
            "TelNo": telNo,
            "Adres": adres,
            "Cari": cari,
            "VergiNo": vergiNo,
            "Il": il,
          });
          sayac = sayac + 1;
          db.child("MusteriSayac/Msayac").update({
            "sayac": sayac,
          });
          Toast.show("KAYDINIZ TAMAMLANMIŞTIR ", context,
              duration: 5, gravity: Toast.BOTTOM);
          _controller.clear();
          _controller1.clear();
          _controller2.clear();
          _controller3.clear();
          _controller4.clear();
          _controller5.clear();
          _controller6.clear();
          musteriAdi = null;
          dukkanAdi = null;
          telNo = null;
          adres = null;
          vergiNo = null;
          il = null;
          cari = 0;
          musterileriCek();
        } else {
          for (var i = 0; i < mtr.length; i++) {
            if (mtr[i] == musteriAdi) {
              test = "var";
              break;
            } else {
              test = "yok";
            }
          }
          if (test == "var") {
            Toast.show("BU İSİMDE Bİ MÜSTERİNİZ KAYITLIDIR... ", context,
                duration: 5, gravity: Toast.BOTTOM);
          } else if (test == "yok") {
            db.child("Musteriler/" + sayac.toString()).set({
              "MusteriAdi": musteriAdi,
              "DukkanAdi": dukkanAdi,
              "TelNo": telNo,
              "Adres": adres,
              "Cari": cari,
              "VergiNo": vergiNo,
              "Il": il,
            });
            sayac = sayac + 1;
            db.child("MusteriSayac/Msayac").update({
              "sayac": sayac,
            });
            Toast.show("KAYDINIZ TAMAMLANMIŞTIR ", context,
                duration: 5, gravity: Toast.BOTTOM);
            _controller.clear();
            _controller1.clear();
            _controller2.clear();
            _controller3.clear();
            _controller4.clear();
            _controller5.clear();
            _controller6.clear();
            musteriAdi = null;
            dukkanAdi = null;
            telNo = null;
            adres = null;
            vergiNo = null;
            il = null;
            cari = 0;
            musterileriCek();
          }
        }
      });
    }
  }
}
