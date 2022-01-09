import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'dart:async';
import 'package:widget_loading/widget_loading.dart';

import '../aracIsim.dart';

class Zraporu extends StatefulWidget {
  @override
  _ZraporuState createState() => _ZraporuState();
}

/*
  kişi adı
  ödeme şekli
  tahsilat
  tarih

 */
class _ZraporuState extends State<Zraporu> {
  int sayacZrapor;
  List kisiAdiDizi = [];
  List odemeSekliDizi = [];
  List tahsilatDizi = [];
  List tarihDizi = [];
  List urunler = [];
  List fiyatler = [];
  List adetler = [];
  double topla = 0;
  List alinanlarurun = [];
  List alinanlaradet = [];
  List alinanlarfiyat = [];

  Future future = Future.delayed(Duration(seconds: 5));

  StreamSubscription _subscription;
  bool loading = true;
  Future listeleme() async {
    final db = FirebaseDatabase.instance.reference();
    db
        .child(ARACISMI.toString() + "/ZRaporSayac/Zsayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      sayacZrapor = int.parse(a);

      for (var i = 0; i < sayacZrapor; i++) {
        db
            .child(ARACISMI.toString() + "/ZRapor/" + i.toString() + "/KisiAdi")
            .once()
            .then((DataSnapshot snapshot) {
          setState(() {
            String b = '${snapshot.value}';

            kisiAdiDizi.add(b);
          });
        });
        db
            .child(
                ARACISMI.toString() + "/ZRapor/" + i.toString() + "/OdemeSekli")
            .once()
            .then((DataSnapshot snapshot) {
          setState(() {
            String c = '${snapshot.value}';

            odemeSekliDizi.add(c);
          });
        });
        db
            .child(
                ARACISMI.toString() + "/ZRapor/" + i.toString() + "/Tahsilat")
            .once()
            .then((DataSnapshot snapshot) {
          setState(() {
            setState(() {
              String d = '${snapshot.value}';
              tahsilatDizi.add(d);
              topla += double.parse(d);
            });
          });
        });
        db
            .child(ARACISMI.toString() + "/ZRapor/" + i.toString() + "/Tarih")
            .once()
            .then((DataSnapshot snapshot) {
          setState(() {
            String e = '${snapshot.value}';
            tarihDizi.add(e);
          });
        });
      }
    });
  }

  Future giris() async {
    _subscription = Stream.periodic(Duration(seconds: 5)).listen((i) {
      setState(() {
        loading = false;
      });
    });

    setState(() {
      listeleme();
    });
  }

  @override
  void initState() {
    giris();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }

  double tutarAyarla = 0;
  /* tasarımda columsların genişliğini ayarla */
  @override
  Widget build(BuildContext context) {
    return Material(
        child: CircularWidgetLoading(
      dotColor: Colors.blueGrey,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DataTable(
                columnSpacing: double.minPositive + 10,
                showBottomBorder: true,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      '(AY/GÜN/YIL)',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'KİŞİ ADI',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ÖDEME',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'TAHSİLAT',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                    ),
                  ),
                ],
                rows: [
                  for (int i = 0; i < sayacZrapor; i++)
                    DataRow(
                      onSelectChanged: (b) {
                        setState(() {
                          if (i == (sayacZrapor - 1)) {
                            var musteriAdi = kisiAdiDizi[i].toString();
                            var tahs = tahsilatDizi[i].toString();
                            final db = FirebaseDatabase.instance.reference();
                            db
                                .child(ARACISMI.toString() +
                                    "/ZRapor/" +
                                    i.toString() +
                                    "/Alinanlar/Sayac")
                                .once()
                                .then((DataSnapshot snapshot) {
                              String a = '${snapshot.value}';
                              int alinansayac = int.parse(a);
                              for (var f = 0; f < alinansayac; f++) {
                                db
                                    .child(ARACISMI.toString() +
                                        "/ZRapor/" +
                                        i.toString() +
                                        "/Alinanlar/Adet/" +
                                        f.toString())
                                    .once()
                                    .then((DataSnapshot snapshot) {
                                  alinanlaradet.add('${snapshot.value}');
                                });
                                db
                                    .child(ARACISMI.toString() +
                                        "/ZRapor/" +
                                        i.toString() +
                                        "/Alinanlar/Urunler/" +
                                        f.toString())
                                    .once()
                                    .then((DataSnapshot snapshot) {
                                  alinanlarurun.add('${snapshot.value}');
                                });
                                db
                                    .child(ARACISMI.toString() +
                                        "/ZRapor/" +
                                        i.toString() +
                                        "/Alinanlar/Fiyatlar/" +
                                        f.toString())
                                    .once()
                                    .then((DataSnapshot snapshot) {
                                  alinanlarfiyat.add('${snapshot.value}');
                                });
                              }
                            });
                            _showMyDialog(musteriAdi, tahs);
                          } else {
                            Toast.show(
                                "SADECE SON İŞLEMİNİZDE DÜZÜNLEME YAPABİLİRSİNİZ ",
                                context,
                                duration: 5,
                                gravity: Toast.BOTTOM);
                          }
                        });
                      },
                      cells: <DataCell>[
                        DataCell(Text(
                          tarihDizi[i],
                        )),
                        DataCell(Text(kisiAdiDizi[i])),
                        DataCell(
                          Text(odemeSekliDizi[i]),
                        ),
                        DataCell(
                          Text(
                            tahsilatDizi[i],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "Toplam Alınan Para : " + topla.toString(),
                  style: TextStyle(fontSize: 18),
                ),
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
                    "Z RAPORU BİTİR ",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    zRaporBitir();
                  },
                ),
                margin: EdgeInsets.only(bottom: 20, top: 20),
              ),
            ],
          ),
        ),
      ),
      loading: loading,
    ));
  }

