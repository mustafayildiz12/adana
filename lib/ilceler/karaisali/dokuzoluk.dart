import 'package:adana/components/buttonText.dart';
import 'package:adana/components/infoText.dart';
import 'package:adana/components/mainAppBar.dart';
import 'package:adana/components/sliderImage.dart';
import 'package:adana/constants/constants.dart';
import 'package:adana/ilceler/karaisali/yorumlar/dokuzoluk.dart';
import 'package:adana/map/map.dart';
import 'package:adana/map/mapUtils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';

late User loggedInuser;
var now = new DateTime.now();
var formatter = new DateFormat('dd-MM-yyyy');
String formattedDate = formatter.format(now);

class Dokuzoluk extends StatefulWidget {
  const Dokuzoluk({Key? key}) : super(key: key);

  @override
  _DokuzolukState createState() => _DokuzolukState();
}

class _DokuzolukState extends State<Dokuzoluk>
    with SingleTickerProviderStateMixin {
  double x = 37.387938;
  double y = 35.209563;
  String title = "Dokuzoluk";
  FirebaseAuth auth = FirebaseAuth.instance;
  late TabController tabController;
  void initState() {
    super.initState();
    getCurrentUser();
    tabController = TabController(length: 6, vsync: this);
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      loggedInuser = user;
    }
  }

  static List<String> links = [
    "https://media-cdn.tripadvisor.com/media/photo-s/0c/f9/48/fc/muhtesem-manzara.jpg",
    "https://seyyahdefteri.com/wp-content/uploads/2019/05/dokuzoluk-piknik-alani-4.jpg",
    "https://seyyahdefteri.com/wp-content/uploads/2019/05/Dokuzoluk-Piknik-Alani.png",
    "https://www.serpmekahvalti.com/wp-content/uploads/2020/10/143024851_zrISGdG19Jvo7DCZjabGE1XEC3JfkyPmRrJTVCGGi64.jpg",
    "https://www.kampusulasi.com/wp-content/uploads/2021/03/Dokuzoluk-1-1080x738.jpg",
    "https://foto.haberler.com/haber/2013/08/01/doga-harikasi-dokuzoluk-2-4895535_o.jpg",
  ];

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      title: title,
      commentHint: "...",
      message: 'Dokuzoluk hakk??nda ne d??????n??yorsunuz',
      image: Image.asset(
        "assets/karaisali/dokuzoluk/d5.jpg",
        height: 100,
      ),
      submitButton: 'G??nder',
      onCancelled: () {},
      onSubmitted: (response) {
        FirebaseFirestore.instance
            .collection("dokuzolukYorum")
            .doc(loggedInuser.email)
            .set({
          "zaman": formattedDate.toString(),
          'email': loggedInuser.email.toString(),
          'icerik': response.comment.toString(),
          'puan': response.rating.toDouble()
        });
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kutu,
      appBar: mainAppBar(title),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              sliderImage(
                context,
                links,
              ),

              SizedBox(
                height: 10,
              ),
              infoText(
                  "Dokuzoluk piknik alan?? bir kanyonun hemen kenar??nda ??e??itli "
                  "noktalardan f????k??ran p??narlar, yemye??il bitki ??rt??s?? ve"
                  " ziyaret??ilerin buz gibi suyunda serinledikleri g??letlerden"
                  " olu??maktad??r. Piknik yapmak, y??zmek, bal??k tutmak,"
                  " y??r??y???? yapmak, foto??raf ??ekmek burada ger??ekle??tirilebilecek"
                  " aktiviteler aras??ndad??r. K??pr??n??n ??zerinden kanyon manzaras??n??n "
                  "foto??raf??n??n ??ekilmesi tavsiye edilir."
                  "Dokuzoluk???ta ziyaret??ilerin piknik i??in kullanabilecekleri "
                  "masalar, kamelyalar, mangal alanlar??, mescit, ??e??me ve tuvaletler"
                  " bulunmaktad??r. Giri?? ??creti 10 TL???dir. ??zellikle Adana???n??n "
                  "s??ca????ndan uzakla??mak, farkl?? ve dinlendirici bir do??a harikas??nda"
                  " g??n??n?? ge??irmek isteyenler taraf??ndan tercih edilmektedir."),
              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_circle_up,color: Colors.black,size: 40,),
                    onPressed: ()
                    {
                      Get.bottomSheet(
                          buildSheet(),
                          barrierColor: Colors.white.withOpacity(0.6),
                          isScrollControlled: false

                      );
                    },

                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
  Widget buildSheet()
  {
    return Container(
      color: kutu,
      child: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Get.to(() => Maps(), arguments:[ x,y,title]);
              },
              child: buttonTextContainer(context, "HAR??TADA G??STER")),
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Get.to(() => DokuzolukYorum());
              },
              child: buttonTextContainer(context, "YORUMLARI G??STER")),

          //xd
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                MapUtils.openMap(x, y);
              },
              child: buttonTextContainer(context, "YOL TAR??F??")),
          SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {
              _showRatingAppDialog();
            },
            child: buttonTextContainer(context, "YORUM YAP"),
          ),
          IconButton(
            icon: Icon(Icons.cancel_sharp,size: 25,color: Colors.grey,),
            onPressed: ()
            {
              Get.back();
            },

          )
        ],
      ),
    );
  }

}

