import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../aracIsim.dart';

class Sepet extends StatefulWidget {
  @override
  _SepetState createState() => _SepetState();
}

final TextEditingController _controller = new TextEditingController();
final TextEditingController _controller1 = new TextEditingController();

// ignore: non_constant_identifier_names

//müsteri isimleri için 2 tanesi
final List<String> diziAd = [];
// ignore: non_constant_identifier_names
final List<dynamic> DiziUrunAdi = [];
// ignore: non_constant_identifier_names
final List<dynamic> DIZIADET = [];
// ignore: non_constant_identifier_names
final List<dynamic> DiziFiyat = [];
// ignore: non_constant_identifier_names
final List<dynamic> DiziToplam = [];
var odemedizi = [];

class _SepetState extends State<Sepet> {
  String selectedValue, _value;
  int sayac, sayacZ, sayacM, sayacT, sayacMler, urunSayac;
  double topla = 0;
  List toplamUrunSayaci = [];
  final List<DropdownMenuItem> items = [];
  var tarih = DateFormat.yMd().format(DateTime.now());
  var bakiye = "Kişi Gİrilmedi";
  double tahsilat;
  @override
  void initState() {
    final db = FirebaseDatabase.instance.reference();
    setState(() {
      toplamUrunSayaci = DiziUrunAdi;

      db
          .child("MusteriSayac/Msayac/sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String a = '${snapshot.value}';
        sayac = int.parse(a);
        for (var i = 0; i < sayac; i++) {
          db
              .child("Musteriler/" + i.toString() + "/MusteriAdi")
              .once()
              .then((DataSnapshot snapshot) {
            String b = '${snapshot.value}';
            setState(() {
              diziAd.add(b);
              items.add(DropdownMenuItem(
                child: Text(diziAd[i]),
                value: diziAd[i],
              ));
            });
          });
        }
      });

      for (var i = 0; i < DiziToplam.length; i++) {
        topla = DiziToplam[i] + topla;
      }
    });
    db.child("MusteriTakip/Mtakip/takip").once().then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      sayacM = int.parse(a);
      print("ldljhvsldnfsş  " + sayacM.toString());
      for (var i = 0; i < sayacM; i++) {
        db
            .child("MusteriHareket/" + i.toString() + "/0/" + "Ad")
            .once()
            .then((DataSnapshot snapshot) {
          setState(() {
            madi.add('${snapshot.value}');
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> widgets;
    widgets = {
      "Müşteri Listesi": SearchableDropdown.single(
        items: items,
        value: selectedValue,
        hint: "Kişiler",
        searchHint: "Kişi Seçiniz",
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            kisiBakiye();
          });
        },
        isExpanded: true,
      ),
    };

    odemedizi = [
      "NAKİT",
      "KREDİ KARTI",
      "EFT/HAVALE",
      "VERESİYE",
      "SADECE TAHSİLAT"
    ];
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //musteri listesi
            Column(
              children: widgets
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
                                    EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
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
            //urunler listesi

            DataTable(
              columnSpacing: 20,
              showBottomBorder: true,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'urun adi',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'adet',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'fiyat',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'toplam',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: [
                for (int i = 0; i < toplamUrunSayaci.length; i++)
                  DataRow(
                    onSelectChanged: (b) {
                      setState(() {
                        var urunAdi = DiziUrunAdi[i].toString();
                        var urunAdedim = DIZIADET[i].toString();
                        var urunfiyat = DiziFiyat[i].toString();
                        var uruntop = DiziToplam[i].toString();

                        _showMyDialog(urunAdi, urunAdedim, uruntop, urunfiyat);
                      });
                    },
                    cells: <DataCell>[
                      DataCell(Text(DiziUrunAdi[i].toString())),
                      DataCell(Text(DIZIADET[i].toString())),
                      DataCell(
                        Text(DiziFiyat[i].toString()),
                      ),
                      DataCell(
                        Text(DiziToplam[i].toString()),
                      ),
                    ],
                  ),
              ],
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text("TOPLAM"),
                          ),
                          Container(
                            width: 100,
                            height: 50,
                            child: TextField(
                              enabled: false,
                              onChanged: (String uAdet) {
                                setState(() {});
                              },
                              obscureText: false,
                              controller: _controller1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: topla.toString(),
                              ),
                            ),
                            margin:
                                EdgeInsets.only(right: 20, left: 10, top: 20),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text("TAHSİLAT"),
                          ),
                          Container(
                            width: 100,
                            height: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              enabled: true,
                              onChanged: (String tahsil) {
                                setState(() {
                                  tahsilat = double.parse(tahsil);
                                });
                              },
                              obscureText: false,
                              controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'TL',
                              ),
                            ),
                            margin: EdgeInsets.only(left: 10, top: 20),
                          )
                        ],
                      )
                    ],
                  ),
                  //ödeme şekli
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("ÖDEME ŞEKLİNİ SECİNİZ"),
                            DropdownButton<String>(
                              iconEnabledColor: Colors.grey[350],
                              items: [
                                for (var i = 0; i < odemedizi.length; i++)
                                  DropdownMenuItem<String>(
                                    value: odemedizi[i].toString(),
                                    child: Text(
                                      odemedizi[i].toString(),
                                    ),
                                  ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                              value: _value,
                              elevation: 2,
                              isDense: true,
                              iconSize: 40.0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 30),
                        child: Column(
                          children: <Widget>[
                            Text("TARİH (Ay/Gün/Yıl) "),
                            Container(
                              child: Text(tarih),
                              margin: EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("MÜSTERİ SATIŞ ONCESİ SON BAKİYE  :  "),
                        Text(bakiye),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Color.fromRGBO(169, 131, 7, 1),
                      elevation: 2.0,
                      splashColor: Colors.black,
                      child: Text(
                        "SATIŞI ONAYLA",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        satisOnay();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int ksn;

  int kisiNo;
  List madi = [];
  Future satisOnay() async {
    ksn = -1;
    final db = FirebaseDatabase.instance.reference();
    //gunsonudenemeDizi.clear();

    if (selectedValue == null ||
            bakiye == "Kişi Gİrilmedi" ||
            tahsilat == null ||
            _value == null ||
            _value == "null" /* ||
          */
        ) {
      Toast.show("BİLGİ EKSİĞİ VARDIR LÜTFEN KONTROL EDİNİZ", context,
          duration: 5, gravity: Toast.BOTTOM);
    } else {
      if (_value == "SADECE TAHSİLAT") {
        //müsşteri tabip başla
        db
            .child("MusteriTakip/Mtakip/takip")
            .once()
            .then((DataSnapshot snapshot) {
          String a = '${snapshot.value}';
          sayacM = int.parse(a);

          for (var i = 0; i < sayacM; i++) {
            db
                .child("MusteriHareket/" + i.toString() + "/0/" + "Ad")
                .once()
                .then((DataSnapshot snapshot) {
              setState(() {
                madi.add('${snapshot.value}');
              });
            });
          }
          print(madi);
          for (var i = 0; i < madi.length; i++) {
            if (selectedValue == madi[i]) {
              ksn = 1;
              kisiNo = i;
              break;
            } else {
              ksn = -1;
            }
          }
          if (ksn == 1) {
            kisiVarsaTahsilat(kisiNo);
            cariGuncelleTahsilat();
            zRaporEkleTahsilat();
          } else if (ksn == -1) {
            kisiyoksaTahsilat(sayacM);
            cariGuncelleTahsilat();
            zRaporEkleTahsilat();
          }
        });
      } else {
        if (topla == 0 || DiziUrunAdi == []) {
          Toast.show("BİLGİ EKSİĞİ VARDIR LÜTFEN KONTROL EDİNİZ", context,
              duration: 5, gravity: Toast.BOTTOM);
        } else {
          //müsşteri tabip başla
          db
              .child("MusteriTakip/Mtakip/takip")
              .once()
              .then((DataSnapshot snapshot) {
            String a = '${snapshot.value}';
            sayacM = int.parse(a);

            for (var i = 0; i < sayacM; i++) {
              db
                  .child("MusteriHareket/" + i.toString() + "/0/" + "Ad")
                  .once()
                  .then((DataSnapshot snapshot) {
                setState(() {
                  madi.add('${snapshot.value}');
                });
              });
            }
            print(madi);
            for (var i = 0; i < madi.length; i++) {
              if (selectedValue == madi[i]) {
                ksn = 1;
                kisiNo = i;
                break;
              } else {
                ksn = -1;
              }
            }
            if (ksn == 1) {
              kisiVarsa(kisiNo);
              cariguncelle();

              urunAzalt();
              zRaporuEkle();
            } else if (ksn == -1) {
              kisiYoksa(sayacM);
              cariguncelle();

              urunAzalt();
              zRaporuEkle();
            }
          });
        }
      }
    }
  }

  Future kisiVarsaTahsilat(kisiNo) async {
    final db = FirebaseDatabase.instance.reference();

    db
        .child(selectedValue + "/Msayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';

      sayacT = int.parse(a);

      db
          .child(
              "MusteriHareket/" + kisiNo.toString() + "/" + sayacT.toString())
          .set({
        "Ad": selectedValue,
        "SonBakiye": (double.parse(bakiye)) - tahsilat,
        "Tarih": tarih,
        "OdemeSekli": _value,
        "Tahsilat": tahsilat,
        "ToplamAlinan": 0,
      });
      sayacT = sayacT + 1;
      db.child(selectedValue + "/Msayac").update({
        "sayac": sayacT,
      });

      Toast.show("İŞLEMİNİZ YAPILMIŞTIR", context,
          duration: 3, gravity: Toast.BOTTOM);
      //bitiş
    });

    // müsteri varsa onun altına bi bölüm daha ekleme kısmı
  }

  Future kisiyoksaTahsilat(sayacM) async {
    final db =
        FirebaseDatabase.instance.reference(); //MUSTERİ VAEMI YOKMUI KISMI

    db.child(selectedValue + "/Msayac").set({
      "sayac": 1,
    });

    db.child("MusteriHareket/" + sayacM.toString() + "/0").set({
      "Ad": selectedValue,
      "SonBakiye": (double.parse(bakiye)) - tahsilat,
      "Tarih": tarih,
      "OdemeSekli": _value,
      "Tahsilat": tahsilat,
      "ToplamAlinan": 0,
    });
    sayacM = sayacM + 1;
    db.child("MusteriTakip/Mtakip").update({
      "takip": sayacM,
    });

    Toast.show("İŞLEMİNİZ YAPILMIŞTIR", context,
        duration: 3, gravity: Toast.BOTTOM);

    //bitiş
  }

  Future zRaporEkleTahsilat() async {
    final db = FirebaseDatabase.instance.reference();
    //z raporu
    db
        .child(ARACISMI.toString() + "/ZRaporSayac/Zsayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      sayacZ = int.parse(a);

      db.child(ARACISMI.toString() + "/ZRapor/" + sayacZ.toString()).set({
        "KisiAdi": selectedValue,
        "SonBakiye": (double.parse(bakiye)) - tahsilat,
        "Tarih": tarih,
        "OdemeSekli": _value,
        "Tahsilat": tahsilat,
        "ToplamAlinan": 0,
      });
      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              sayacZ.toString() +
              "/Alinanlar")
          .set({
        "Sayac": 1,
      });
      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              sayacZ.toString() +
              "/Alinanlar/Urunler")
          .set({
        "0": "SADECE TAHSİLAT",
      });
      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              sayacZ.toString() +
              "/Alinanlar/Fiyatlar")
          .set({
        "0": " ",
      });
      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              sayacZ.toString() +
              "/Alinanlar/Adet")
          .set({
        "0": " ",
      });

      sayacZ = sayacZ + 1;
      db.child(ARACISMI.toString() + "/ZRaporSayac/Zsayac").update({
        "sayac": sayacZ,
      });
      setState(() {
        DiziUrunAdi.clear();
        DiziFiyat.clear();
        DiziToplam.clear();
        DIZIADET.clear();
        _value = null;
        _controller.clear();
        _controller1.clear();
      });
    });
    //bitiş
  }

