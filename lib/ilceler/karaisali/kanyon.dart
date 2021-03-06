import 'package:adana/components/buttonText.dart';
import 'package:adana/components/infoText.dart';
import 'package:adana/components/mainAppBar.dart';
import 'package:adana/components/sliderImage.dart';
import 'package:adana/constants/constants.dart';
import 'package:adana/ilceler/karaisali/yorumlar/kanyon.dart';
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

class Kanyon extends StatefulWidget {
  const Kanyon({Key? key}) : super(key: key);

  @override
  _KanyonState createState() => _KanyonState();
}

class _KanyonState extends State<Kanyon> with SingleTickerProviderStateMixin {
  double x = 37.233555;
  double y = 35.014943;
  String title = "KAPIKAYA KANYONU";
  FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
    tabController = TabController(length: 6, vsync: this);
  }

  TabController? tabController;

  static List<String> links = [
    "https://i2.milimaj.com/i/milliyet/75/0x410/5f6e6d1dadcdeb162c8cca69.jpg",
    "https://media.istockphoto.com/photos/suspension-bridge-in-turkey-with-wood-walkwayadanakaraisali-picture-id978360234?k=6&m=978360234&s=170667a&w=0&h=WsdbgTOCxi8dsEQsVCkv8oSCakP5t4EX5EmcKMvDjvo=",
    "https://i.pinimg.com/originals/a3/c4/6e/a3c46ebdebc51da8f00ba39d54560808.jpg",
    "https://www.gezivetatilrehberi.com/resimler/sehir/adana/gezi/adana-kapikaya-kanyonu-16121163801.jpg",
    "https://www.gezenbilir.com/attachments/dsc_4832-jpg.307310/",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlO-5wY9xI7DOSIXjmArxTj0zYB8o1kOuYAw&usqp=CAU",
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
      message: 'Kap??kaya Kanyonu hakk??nda ne d??????n??yorsunuz',
      image: Image.asset(
        "assets/karaisali/kanyon/k5.jpg",
        height: 100,
      ),
      submitButton: 'G??nder',
      onCancelled: () {},
      onSubmitted: (response) {
        FirebaseFirestore.instance
            .collection("kanyonYorum")
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
              infoText("Kap??kaya Kanyonu, Adana ili Karaisal?? il??esinde "
                  "Kap??kaya k??y??nde bulunan kanyon."
                  "Kanyonu Seyhan Nehri'nin kollar??ndan ??ak??t'"
                  " Deresi a??m????t??r. ??ak??t Deresi, Seyhan Nehri'"
                  "nin Bat?? koludur. Pozant?? Bo??az??ndan da??l??k "
                  "alanlara do??ru uzan??r. Kanyon Varda K??pr??s??'ne '"
                  "'2 km uzakl??????ndad??r."
                  "Kanyon ??evresinde bitki ??rt??s??; zakkum, "
                  " zeytin, ke??iboynuzu ve ????nar a??a??lar??ndan "
                  "olu??ur. 20 km'lik kanyonun 7,25 km'si y??r??y????"
                  "yolu olarak d??zenlenmi??, do??a y??r??y????leri yap??lmaktad??r."
                  "Kanyonun do??a turizmi i??in cazibe merkezi haline getirilmesine"
                  "??al??????lmaktad??r. Yerk??pr?? piknik alan?? ile kanyon yolu yeni"
                  "yap??lan bir k??pr?? ile birle??tirilmi??tir. 7,250 m y??r??y???? yolu "
                  "d??zenlenmi??, ??elaleyi g??recek bir alana ah??ap seyir teras??"
                  "yap??lm????t??r. Sarp olan 400 metrelik k??sma korkuluk yap??l??p,"
                  "dar alanlarda yol geni??letilmi??tir."),
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
              child: buttonTextContainer(context, "HAR??TADA G??STER",)),
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Get.to(() => KanyonYorum());
              },
              child: buttonTextContainer(context, "YORUMLARI G??STER",)),

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