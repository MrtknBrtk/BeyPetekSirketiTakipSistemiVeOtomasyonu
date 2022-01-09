import 'package:beypetek/aracSec.dart';
import 'package:beypetek/gunSonu/zRaporu.dart';
import 'package:beypetek/musteri/musteriAnaSayfa.dart';
import 'package:flutter/material.dart';
import 'IlkGiris.dart';
import 'aracStok/AracStok.dart';
import 'satis/Satis.dart';
import 'gunSonu/gunSonu.dart';
import 'musteriCari.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => AracSec(),
        "/IlkGiris": (context) => IlkGiris(), //context uygulamanın merkezi
        "/AracStok": (context) => AracStok(),
        "/satis": (context) => Satis(),
        "/musteriAnaSayfa": (context) => MusteriAnasayfa(),
        "/gunSonu": (context) => Gunsonu(),
        "/zRaporu": (context) => Zraporu(),
        "/musteriCari": (context) => MusteriCari(),
      },
    ),
  );
}
