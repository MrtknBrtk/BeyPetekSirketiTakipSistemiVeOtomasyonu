import 'package:firebase_database/firebase_database.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class MusteriTakip extends StatefulWidget {
  @override
  _MusteriTakipState createState() => _MusteriTakipState();
}

class _MusteriTakipState extends State<MusteriTakip> {
  var diziUrun = [];
  var odemeSekli = [];
  var sonBakiye = [];
  var tahsilat = [];
  var tarih = [];
  var toplamAlinan = [];
  final List<DropdownMenuItem> itemsMusteriler = [];
  int sayacIsim = 0;
  String secilenUrun = "";
  int sayac2;
  @override
  void initState() {
    setState(() {
      final db = FirebaseDatabase.instance.reference();

      db
          .child("MusteriTakip/Mtakip/takip")
          .once()
          .then((DataSnapshot snapshot) {
        String c = '${snapshot.value}';
        sayac2 = int.parse(c);
        for (var i = 0; i < sayac2; i++) {
          db
              .child("MusteriHareket/" + i.toString() + "/0/Ad")
              .once()
              .then((DataSnapshot snapshot) {
            String b = '${snapshot.value}';
            setState(() {
              diziUrun.add(b);
              itemsMusteriler.add(DropdownMenuItem(
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

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> urunler;
    urunler = {
      "Müsteri Hareket": SearchableDropdown.single(
        items: itemsMusteriler,
        value: secilenUrun,
        hint: "İşlem Yapmış Müsteriler",
        searchHint: "Müşteri Seçiniz",
        onChanged: (value) {
          setState(() {
            secilenUrun = value;
            veriCek();
          });
        },
        isExpanded: true,
      ),
    };

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
            ),
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
            DataTable(
              columnSpacing: double.minPositive + 10,
              showBottomBorder: true,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    '(AY/GÜN/YIL)',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ÖDEME ŞEKLİ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'TUTAR',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'TAHSİLAT',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'SON BAKİYE',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                  ),
                ),
              ],
              rows: [
                for (int i = 0; i < sayacIsim; i++) //burda bi hata var

                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                        tarih[i],
                      )),
                      DataCell(
                        Text(odemeSekli[i]),
                      ),
                      DataCell(
                        Text(toplamAlinan[i]),
                      ),
                      DataCell(
                        Text(tahsilat[i]),
                      ),
                      DataCell(
                        Text(sonBakiye[i]),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future veriCek() async {
    final db = FirebaseDatabase.instance.reference();

    db
        .child(secilenUrun + "/Msayac/sayac")
        .once()
        .then((DataSnapshot snapshot) {
      String a = '${snapshot.value}';
      setState(() {
        sayacIsim = int.parse(a);
      });
      for (var i = 0; i < diziUrun.length; i++) {
        if (diziUrun[i] == secilenUrun) {
          tahsilat.clear();
          odemeSekli.clear();
          tarih.clear();
          toplamAlinan.clear();
          sonBakiye.clear();
          for (var x = 0; x < sayacIsim; x++) {
            db
                .child("MusteriHareket/" +
                    i.toString() +
                    "/" +
                    x.toString() +
                    "/Tarih")
                .once()
                .then((DataSnapshot snapshot) {
              setState(() {
                String trh = '${snapshot.value}';
                tarih.add(trh);
              });
            });
            db
                .child("MusteriHareket/" +
                    i.toString() +
                    "/" +
                    x.toString() +
                    "/OdemeSekli")
                .once()
                .then((DataSnapshot snapshot) {
              setState(() {
                String odmSkl = '${snapshot.value}';
                odemeSekli.add(odmSkl);
              });
            });
            db
                .child("MusteriHareket/" +
                    i.toString() +
                    "/" +
                    x.toString() +
                    "/ToplamAlinan")
                .once()
                .then((DataSnapshot snapshot) {
              setState(() {
                String tplAlnn = '${snapshot.value}';
                toplamAlinan.add(tplAlnn);
              });
            });
            db
                .child("MusteriHareket/" +
                    i.toString() +
                    "/" +
                    x.toString() +
                    "/Tahsilat")
                .once()
                .then((DataSnapshot snapshot) {
              setState(() {
                String thslt = '${snapshot.value}';

                tahsilat.add(thslt);
              });
            });
            db
                .child("MusteriHareket/" +
                    i.toString() +
                    "/" +
                    x.toString() +
                    "/SonBakiye")
                .once()
                .then((DataSnapshot snapshot) {
              setState(() {
                String snBky = '${snapshot.value}';
                sonBakiye.add(snBky);
              });
            });
          }
        }
      }
    });
  }
}