/*alt okey */
  Future zRaporuEkle() async {
    print("z rapor ekleme");
    final db = FirebaseDatabase.instance.reference();
    //z raporu
    db
        .child(ARACISMI.toString() + "/ZRaporSayac/Zsayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      sayacZ = int.parse(a);
      if (_value == "VERESİYE") {
        db.child(ARACISMI.toString() + "/ZRapor/" + sayacZ.toString()).set({
          "KisiAdi": selectedValue,
          "SonBakiye": (double.parse(bakiye) + topla),
          "Tarih": tarih,
          "OdemeSekli": _value,
          "Tahsilat": tahsilat,
          "ToplamAlinan": topla,
        });
      } else {
        db.child(ARACISMI.toString() + "/ZRapor/" + sayacZ.toString()).set({
          "KisiAdi": selectedValue,
          "SonBakiye": (double.parse(bakiye) + topla) - tahsilat,
          "Tarih": tarih,
          "OdemeSekli": _value,
          "Tahsilat": tahsilat,
          "ToplamAlinan": topla,
        });
      }

      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              sayacZ.toString() +
              "/Alinanlar")
          .set({
        "Urunler": DiziUrunAdi,
        "Fiyatlar": DiziFiyat,
        "Adet": DIZIADET,
        "Sayac": DiziUrunAdi.length,
      });

      sayacZ = sayacZ + 1;
      db.child(ARACISMI.toString() + "/ZRaporSayac/Zsayac").update({
        "sayac": sayacZ,
      });
    });
    //bitiş
  }

  Future cariGuncelleTahsilat() async {
    final db = FirebaseDatabase.instance.reference();
    db.child("MusteriSayac/Msayac/sayac").once().then((DataSnapshot snapshot) {
      String ab = '${snapshot.value}';
      sayacMler = int.parse(ab);
      for (var i = 0; i < sayacMler; i++) {
        db
            .child("Musteriler/" + i.toString() + "/MusteriAdi")
            .once()
            .then((DataSnapshot snapshot) {
          String musteriAdi = '${snapshot.value}';
          if (musteriAdi == selectedValue) {
            db.child("Musteriler/" + i.toString()).update({
              "Cari": (double.parse(bakiye)) - tahsilat,
            });
            db
                .child("Musteriler/" + i.toString() + "/Cari")
                .once()
                .then((DataSnapshot snapshot) {
              setState(() {
                String x = '${snapshot.value}';

                bakiye = x;
                print(bakiye);
              });
            });
          }
        });
      }
    });
  }

  Future urunAzalt() async {
    print("azaltmaya girdi");
    final db = FirebaseDatabase.instance.reference();
    db
        .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String usayac = '${snapshot.value}';
      print("burda urun sayaç yazdı");
      urunSayac = int.parse(usayac);
      for (var x = 0; x < DiziUrunAdi.length; x++) {
        print(x.toString() + "x kAÇ OLDU");
        for (var i = 0; i < urunSayac; i++) {
          db
              .child(
                  ARACISMI.toString() + "/Urunler/" + i.toString() + "/UrunAdi")
              .once()
              .then((DataSnapshot snapshot) {
            String veriTabaniAdi = '${snapshot.value}';
            if (DiziUrunAdi[x] == veriTabaniAdi) {
              print("ürün denkliğine girdi");
              db
                  .child(ARACISMI.toString() +
                      "/Urunler/" +
                      i.toString() +
                      "/UrunAdedi")
                  .once()
                  .then((DataSnapshot snapshot) {
                String gelenAdet = '${snapshot.value}';
                if (gelenAdet == "X") {
                } else {
                  print("ürün adedine girdi");
                  db
                      .child(ARACISMI.toString() + "/Urunler/" + i.toString())
                      .update({
                    "UrunAdedi": double.parse(gelenAdet) - DIZIADET[x],
                  });
                }
              });
              db
                  .child(ARACISMI.toString() +
                      "/Urunler/" +
                      i.toString() +
                      "/UrunGramaj")
                  .once()
                  .then((DataSnapshot snapshot) {
                String gelenGram = '${snapshot.value}';
                if (gelenGram == "X") {
                } else {
                  print("ürün grama girdi");
                  db
                      .child(ARACISMI.toString() + "/Urunler/" + i.toString())
                      .update({
                    "UrunGramaj": double.parse(gelenGram) - DIZIADET[x],
                  });
                }
              });
            }
          });
        }
      }
    });
  }

  /*bur da kişi varsa kısmı tmmlandı dokunma*/
  Future kisiVarsa(kisiNo) async {
    final db = FirebaseDatabase.instance.reference();
    if (_value == "VERESİYE") {
      db
          .child(selectedValue + "/Msayac/sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String a = '${snapshot.value}';

        sayacT = int.parse(a);

        db
            .child(
                "MusteriHareket/" + kisiNo.toString() + "/" + sayacT.toString())
            .set({
          "Ad": selectedValue,
          "SonBakiye": (double.parse(bakiye) + topla),
          "Tarih": tarih,
          "OdemeSekli": _value,
          "Tahsilat": 0,
          "ToplamAlinan": topla,
        });
        sayacT = sayacT + 1;
        db.child(selectedValue + "/Msayac").update({
          "sayac": sayacT,
        });

        Toast.show("İŞLEMİNİZ YAPILMIŞTIR", context,
            duration: 3, gravity: Toast.BOTTOM);
        //bitiş
      });
    } else {
      db
          .child(selectedValue + "/Msayac/sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String a = '${snapshot.value}';

        sayacT = int.parse(a);

        db
            .child(
                "MusteriHareket/" + kisiNo.toString() + "/" + sayacT.toString())
            .set({
          "Ad": selectedValue,
          "SonBakiye": (double.parse(bakiye) + topla) - tahsilat,
          "Tarih": tarih,
          "OdemeSekli": _value,
          "Tahsilat": tahsilat,
          "ToplamAlinan": topla,
        });
        sayacT = sayacT + 1;
        db.child(selectedValue + "/Msayac").update({
          "sayac": sayacT,
        });

        Toast.show("İŞLEMİNİZ YAPILMIŞTIR", context,
            duration: 3, gravity: Toast.BOTTOM);
        //bitiş
      });
    }
    // müsteri varsa onun altına bi bölüm daha ekleme kısmı
  }

