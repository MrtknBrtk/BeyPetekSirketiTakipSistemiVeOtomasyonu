import 'package:beypetek/aracStok/aracUrunGuncelleme.dart';
import 'package:flutter/material.dart';

import 'aracBilgisi.dart';
import 'aracEkleme.dart';

class AracStok extends StatefulWidget {
  @override
  _AracStokState createState() => _AracStokState();
}

class _AracStokState extends State<AracStok> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(169, 131, 7, 1),
            title: Text(
              "ARAÇ STOK",
              textAlign: TextAlign.center,
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "ARAÇ BİLGİSİ",
                  ),
                ),
                Tab(
                  child: Text(
                    "ÜRÜN EKLEME",
                  ),
                ),
                Tab(
                  child: Text(
                    "ÜRÜN GUNCELLEME",
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            alignment: Alignment.center,
            child: TabBarView(
              children: [
                AracBilgisi(),
                AracEkleme(),
                AracUrunGuncelleme(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
