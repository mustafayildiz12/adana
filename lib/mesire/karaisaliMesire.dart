import 'package:adana/constants/constants.dart';
import 'package:adana/ilceler/karaisali/Yanikkale.dart';
import 'package:adana/ilceler/karaisali/almankoprusu.dart';
import 'package:adana/ilceler/karaisali/dokuzoluk.dart';
import 'package:adana/ilceler/karaisali/kanyon.dart';
import 'package:adana/ilceler/karaisali/karapinar.dart';
import 'package:adana/ilceler/karaisali/keciKalesi.dart';
import 'package:adana/ilceler/karaisali/kesireHan.dart';
import 'package:adana/ilceler/karaisali/kizildagYaylasi.dart';
import 'package:adana/ilceler/karaisali/yerkopru.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KaraisaliMesireList extends StatefulWidget {
  const KaraisaliMesireList({Key? key}) : super(key: key);

  @override
  _KaraisaliMesireListState createState() => _KaraisaliMesireListState();
}

class _KaraisaliMesireListState extends State<KaraisaliMesireList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              InkWell(
                  onTap: () {
                    Get.to(() => Karapinar());
                  },
                  child: sehirler("KARAPINAR PARKI")),
              InkWell(
                  onTap: ()
                  {
                    Get.to(() => Dokuzoluk());
                  },
                  child: sehirler("DOKUZOLUK")),
              InkWell(

                onTap: ()
                  {
                    Get.to( () => YerKopru());
                  },

                  child: sehirler("YERKÖPRÜ")),
              InkWell(
                  onTap: ()
                  {
                    Get.to( () => AlmanKoprusu());
                  },
                  child: sehirler("ALMAN KÖPRÜSÜ")),
              InkWell(
                  onTap: ()
                  {
                    Get.to( () => Kanyon());
                  },
                  child: sehirler("KAPIKAYA KANYONU")),
              InkWell(
                  onTap: ()
                  {
                    Get.to( () => Kizildag());
                  },
                  child: sehirler("KIZILDAĞ YAYLASI")),
              InkWell(
                  onTap: ()
                  {
                    Get.to( () => KesireHan());
                  },
                  child: sehirler("KESİRİ HAN")),
              InkWell(
                  onTap: ()
                  {
                    Get.to(() => KeciKalesi());
                  },
                  child: sehirler("KEÇİ KALESİ")),
              InkWell(
                  onTap: ()
                  {
                    Get.to( () => YanikKale());
                  },
                  child: sehirler("YANIKKALE")),

            ],
          ),
        ),
      ),
    );
  }

  Widget sehirler(String text) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                text,
                style: cityName,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: scaffold,
          border: Border.all(color: Colors.blueAccent.shade100, width: 4),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}
