/*
  burda gün içinde satılan tüm ürünlerin listesi ve toplam gelir,
  hasılat(alınan paralar)
1.sayfa

  ePeşin
  kart/post
  ödeme Alınmadı
(gunluk)




2 safya
  müs adı   / tarih  / ödeme şekli / ödeme tutarı / son bakiye
  (kaylı kalacak)


 */
import 'package:beypetek/gunSonu/zRaporDetay.dart';
import 'package:flutter/material.dart';
import 'musteriTakip.dart';
import 'zRaporu.dart';

class Gunsonu extends StatefulWidget {
  @override
  _GunsonuState createState() => _GunsonuState();
}

class _GunsonuState extends State<Gunsonu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(169, 131, 7, 1),
            title: Text(
              "GÜN SONU BİLGİLERİ",
              textAlign: TextAlign.center,
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "(Z) RAPORU",
                  ),
                ),
                Tab(
                  child: Text(
                    "(Z) RAPORU DETAY",
                  ),
                ),
                Tab(
                  child: Text(
                    "MÜSTERİ HAREKETLERİ",
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            alignment: Alignment.center,
            child: TabBarView(
              children: [
                Zraporu(),
                ZraporuDetay(),
                MusteriTakip(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
