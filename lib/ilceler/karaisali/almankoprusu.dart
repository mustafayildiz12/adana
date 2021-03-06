import 'package:adana/components/buttonText.dart';
import 'package:adana/components/infoText.dart';
import 'package:adana/components/mainAppBar.dart';
import 'package:adana/components/sliderImage.dart';
import 'package:adana/constants/constants.dart';
import 'package:adana/ilceler/karaisali/yorumlar/varda.dart';
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

class AlmanKoprusu extends StatefulWidget {
  const AlmanKoprusu({Key? key}) : super(key: key);

  @override
  _AlmanKoprusuState createState() => _AlmanKoprusuState();
}

class _AlmanKoprusuState extends State<AlmanKoprusu>
    with SingleTickerProviderStateMixin {
  double x = 37.242919;
  double y = 34.976780;
  String title = "Varda Köprüsü";
  FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
    tabController = TabController(length: 6, vsync: this);
  }

  void getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      loggedInuser = user;
    }
  }

  TabController? tabController;

  static List<String> links = [
    "https://www.kulturportali.gov.tr/repoKulturPortali/large/SehirRehberi//GezilecekYer/20190711105722848_Varda%20Koprusu%201.jpg?format=jpg&quality=50",
    "https://seyyahdefteri.com/wp-content/uploads/2018/12/Varda-K%C3%B6pr%C3%BCs%C3%BC-Nerede-Nas%C4%B1l-Gidilir-Neler-Yap%C4%B1l%C4%B1r-3.jpg",
    "https://www.karaisali.bel.tr/wp-content/uploads/2020/03/Varda-Koprusu%E2%80%99nde-Isiklandirma-Calismalari-Tamamlandi.jpg",
    "https://i.sozcu.com.tr/wp-content/uploads/2021/02/14/iecrop/varda-koprusu-iha.jpg1__16_9_1613290099.jpg",
    "https://gezilmesigerekenyerler.com/wp-content/uploads/2017/05/Varda-Koprusu.jpg",
    "https://pbs.twimg.com/media/EfKi-EdWAAIxPpI.jpg",
  ];

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      title: title,
      commentHint: "...",
      message: 'Varda Köprüsü hakkında ne düşünüyorsunuz',
      image: Image.asset(
        "assets/karaisali/varda/v4.jpg",
        height: 100,
      ),
      submitButton: 'Gönder',
      onCancelled: () {},
      onSubmitted: (response) {
        FirebaseFirestore.instance
            .collection("vardaYorum")
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
              infoText("Varda Köprüsü, Adana ili Karaisalı ilçesi Hacıkırı "
                  "(Kıralan) mahallesi'nde bulunan, yöre halkı tarafından Koca "
                  "Köprü diye anılan köprü. Hacıkırı Demiryolu"
                  " Köprüsü olarak ya da 1912 yılında Almanlar"
                  " tarafından inşa edildiği için Alman köprüsü olarak bilinmektedir."
                  " Adana'ya uzaklığı karayolu ile Karaisalı üzerinden 64 km'dir."
                  " Demir yolu ile Adana İstasyonu'na mesafesi 63 km'dir."
                  "Bu köprü Almanlar tarafından, çelik kafes taş örme "
                  "tekniği ile yapılmıştır. 6. Bölge sınırları içinde "
                  "bulunmaktadır. 1912 yılında hizmete açılmıştır. Köprünün"
                  " yapılış amacı İstanbul-Bağdat-Hicaz Demiryolu hattını tamamlamaktır."),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_circle_up,color: Colors.black,size: 40,),
                    onPressed: () {
                      Get.bottomSheet(buildSheet(),
                          barrierColor: Colors.white.withOpacity(0.6),
                          isScrollControlled: false);
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

  Widget buildSheet() {
    return Container(
      color: kutu,
      child: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Get.to(() => Maps(), arguments: [x, y, title]);
              },
              child: buttonTextContainer(context, "HARİTADA GÖSTER")),
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Get.to(() => VardaYorum());
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
            icon: Icon(
              Icons.cancel_sharp,
              size: 25,
              color: Colors.grey,
            ),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
    );
  }
}