/*alt okey tamamlandı dkunma*/
  Future kisiYoksa(sayacM) async {
    final db =
        FirebaseDatabase.instance.reference(); //MUSTERİ VAEMI YOKMUI KISMI

    if (_value == "VERESİYE") {
      db.child(selectedValue + "/Msayac").set({
        "sayac": 1,
      });

      db.child("MusteriHareket/" + sayacM.toString() + "/0").set({
        "Ad": selectedValue,
        "SonBakiye": (double.parse(bakiye) + topla),
        "Tarih": tarih,
        "OdemeSekli": _value,
        "Tahsilat": 0,
        "ToplamAlinan": topla,
      });
      sayacM = sayacM + 1;
      db.child("MusteriTakip/Mtakip").update({
        "takip": sayacM,
      });

      Toast.show("İŞLEMİNİZ YAPILMIŞTIR", context,
          duration: 3, gravity: Toast.BOTTOM);
    } else {
      db.child(selectedValue + "/Msayac").set({
        "sayac": 1,
      });

      db.child("MusteriHareket/" + sayacM.toString() + "/0").set({
        "Ad": selectedValue,
        "SonBakiye": (double.parse(bakiye) + topla) - tahsilat,
        "Tarih": tarih,
        "OdemeSekli": _value,
        "Tahsilat": tahsilat,
        "ToplamAlinan": topla,
      });
      sayacM = sayacM + 1;
      db.child("MusteriTakip/Mtakip").update({
        "takip": sayacM,
      });

      Toast.show("İŞLEMİNİZ YAPILMIŞTIR", context,
          duration: 3, gravity: Toast.BOTTOM);
    }

    //bitiş
  }

