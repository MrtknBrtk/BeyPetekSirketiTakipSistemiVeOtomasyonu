import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:widget_loading/widget_loading.dart';

import '../aracIsim.dart';

class AracBilgisi extends StatefulWidget {
  @override
  _AracBilgisiState createState() => _AracBilgisiState();
}

class _AracBilgisiState extends State<AracBilgisi> {
  int urunadedi;

  final List<String> diziUrunIsimleri = [];
  final List<String> diziUrunAdetleri = [];
  final List<String> diziUrunFiyatlari = [];
  final List<String> diziUrunGramlari = [];
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
          .child(ARACISMI.toString() + "/UrunSayac/Usayac/sayac")
          .once()
          .then((DataSnapshot snapshot) {
        String x = '${snapshot.value}';
        urunadedi = int.parse(x);
        for (var x = 0; x < urunadedi; x++) {
          db
              .child(
                  ARACISMI.toString() + "/Urunler/" + x.toString() + "/UrunAdi")
              .once()
              .then((DataSnapshot snapshot) {
            String a = '${snapshot.value}';
            setState(() {
              diziUrunIsimleri.add(a);
              // diziUrunIsimleri2 = diziUrunIsimleri;
            });
          });
        }

        for (var y = 0; y < urunadedi; y++) {
          db
              .child(ARACISMI.toString() +
                  "/Urunler/" +
                  y.toString() +
                  "/UrunAdedi")
              .once()
              .then((DataSnapshot snapshot) {
            String b = '${snapshot.value}';
            setState(() {
              diziUrunAdetleri.add(b);
              // diziUrunAdetleri2 = diziUrunAdetleri;
            });
          });
        }

        for (var z = 0; z < urunadedi; z++) {
          db
              .child(ARACISMI.toString() +
                  "/Urunler/" +
                  z.toString() +
                  "/UrunFiyati")
              .once()
              .then((DataSnapshot snapshot) {
            String c = '${snapshot.value}';
            setState(() {
              diziUrunFiyatlari.add(c);
              // diziUrunFiyatlari2 = diziUrunFiyatlari;
            });
          });
        }

        for (var m = 0; m < urunadedi; m++) {
          db
              .child(ARACISMI.toString() +
                  "/Urunler/" +
                  m.toString() +
                  "/UrunGramaj")
              .once()
              .then((DataSnapshot snapshot) {
            String d = '${snapshot.value}';

            setState(() {
              diziUrunGramlari.add(d);
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
          child: DataTable(
            columnSpacing: double.minPositive,
            showBottomBorder: true,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'ÜRÜN-ADI',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'ADET',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'FİYAT',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'GRAMAJ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: [
              for (int i = 0; i < urunadedi; i++) //burda bi hata var

                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(diziUrunIsimleri[i])),
                    DataCell(Text(diziUrunAdetleri[i])),
                    DataCell(Text(diziUrunFiyatlari[i])),
                    DataCell(Text(diziUrunGramlari[i])),
                  ],
                ),
            ],
          ),
        ),
      ),
      loading: loading,
    ));

    /*Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: double.minPositive,
          showBottomBorder: true,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'ÜRÜN-ADI',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'ADET',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'FİYAT',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'GRAMAJ',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: [
            for (int i = 0; i < urunadedi; i++) //burda bi hata var

              DataRow(
                cells: <DataCell>[
                  DataCell(Text(diziUrunIsimleri[i])),
                  DataCell(Text(diziUrunAdetleri[i])),
                  DataCell(Text(diziUrunFiyatlari[i])),
                  DataCell(Text(diziUrunGramlari[i])),
                ],
              ),
          ],
        ),
      ),
    );*/
  }
}