/* test aşaması kaldı.................................................................................................... */
  Future faturaSilme(musteriAdi) async {}

/* bu da SORUN YOK */
  Future tahsilatAyar(musteriAdi, tahs) async {
    print("tahsilata  eklemeye geçti");
    final db = FirebaseDatabase.instance.reference();
    db.child("MusteriSayac/Msayac/sayac").once().then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      int mSayacGetir = int.parse(a);

      for (var i = 0; i < mSayacGetir; i++) {
        db
            .child("Musteriler/" + i.toString() + "/MusteriAdi")
            .once()
            .then((DataSnapshot snapshot) {
          String adi = '${snapshot.value}';
          if (adi == musteriAdi) {
            db
                .child(ARACISMI.toString() +
                    "/ZRapor/" +
                    (sayacZrapor - 1).toString() +
                    "/ToplamAlinan")
                .once()
                .then((DataSnapshot snapshot) {
              String tp = '${snapshot.value}';
              print(
                  "...............................................................................................tp ............" +
                      tp);
              double toplamalinan = double.parse(tp);
              db
                  .child("Musteriler/" + i.toString() + "/Cari")
                  .once()
                  .then((DataSnapshot snapshot) {
                String cr = '${snapshot.value}';
                db.child("Musteriler/" + i.toString()).update({
                  "Cari": (double.parse(cr) - toplamalinan) +
                      double.parse(
                          tahs), //su matamatiğiğe bak doğrumu diye 27,05,21
                });
              });
            });
          }
        });
      }
    });
  }

