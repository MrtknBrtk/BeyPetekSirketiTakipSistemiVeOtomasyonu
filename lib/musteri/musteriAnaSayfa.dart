import 'package:beypetek/musteri/musteriDuzenle.dart';
import 'package:beypetek/musteri/musteriEkle.dart';
import 'package:flutter/material.dart';

class MusteriAnasayfa extends StatefulWidget {
  @override
  _MusteriAnasayfaState createState() => _MusteriAnasayfaState();
}

class _MusteriAnasayfaState extends State<MusteriAnasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(169, 131, 7, 1),
            title: Text(
              "MÜSTERİ BİLGİLERİ",
              textAlign: TextAlign.center,
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Musteri Ekle",
                  ),
                ),
                Tab(
                  child: Text(
                    "MÜSTERİ Güncelle",
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            alignment: Alignment.center,
            child: TabBarView(
              children: [MusteriEkle(), MusteriDuzenle()],
            ),
          ),
        ),
      ),
    );
  }
}
