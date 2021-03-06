import 'package:adana/components/buttonText.dart';
import 'package:adana/components/infoText.dart';
import 'package:adana/components/mainAppBar.dart';
import 'package:adana/components/sliderImage.dart';
import 'package:adana/constants/constants.dart';
import 'package:adana/ilceler/cukurova/yorumlar/muze.dart';
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

class SinemaMuzesi extends StatefulWidget {
  const SinemaMuzesi({Key? key}) : super(key: key);

  @override
  _SinemaMuzesiState createState() => _SinemaMuzesiState();
}

class _SinemaMuzesiState extends State<SinemaMuzesi>
    with SingleTickerProviderStateMixin {
  double x = 36.988459;
  double y = 35.331943;
  String title = "SİNEMA MÜZESİ";
  FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
    tabController = TabController(length: 6, vsync: this);
  }

  TabController? tabController;

  static List<String> links = [
    "https://www.gezilesiyer.com/wp-content/uploads/2019/04/adana-sinema-muzesi.jpg",
    "https://media-cdn.tripadvisor.com/media/photo-s/16/b5/58/86/20190301-164803-largejpg.jpg",
    "https://i1.wp.com/gezginimgezgin.com/wp-content/uploads/2020/04/3-15.jpg",
    "https://www.gezilesiyer.com/wp-content/uploads/2019/04/adana-sinema-muzesi-02.jpg",
    "https://i.pinimg.com/736x/31/01/80/3101800326daec771ecd6e65ed48efb9.jpg",
    "https://i.sozcu.com.tr/wp-content/uploads/2019/06/10/iecrop/y8_16_9_1560175560.jpg",
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
      message: 'Adana Sinema Müzesi hakkında ne düşünüyorsunuz',
      image: Image.asset(
        "assets/seyhan/sinema.jpg",
        height: 100,
      ),
      submitButton: 'Gönder',
      onCancelled: () {},
      onSubmitted: (response) {
        FirebaseFirestore.instance
            .collection("SinemaMuzesiYorum")
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
                  "Adana Sinema Müzesi, Türkiye'nin Adana kentinde bulunan "
                  "bir sinema müzesidir. Müze, 23 Eylül 2011 tarihinde eski "
                  "bir Adana evinde kurulmuş olup Seyhan ilçesine bağlı Kayalıbağ"
                  " Mahallesi'nde Seyhan Nehri'nin batısında yer almaktadır. "
                  "Özellikle şehre özgü yönetmenler, oyuncular ve yapımcılar"
                  " ile ilgili eserler tanıtılmaktadır."
                  " Müzenin zemin katı film afişleri için ayrılmıştır. Posterdeki "
                  "en az bir isim (yönetmen, oyuncu, senarist vb.) "
                  "Adana sakinine aittir. Birinci katta, Yılmaz Güney'in "
                  "fotoğraflarını, film afişlerini ve eşyalarını gösteren "
                  "bir oda bulunmaktadır. Ayrıca Yılmaz Güney, ressam Abidin "
                  "Dino ve yazar Orhan Kemal'in heykelleri vardır. Adana'dan sinema"
                  " ile ilgili diğer tanınmış kişilerin sergilendiği fotoğraflar"
                  " ve eserler ise yazar Yaşar Kemal, oyuncu Şener Şen ve babası"
                  " oyuncu Ali Şen, Muzaffer İzgü, Ali Özgentürk, Orhan Duru,"
                  " Aytaç Arman, Bilal İnci, Merve Mahmut Hekimoğludur. Müzede"
                  " bir de kütüphane bulunmaktadır."),
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
              child: buttonTextContainer(context, "HARİTADA GÖSTER")),
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Get.to(() => MuzeYorum());
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
