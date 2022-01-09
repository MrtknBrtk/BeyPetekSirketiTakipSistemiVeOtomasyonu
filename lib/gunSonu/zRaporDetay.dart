import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:widget_loading/widget_loading.dart';

import '../aracIsim.dart';

class ZraporuDetay extends StatefulWidget {
  @override
  _ZraporuDetayState createState() => _ZraporuDetayState();
}

var odemedizi = [];

/*
  kişi adı
  ödeme şekli
  tahsilat
  tarih

 */
class _ZraporuDetayState extends State<ZraporuDetay> {
  int sayacZrapor, sayacZrapor2, toplam = 0, den = 0;

  List kisiAdiDizi = [];
  List toplamAlinanUrunler = [];
  List toplamAlinanAdetler = [];
  List toplamAlinanFiyatlar = [];
  List alinanlarUrunler = [];
  List alinanlarFiyat = [];
  List alinanlarAdet = [];
  List alinanSayaclar = [];
  List alinanSayaclar2 = [0];

  Future future = Future.delayed(Duration(seconds: 3));

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
      }
      for (var i = 0; i < sayacZrapor; i++) {
        db
            .child(ARACISMI.toString() +
                "/ZRapor/" +
                i.toString() +
                "/Alinanlar/Sayac")
            .once()
            .then((DataSnapshot snapshot) {
          String a = '${snapshot.value}';
          int alinanSayac = int.parse(a);
          setState(() {
            alinanSayaclar.add(alinanSayac);
          });

          for (var f = 0; f < alinanSayac; f++) {
            db
                .child(ARACISMI.toString() +
                    "/ZRapor/" +
                    i.toString() +
                    "/Alinanlar/Urunler/" +
                    f.toString())
                .once()
                .then((DataSnapshot snapshot) {
              String urun = '${snapshot.value}';
              alinanlarUrunler.add(urun);
            });

            db
                .child(ARACISMI.toString() +
                    "/ZRapor/" +
                    i.toString() +
                    "/Alinanlar/Fiyatlar/" +
                    f.toString())
                .once()
                .then((DataSnapshot snapshot) {
              String fiyatlar = '${snapshot.value}';
              alinanlarFiyat.add(fiyatlar);
            });
            db
                .child(ARACISMI.toString() +
                    "/ZRapor/" +
                    i.toString() +
                    "/Alinanlar/Adet/" +
                    f.toString())
                .once()
                .then((DataSnapshot snapshot) {
              String adetler = '${snapshot.value}';
              alinanlarAdet.add(adetler);
            });
          }

          while (den < alinanSayaclar.length) {
            toplam = alinanSayaclar[den] + toplam;
            setState(() {
              alinanSayaclar2.add(toplam);
            });

            den++;
          }
        });
      }
    });
  }

  Future toplamUrun() async {
    final db = FirebaseDatabase.instance.reference();
    db
        .child(ARACISMI.toString() + "/ZRaporSayac/Zsayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      sayacZrapor2 = int.parse(a);

      for (var i = 0; i < sayacZrapor2; i++) {
        db
            .child(ARACISMI.toString() +
                "/ZRapor/" +
                i.toString() +
                "/Alinanlar/Sayac")
            .once()
            .then((DataSnapshot snapshot) {
          String a = '${snapshot.value}';
          int alinanSayac = int.parse(a);

          for (var f = 0; f < alinanSayac; f++) {
            int dnm;
            db
                .child(ARACISMI.toString() +
                    "/ZRapor/" +
                    i.toString() +
                    "/Alinanlar/Urunler/" +
                    f.toString())
                .once()
                .then((DataSnapshot snapshot) {
              String urun = '${snapshot.value}';

              dnm = toplamAlinanUrunler.indexOf(urun);
              if (dnm == -1) {
                toplamAlinanUrunler.add(urun);
                db
                    .child(ARACISMI.toString() +
                        "/ZRapor/" +
                        i.toString() +
                        "/Alinanlar/Adet/" +
                        f.toString())
                    .once()
                    .then((DataSnapshot snapshot) {
                  String adt = '${snapshot.value}';
                  toplamAlinanAdetler.add(adt);
                });
              } else {
                db
                    .child(ARACISMI.toString() +
                        "/ZRapor/" +
                        i.toString() +
                        "/Alinanlar/Adet/" +
                        f.toString())
                    .once()
                    .then((DataSnapshot snapshot) {
                  String adte = '${snapshot.value}';
                  int b = int.parse(toplamAlinanAdetler[dnm]) + int.parse(adte);
                  toplamAlinanAdetler[dnm] = b.toString();
                });
              }
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    _subscription = Stream.periodic(Duration(seconds: 3)).listen((i) {
      setState(() {
        loading = false;
      });
    });

    setState(() {
      listeleme();
      toplamUrun();
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }

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
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                color: Colors.grey[350],
                width: double.maxFinite,
                child: DataTable(
                  columnSpacing: double.minPositive + 10,
                  showBottomBorder: true,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'URUN ADİ',
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'TOPLAM URUN ADEDİ',
                      ),
                    ),
                  ],
                  rows: [
                    for (int g = 0; g < toplamAlinanUrunler.length; g++)
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            toplamAlinanUrunler[g],
                          )),
                          DataCell(Text(toplamAlinanAdetler[g])),
                        ],
                      ),
                  ],
                ),
              ),
              for (var i = 0; i < sayacZrapor; i++)
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[350],
                  width: double.maxFinite,
                  child: Column(
                    children: <Widget>[
                      Text(
                        kisiAdiDizi[i],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                      DataTable(
                        columnSpacing: double.minPositive + 10,
                        showBottomBorder: true,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'URUN ADİ',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'FİYAT',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'ADET/GRAMAJ',
                            ),
                          ),
                        ],
                        rows: [
                          for (int y = alinanSayaclar2[i];
                              y < alinanSayaclar2[i + 1];
                              y++)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  alinanlarUrunler[y],
                                )),
                                DataCell(Text(alinanlarFiyat[y])),
                                DataCell(
                                  Text(alinanlarAdet[y]),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      loading: loading,
    ));
  }
}
