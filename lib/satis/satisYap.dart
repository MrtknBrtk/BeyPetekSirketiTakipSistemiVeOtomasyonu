// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';
import '../aracIsim.dart';
import 'sepet.dart';

class SatisYap extends StatefulWidget {
  @override
  _SatisYapState createState() => _SatisYapState();
}

final TextEditingController _controller = new TextEditingController();
final TextEditingController _controller1 = new TextEditingController();

class _SatisYapState extends State<SatisYap> {
  // ignore: non_constant_identifier_names
  double toplami = 0.00, adet = 0, fiyat = 0;
  String gelenadet = "", gelengram = "";
  String secilenUrun = "";
  int sayac2;
  var diziUrun = [];
  int sira;
  final List<DropdownMenuItem> itemsUrunler = [];

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
            verisor();
          });
        },
        isExpanded: true,
      ),
    };
    void toplamKac() {
      setState(() {
        toplami = adet * fiyat;
      });
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //urunler listesi
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

            //Adet
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String adt) {
                    setState(() {
                      adet = double.parse(adt);
                      toplamKac();
                    });
                  },
                  obscureText: false,
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ADET / GRAMAJ',
                  ),
                )),
            //Fiyat
            new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: TextField(
                  keyboardType:
                      TextInputType.number, //bu sadece numara sayısallar için
                  onChanged: (String fyt) {
                    setState(() {
                      fiyat = double.parse(fyt);
                      toplamKac();
                    });
                  },
                  controller: _controller1,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'FİYAT',
                  ),
                )),
            //Gram
            new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "TOPLAM",
                    style: TextStyle(fontSize: 20),
                  ),
                  new Container(
                    width: 200,
                    child: Text(
                      "$toplami",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: 30),
            ),

            //ekleme buttonları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                      setState(() {
                        if (gelenadet == "" || gelengram == "") {
                          Toast.show("ÜRÜN SEÇMEDİNİZ", context,
                              duration: 5, gravity: Toast.BOTTOM);
                        } else {
                          if (gelenadet == "X") {
                            if (secilenUrun == null ||
                                secilenUrun == "" ||
                                adet == null ||
                                adet == 0 ||
                                fiyat == 0 ||
                                fiyat == null) {
                              Toast.show("BOŞ DEĞER KALMIŞTIR ", context,
                                  duration: 5, gravity: Toast.BOTTOM);
                            } else {
                              bool sor = false;

                              for (var i = 0; i < DiziUrunAdi.length; i++) {
                                if (DiziUrunAdi[i] == secilenUrun) {
                                  sor = true;
                                  sira = i;
                                }
                              }
                              if (sor == true) {
                                _showMyDialog();
                              } else {
                                if (double.parse(gelengram) >= adet) {
                                  DiziUrunAdi.add(secilenUrun);
                                  DIZIADET.add(adet);
                                  DiziFiyat.add(fiyat);
                                  DiziToplam.add(toplami);

                                  _controller.clear();
                                  _controller1.clear();
                                  toplami = 0.00;
                                  adet = 0;
                                  fiyat = 0;
                                  Toast.show(
                                      "ÜRÜN SEPETE EKLENMİŞTİR ", context,
                                      duration: 5, gravity: Toast.BOTTOM);
                                } else {
                                  Toast.show(
                                      "ÜRÜNÜNÜN GRAMAJINI FAZLA GİRDİNİZ ",
                                      context,
                                      duration: 5,
                                      gravity: Toast.BOTTOM);
                                }
                              }
                            }
                          } else {
                            if (secilenUrun == null ||
                                secilenUrun == "" ||
                                adet == null ||
                                adet == 0 ||
                                fiyat == 0 ||
                                fiyat == null) {
                              Toast.show("BOŞ DEĞER KALMIŞTIR ", context,
                                  duration: 5, gravity: Toast.BOTTOM);
                            } else {
                              bool sor = false;

                              for (var i = 0; i < DiziUrunAdi.length; i++) {
                                if (DiziUrunAdi[i] == secilenUrun) {
                                  sor = true;
                                  sira = i;
                                }
                              }
                              if (sor == true) {
                                _showMyDialog();
                              } else {
                                if (double.parse(gelenadet) >= adet) {
                                  DiziUrunAdi.add(secilenUrun);
                                  DIZIADET.add(adet);
                                  DiziFiyat.add(fiyat);
                                  DiziToplam.add(toplami);

                                  _controller.clear();
                                  _controller1.clear();
                                  toplami = 0.00;
                                  adet = 0;
                                  fiyat = 0;
                                  Toast.show(
                                      "ÜRÜN SEPETE EKLENMİŞTİR ", context,
                                      duration: 5, gravity: Toast.BOTTOM);
                                } else {
                                  Toast.show("ÜRÜNÜNÜN ADEDİNİ FAZLA GİRDİNİZ ",
                                      context,
                                      duration: 5, gravity: Toast.BOTTOM);
                                }
                              }
                            }
                          }
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
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
          title: Text("BU ÜRÜNÜ EKLEMİŞTİNİZ!!! SADECE ADEDET ARTTIRIYORSUNUZ"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("urun adı  ( " + secilenUrun + " )  olan urunden "),
                Text("bu kadar miktar  ( " +
                    adet.toString() +
                    " ) ekliyorsunuz"),
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
              child: Text('EKLE'),
              onPressed: () {
                if (gelenadet == "X") {
                  if (double.parse(gelengram) >= adet + DIZIADET[sira]) {
                    DiziUrunAdi[sira] = secilenUrun;
                    DIZIADET[sira] = DIZIADET[sira] + adet;
                    DiziToplam[sira] =
                        DiziToplam[sira] + (adet * DiziFiyat[sira]);
                    _controller.clear();
                    _controller1.clear();
                    toplami = 0.00;
                    adet = 0;
                    fiyat = 0;
                    Toast.show(
                        "SEPETTEKİ ÜRÜN MİKTARI ARTTIRILMIŞTIR ", context,
                        duration: 5, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    Toast.show(
                        "SEPETTEKİ ÜRÜN ARTTIRALAMAMIŞTIR ELİNDEKİ ÜRÜNDEN FAZLA GİRDİNİZ ",
                        context,
                        duration: 5,
                        gravity: Toast.BOTTOM);
                  }
                } else {
                  if (double.parse(gelenadet) >= adet + DIZIADET[sira]) {
                    DiziUrunAdi[sira] = secilenUrun;
                    DIZIADET[sira] = DIZIADET[sira] + adet;
                    DiziToplam[sira] =
                        DiziToplam[sira] + (adet * DiziFiyat[sira]);
                    _controller.clear();
                    _controller1.clear();
                    toplami = 0.00;
                    adet = 0;
                    fiyat = 0;
                    Toast.show(
                        "SEPETTEKİ ÜRÜN MİKTARI ARTTIRILMIŞTIR ", context,
                        duration: 5, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    Toast.show(
                        "SEPETTEKİ ÜRÜN ARTTIRALAMAMIŞTIR ELİNDEKİ ÜRÜNDEN FAZLA GİRDİNİZ ",
                        context,
                        duration: 5,
                        gravity: Toast.BOTTOM);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future verisor() async {
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
                  gelenadet = adt;
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
                  gelengram = grm;
                });
              });
            }
          });
        }
      });
    });
  }
}
