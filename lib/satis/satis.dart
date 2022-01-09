import 'package:flutter/material.dart';
import 'satisYap.dart';
import 'sepet.dart';

class Satis extends StatefulWidget {
  @override
  _SatisState createState() => _SatisState();
}

class _SatisState extends State<Satis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(169, 131, 7, 1),
            title: Text(
              "ARAÇ SATIŞ",
              textAlign: TextAlign.center,
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "SATIŞ YAP",
                  ),
                ),
                Tab(
                  child: Text(
                    "SEPET",
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            alignment: Alignment.center,
            child: TabBarView(
              children: [
                SatisYap(),
                Sepet(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