/*alt okey tamamlandı dokunma*/
  Future cariguncelle() async {
    final db = FirebaseDatabase.instance.reference();
    db.child("MusteriSayac/Msayac/sayac").once().then((DataSnapshot snapshot) {
      String ab = '${snapshot.value}';
      sayacMler = int.parse(ab);
      for (var i = 0; i < sayacMler; i++) {
        db
            .child("Musteriler/" + i.toString() + "/MusteriAdi")
            .once()
            .then((DataSnapshot snapshot) {
          String musteriAdi = '${snapshot.value}';
          if (musteriAdi == selectedValue) {
            if (_value == "VERESİYE") {
              db.child("Musteriler/" + i.toString()).update({
                "Cari": (double.parse(bakiye) + topla),
              });
              db
                  .child("Musteriler/" + i.toString() + "/Cari")
                  .once()
                  .then((DataSnapshot snapshot) {
                setState(() {
                  String x = '${snapshot.value}';

                  bakiye = x;
                  print(bakiye);
                });
              });
            } else {
              db.child("Musteriler/" + i.toString()).update({
                "Cari": (double.parse(bakiye) + topla) - tahsilat,
              });
              db
                  .child("Musteriler/" + i.toString() + "/Cari")
                  .once()
                  .then((DataSnapshot snapshot) {
                setState(() {
                  String x = '${snapshot.value}';

                  bakiye = x;
                  print(bakiye);
                });
              });
            }
          }
        });
      }
    });
  }

