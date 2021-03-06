import 'package:adana/components/buttonText.dart';
import 'package:adana/components/infoText.dart';
import 'package:adana/components/mainAppBar.dart';
import 'package:adana/components/sliderImage.dart';
import 'package:adana/constants/constants.dart';
import 'package:adana/ilceler/ceyhan/yorumlar/tumluYorum.dart';
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

class Tumlu extends StatefulWidget {
  const Tumlu({Key? key}) : super(key: key);

  @override
  _TumluState createState() => _TumluState();
}

class _TumluState extends State<Tumlu>
    with SingleTickerProviderStateMixin {
  double x = 37.1504089;
  double y = 35.7005395;
  String title = "Tumlu Kalesi";
  FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
    tabController = TabController(length: 4, vsync: this);
  }

  void getCurrentUser() {

    final user = auth.currentUser;
    if (user != null) {
      loggedInuser = user;
    }
  }

  TabController? tabController;

  static List<String> links = [
    "https://i.ytimg.com/vi/j7X7jPTfIjc/maxresdefault.jpg",
    "https://fastly.4sqi.net/img/general/200x200/134963895_uK3ormhfylwva4IG_I2Kd_pDksY7GVvgsbh186Q89uc.jpg",
    "https://www.kulturportali.gov.tr/repoKulturPortali/small/07052015/ff8bbd7b-f76a-4a58-bb8e-901349301168.jpg?format=jpg&quality=50",
    "https://lh3.googleusercontent.com/proxy/sGZOhnVX2RWye5gkxN-k4dZ_FUweHMAl24K7hal3IE5dYWvIAc6fkDlPFDZU5-S2viRNGLlTOT_n8iql3q5DaPLlnxvBOsRbH77IohYlIR335sE38f7Eww"
  ];

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      title: title,
      commentHint: "...",
      message: '$title hakk??nda ne d??????n??yorsunuz',
      image: Image.network(
        "https://i.ytimg.com/vi/j7X7jPTfIjc/maxresdefault.jpg",
        height: 100,
      ),
      submitButton: 'G??nder',
      onCancelled: () {},
      onSubmitted: (response) {
        FirebaseFirestore.instance
            .collection("TumluYorum")
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
              infoText("Ceyhan'??n 17 km kuzeybat??s??nda Sa??kaya buca????n??n Dumlu (Tumlu) "
                  "mahallesinin bat??s??nda ve 75 m kadar y??kseklikteki sert kalkerli"
                  " bir tepe ??zerindedir. 12. y??zy??lda yap??ld?????? san??lmaktad??r."
                  " ??evresi 800 metredir. Sekiz bur??ludur. Ovaya bakan do??u k????esinde "
                  "g??zetleme kulesi bulunmaktad??r. Tek kap??s?? do??uya bakmaktad??r. "
                  "Kale i??erisinde yap?? kal??nt??lar?? ve sarn????lar yer almaktad??r."
                  " Tepe etraf??nda kaya mezarlar?? g??r??lmektedir."
                  "Kalenin kuzeyinde yar??m ha?? ??eklinde bir??ok mezar vard??r. Bu mezarlar"
                  " genelde k??????k el yap??m?? ma??aralar bi??imindedir. Kuzeybat??s??nda "
                  "mozaikler bulunan kalede yak??n zamanda bir ma??ara mezar ve bir toplu"
                  " mezar ortaya ????km????t??r."),
              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_circle_up,color: Colors.black,size: 40,),                    onPressed: ()
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
                Get.to(() => TumluYorum());
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