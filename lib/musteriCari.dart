import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:widget_loading/widget_loading.dart';

class MusteriCari extends StatefulWidget {
  @override
  _MusteriCariState createState() => _MusteriCariState();
}

// ignore: non_constant_identifier_names
final List<dynamic> MADI = [];

class _MusteriCariState extends State<MusteriCari> {
  int sayac;

  final List<String> mbakiye = [];
  final List<String> dAdi = [];
  Future future = Future.delayed(Duration(seconds: 3));

  StreamSubscription _subscription;
  bool loading = true;
  @override
  void initState() {
    _subscription = Stream.periodic(Duration(seconds: 3)).listen((i) {
      setState(() {
        loading = false;
      });
    });
    setState(() {
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
            setState(() {
              String b = '${snapshot.value}';
              MADI.add(b);
            });
          });
        }
        for (var m = 0; m < sayac; m++) {
          db
              .child("Musteriler/" + m.toString() + "/Cari")
              .once()
              .then((DataSnapshot snapshot) {
            setState(() {
              String c = '${snapshot.value}';
              mbakiye.add(c);
            });
          });
        }
        for (var z = 0; z < sayac; z++) {
          db
              .child("Musteriler/" + z.toString() + "/DukkanAdi")
              .once()
              .then((DataSnapshot snapshot) {
            setState(() {
              String d = '${snapshot.value}';
              dAdi.add(d);
            });
          });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }

  //müsteri arama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(169, 131, 7, 1),
          title: Text(
            "MÜSTERİ CARİ BİLGİSİ",
            textAlign: TextAlign.center,
          ),
        ),
        body: Center(
            child: CircularWidgetLoading(
          dotColor: Colors.blueGrey,
          padding: EdgeInsets.zero,
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: double.minPositive,
                showBottomBorder: true,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'MÜSTERİ ADI',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'DÜKKAN ADİ',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'BAKİYESİ',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: [
                  for (int i = 0; i < sayac; i++) //burda bi hata var

                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text(MADI[i])),
                        DataCell(Text(dAdi[i])),
                        DataCell(
                          Text(mbakiye[i]),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          loading: loading,
        )));
  }
}