/*sadece tahsilat kısmı olacak */
  Future urunEkleme(musteriAdi, tahs) async {
    print("ürün eklemeye geçti");
    final db = FirebaseDatabase.instance.reference();
    db
        .child(ARACISMI.toString() + "/ZRaporSayac/Zsayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String s = '${snapshot.value}';
      // ignore: non_constant_identifier_names
      int Zsay = int.parse(s) - 1;

      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              Zsay.toString() +
              "/Alinanlar/Sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String alinan = '${snapshot.value}';
        int alinanSayacUrun = int.parse(alinan);
        for (var x = 0; x < alinanSayacUrun; x++) {
          db
              .child(ARACISMI.toString() +
                  "/ZRapor/" +
                  Zsay.toString() +
                  "/Alinanlar/Urunler/" +
                  x.toString())
              .once()
              .then((DataSnapshot snapshot) {
            String urunAdiAlinan = '${snapshot.value}';
            print("UrunAdiAlinan   " + urunAdiAlinan);
            if (urunAdiAlinan == "SADECE TAHSİLAT") {
              /* sadedxce cari eklemesi yapacağız */
              print("  sadece tahsilat ayarlaya girdi");
            } else {
              db
                  .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
                  .once()
                  .then((DataSnapshot snapshot) {
                String a = '${snapshot.value}';
                int urunSayac = int.parse(a);
                print("urunSayac  " + urunSayac.toString());
                for (var i = 0; i < urunSayac; i++) {
                  db
                      .child(ARACISMI.toString() +
                          "/Urunler/" +
                          i.toString() +
                          "/UrunAdi")
                      .once()
                      .then((DataSnapshot snapshot) {
                    String ad = '${snapshot.value}';
                    if (urunAdiAlinan == ad) {
                      print("urunAdiAlinan==Ad a girdi");
                      db
                          .child(ARACISMI.toString() +
                              "/Urunler/" +
                              i.toString() +
                              "/UrunAdedi")
                          .once()
                          .then((DataSnapshot snapshot) {
                        String bakadet = '${snapshot.value}';
                        print("bakadet bukadarı sordu" + bakadet);
                        if (bakadet == "X") {
                          print("bakadet X bu ise buraya girdi");
                          db
                              .child(ARACISMI.toString() +
                                  "/Urunler/" +
                                  i.toString() +
                                  "/UrunGramaj")
                              .once()
                              .then((DataSnapshot snapshot) {
                            String gram = '${snapshot.value}';
                            print("BakAdet X ise gram değeri bu olur" + gram);
                            print("alinan SAYAC urun" +
                                alinanSayacUrun.toString());
                            db
                                .child(ARACISMI.toString() +
                                    "/ZRapor/" +
                                    Zsay.toString() +
                                    "/Alinanlar/Adet/" +
                                    x.toString())
                                .once()
                                .then((DataSnapshot snapshot) {
                              String aliananmiktar = '${snapshot.value}';
                              print("Z raporundan alinan miktar " +
                                  aliananmiktar);
                              db
                                  .child(ARACISMI.toString() +
                                      "/Urunler/" +
                                      i.toString())
                                  .update({
                                "UrunGramaj": double.parse(gram) +
                                    double.parse(aliananmiktar),
                              });
                            });

                            /* */
                          });
                        } else {
                          print("urun adet varsa X değilse");
                          print(
                              "alinanSayacUrun  " + alinanSayacUrun.toString());
                          db
                              .child(ARACISMI.toString() +
                                  "/ZRapor/" +
                                  Zsay.toString() +
                                  "/Alinanlar/Adet/" +
                                  x.toString())
                              .once()
                              .then((DataSnapshot snapshot) {
                            String adetalinan = "${snapshot.value}";
                            print("Z raporundaki Adet " + adetalinan);
                            db
                                .child(ARACISMI + "/Urunler/" + i.toString())
                                .update({
                              "UrunAdedi": double.parse(adetalinan) +
                                  double.parse(bakadet),
                            });
                          });
                        }
                      });
                    }
                  });
                }
              });
            }
          });
        }
      });
    });
  }

  Future zRaporBitir() async {
    final db = FirebaseDatabase.instance.reference();
    db.child(ARACISMI.toString() + "/ZRapor").remove();
    db.child(ARACISMI.toString() + "/ZRaporSayac/Zsayac").update({
      "sayac": 0,
    });

    Navigator.pushNamed(context, "/gunSonu");
  }

  Future<void> _showMyDialog(musteriAdi, tahs) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("DÜZENLEME YAPMAK İSTEDİĞİNİZE EMİNMİSİNİZ"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("musteri Adı : " + musteriAdi),
                Text("en son ödenen tutar : " + tahs),
                new Container(
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(30, 10, 30, 20.0),
                    child: TextField(
                      onChanged: (String yeniGirilenTutar) {
                        setState(() {
                          tutarAyarla = double.parse(yeniGirilenTutar);
                          print(tutarAyarla);
                        });
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tutur Guncelle',
                      ),
                    )),
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
              child: Text('PARA ÇIKAR'),
              onPressed: () {
                TutarAyarlaCikar(musteriAdi);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('PARA EKLE'),
              onPressed: () {
                TutarAyarlaEKleme(musteriAdi);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('İŞLEM SİLME'),
              onPressed: () {
                print(alinanlarurun);
                print(alinanlaradet);
                print(alinanlarfiyat);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

/* tum yazdığın methodlaaı sil verileri bi sefer veri tabanından çek ve bi diziye kaydet sonra diziden işlem yaptır */
  // ignore: non_constant_identifier_names
  Future TutarAyarlaEKleme(musteriAdi) async {
    final db = FirebaseDatabase.instance.reference();

    db.child("MusteriSayac/Msayac/sayac").once().then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      int sayMusteri = int.parse(a);
      for (var i = 0; i < sayMusteri; i++) {
        db
            .child("Musteriler/" + i.toString() + "/MusteriAdi")
            .once()
            .then((DataSnapshot snapshot) {
          String adiMusteri = '${snapshot.value}';
          if (adiMusteri == musteriAdi) {
            db
                .child("Musteriler/" + i.toString() + "/Cari")
                .once()
                .then((DataSnapshot snapshot) {
              String cr = '${snapshot.value}';
              double cari = double.parse(cr);
              db.child("Musteriler/" + i.toString()).update({
                "Cari": cari - tutarAyarla,
              });
            });
          }
        });
      }
    });

    db.child("MusteriTakip/Mtakip/takip").once().then((DataSnapshot snapshot) {
      String sayTa = '${snapshot.value}';
      int sayTakip = int.parse(sayTa);
      for (var i = 0; i < sayTakip; i++) {
        db
            .child("MusteriHareket/" + i.toString() + "/0/Ad")
            .once()
            .then((DataSnapshot snapshot) {
          String ad = '${snapshot.value}';
          if (ad == musteriAdi) {
            db
                .child(musteriAdi + "/Msayac/sayac")
                .once()
                .then((DataSnapshot snapshot) {
              String isimli = '${snapshot.value}';
              int isimliSay = int.parse(isimli);
              int isimliSaySonDeger = isimliSay - 1;

              db
                  .child("MusteriHareket/" +
                      i.toString() +
                      "/" +
                      isimliSaySonDeger.toString() +
                      "/Tahsilat")
                  .once()
                  .then((DataSnapshot snapshot) {
                String ths = '${snapshot.value}';
                double tahsilat = double.parse(ths);
                db
                    .child("MusteriHareket/" +
                        i.toString() +
                        "/" +
                        isimliSaySonDeger.toString())
                    .update({
                  "Tahsilat": tahsilat + tutarAyarla,
                });
              });

              db
                  .child("MusteriHareket/" +
                      i.toString() +
                      "/" +
                      isimliSaySonDeger.toString() +
                      "/SonBakiye")
                  .once()
                  .then((DataSnapshot snapshot) {
                String snbky = '${snapshot.value}';
                double sonBakiye = double.parse(snbky);
                db
                    .child("MusteriHareket/" +
                        i.toString() +
                        "/" +
                        isimliSaySonDeger.toString())
                    .update({
                  "SonBakiye": sonBakiye - tutarAyarla,
                });
              });
            });
          }
        });
      }
    });

    db
        .child(ARACISMI.toString() + "/ZRaporSayac/Zsayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      int zSay = int.parse(a);
      int zSayac = zSay - 1;
      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              zSayac.toString() +
              "/Tahsilat")
          .once()
          .then((DataSnapshot snapshot) {
        String thsl = '${snapshot.value}';
        double tahsi = double.parse(thsl);
        db.child(ARACISMI.toString() + "/ZRapor/" + zSayac.toString()).update({
          "Tahsilat": tahsi + tutarAyarla,
        });
      });
      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              zSayac.toString() +
              "/SonBakiye")
          .once()
          .then((DataSnapshot snapshot) {
        String snb = '${snapshot.value}';
        double sonBaki = double.parse(snb);
        db.child(ARACISMI.toString() + "/ZRapor/" + zSayac.toString()).update({
          "SonBakiye": sonBaki - tutarAyarla,
        });
      });
    });
    Toast.show(
        "İşleminiz Tamamlanmıştır (LÜTFEN SAYFAYI YENİLEYİNİZ) ", context,
        duration: 5, gravity: Toast.BOTTOM);
  }

  // ignore: non_constant_identifier_names
  Future TutarAyarlaCikar(musteriAdi) async {
    final db = FirebaseDatabase.instance.reference();

    db.child("MusteriSayac/Msayac/sayac").once().then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      int sayMusteri = int.parse(a);
      for (var i = 0; i < sayMusteri; i++) {
        db
            .child("Musteriler/" + i.toString() + "/MusteriAdi")
            .once()
            .then((DataSnapshot snapshot) {
          String adiMusteri = '${snapshot.value}';
          if (adiMusteri == musteriAdi) {
            db
                .child("Musteriler/" + i.toString() + "/Cari")
                .once()
                .then((DataSnapshot snapshot) {
              String cr = '${snapshot.value}';
              double cari = double.parse(cr);
              db.child("Musteriler/" + i.toString()).update({
                "Cari": cari + tutarAyarla,
              });
            });
          }
        });
      }
    });

    db.child("MusteriTakip/Mtakip/takip").once().then((DataSnapshot snapshot) {
      String sayTa = '${snapshot.value}';
      int sayTakip = int.parse(sayTa);
      for (var i = 0; i < sayTakip; i++) {
        db
            .child("MusteriHareket/" + i.toString() + "/0/Ad")
            .once()
            .then((DataSnapshot snapshot) {
          String ad = '${snapshot.value}';
          if (ad == musteriAdi) {
            db
                .child(musteriAdi + "/Msayac/sayac")
                .once()
                .then((DataSnapshot snapshot) {
              String isimli = '${snapshot.value}';
              int isimliSay = int.parse(isimli);
              int isimliSaySonDeger = isimliSay - 1;

              db
                  .child("MusteriHareket/" +
                      i.toString() +
                      "/" +
                      isimliSaySonDeger.toString() +
                      "/Tahsilat")
                  .once()
                  .then((DataSnapshot snapshot) {
                String ths = '${snapshot.value}';
                double tahsilat = double.parse(ths);
                db
                    .child("MusteriHareket/" +
                        i.toString() +
                        "/" +
                        isimliSaySonDeger.toString())
                    .update({
                  "Tahsilat": tahsilat - tutarAyarla,
                });
              });

              db
                  .child("MusteriHareket/" +
                      i.toString() +
                      "/" +
                      isimliSaySonDeger.toString() +
                      "/SonBakiye")
                  .once()
                  .then((DataSnapshot snapshot) {
                String snbky = '${snapshot.value}';
                double sonBakiye = double.parse(snbky);
                db
                    .child("MusteriHareket/" +
                        i.toString() +
                        "/" +
                        isimliSaySonDeger.toString())
                    .update({
                  "SonBakiye": sonBakiye + tutarAyarla,
                });
              });
            });
          }
        });
      }
    });

    db
        .child(ARACISMI.toString() + "/ZRaporSayac/Zsayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      int zSay = int.parse(a);
      int zSayac = zSay - 1;
      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              zSayac.toString() +
              "/Tahsilat")
          .once()
          .then((DataSnapshot snapshot) {
        String thsl = '${snapshot.value}';
        double tahsi = double.parse(thsl);
        db.child(ARACISMI.toString() + "/ZRapor/" + zSayac.toString()).update({
          "Tahsilat": tahsi - tutarAyarla,
        });
      });
      db
          .child(ARACISMI.toString() +
              "/ZRapor/" +
              zSayac.toString() +
              "/SonBakiye")
          .once()
          .then((DataSnapshot snapshot) {
        String snb = '${snapshot.value}';
        double sonBaki = double.parse(snb);
        db.child(ARACISMI.toString() + "/ZRapor/" + zSayac.toString()).update({
          "SonBakiye": sonBaki + tutarAyarla,
        });
      });
    });

    Toast.show(
        "İşleminiz Tamamlanmıştır (LÜTFEN SAYFAYI YENİLEYİNİZ) ", context,
        duration: 5, gravity: Toast.BOTTOM);
  }
}