/*dokunma */
  Future kisiBakiye() async {
    if (selectedValue == null || selectedValue == "") {
      bakiye = "Kişi Gİrilmedi";
      print("ilkinde");
    } else {
      final db = FirebaseDatabase.instance.reference();
      db
          .child("MusteriSayac/Msayac/sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String a = '${snapshot.value}';
        sayac = int.parse(a);
        for (var i = 0; i < sayac; i++) {
          db
              .child("Musteriler/" + i.toString() + "/MusteriAdi")
              .once()
              .then((DataSnapshot snapshot) {
            String b = '${snapshot.value}';
            if (selectedValue == b) {
              db
                  .child("Musteriler/" + i.toString() + "/Cari")
                  .once()
                  .then((DataSnapshot snapshot) {
                setState(() {
                  String x = '${snapshot.value}';

                  bakiye = x;
                  print(bakiye);
                });
              });
            }
          });
        }
      });
    }
  }

  Future<void> _showMyDialog(urunAdi, urunAdedim, uruntop, urunfiyat) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ÇIKARMAK İSTEDİĞİNİZE EMİN MİSİNİZ"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("urun adı : " + urunAdi),
                Text("urun adedi : " + urunAdedim),
                Text("urun fiyatı : " + urunfiyat),
                Text("urun toplamı : " + uruntop),
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
              child: Text('ÇIKAR'),
              onPressed: () {
                setState(() {
                  for (var i = 0; i < DiziUrunAdi.length; i++) {
                    if (DiziUrunAdi[i] == urunAdi) {
                      print(DiziUrunAdi);
                      setState(() {
                        DiziUrunAdi.remove(DiziUrunAdi[i]);
                        DiziFiyat.remove(DiziFiyat[i]);
                        DIZIADET.remove(DIZIADET[i]);
                        DiziToplam.remove(DiziToplam[i]);
                        topla = 0;
                        for (var t = 0; t < DiziToplam.length; t++) {
                          print(DiziToplam);

                          topla = DiziToplam[t] + topla;
                        }
                        print("toplam" + topla.toString());
                      });

                      /* diğerki diziler düzünlenecek hatalar düşünülecek*/

                    }
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
