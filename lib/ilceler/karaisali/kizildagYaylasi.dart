import 'package:adana/components/buttonText.dart';
import 'package:adana/components/infoText.dart';
import 'package:adana/components/mainAppBar.dart';
import 'package:adana/components/sliderImage.dart';
import 'package:adana/constants/constants.dart';
import 'package:adana/ilceler/karaisali/yorumlar/kizildag.dart';
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

class Kizildag extends StatefulWidget {
  const Kizildag({Key? key}) : super(key: key);

  @override
  _KizildagState createState() => _KizildagState();
}

class _KizildagState extends State<Kizildag>
    with SingleTickerProviderStateMixin {
  double x = 37.412784;
  double y = 35.041947;
  String title = "Kızıldağ Yaylası";
  FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
    tabController = TabController(length: 6, vsync: this);
  }

  TabController? tabController;

  static List<String> links = [
    "https://im.haberturk.com/yerel_haber/2019/02/20/ver1550650922/66985381_620x410.jpg",
    "https://mapio.net/images-p/20739718.jpg",
    "http://2.bp.blogspot.com/-wc7x9hcUpl0/VGPwBcZxYZI/AAAAAAAAKG8/Nu8sZIL4ufI/s1600/kizildag-yaylasinin-karli-gorunumu.jpg",
    "https://www.tatilcity.net/wp-content/uploads/2019/10/kizildag-yaylasi.jpg",
    "https://www.kulturportali.gov.tr/repoKulturPortali/large/04042013/22b98a39-0b76-46c7-b117-46b7c1ba186b.jpg?format=jpg&quality=50",
    "https://i.pinimg.com/originals/b1/06/07/b10607e7da144d1f0fd8e86aef4c44c9.jpg",
  ];

  void getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      loggedInuser = user;
    }
  }

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      title: title,
      commentHint: "...",
      message: 'Yerköprü hakkında ne düşünüyorsunuz',
      image: Image.asset(
        "assets/karaisali/kizildag/k3.jpg",
        height: 100,
      ),
      submitButton: 'Gönder',
      onCancelled: () {},
      onSubmitted: (response) {
        FirebaseFirestore.instance
            .collection("kizildagYorum")
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
              infoText("Adını Kızıldağ’dan alan yayla Karaisalı İlçesi’ne "
                  "27 kilometre mesafededir. Karaisalı İlçesi halkının"
                  " yoğun olarak rağbet ettiği Kızıldağ Yaylası'nda "
                  "kır kahveleri, kır lokantaları, bakkallar, fırınlar"
                  " ve kasaplar hizmet vermektedir. Elma, "
                  "armut, kiraz, vişne ve ceviz ağaçları ile iç içe olan yaylada kamp "
                  "kurarak Kızıldağ’da yürüyüş yapılabilir, yaban "
                  "hayatı incelenerek fotoğraf çekilebilir."),
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
              child: buttonTextContainer(context, "HARİTADA GÖSTER")),
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Get.to(() => KizildagYorum());
              },
              child: buttonTextContainer(context, "YORUMLARI GÖSTER")),

          //xd
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                MapUtils.openMap(x, y);
              },
              child: buttonTextContainer(context, "YOL TARİFİ")),
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
