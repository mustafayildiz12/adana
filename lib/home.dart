import 'dart:io';
import 'package:adana/auth/login.dart';
import 'package:adana/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'TileScreen.dart';

late User loggedInuser;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? yuklenecekDosya;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? indirmeBaglantisi;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool getImage = false;
  int curIndex = 0;

  List<String> titles = [
    "KARAİSALI",
    "CEYHAN",
    "ÇUKUROVA",
    "SEYHAN",
    "POZANTI",
    "YUMURTALIK"
  ];
  List typesKaraisali = [
    {
      'ad': "KAPIKAYA KANYONU",
      'image': "assets/karaisali/kanyon/k5.jpg",
      'bilgi': "Kapıkaya Kanyonu, Adana ili Karaisalı ilçesinde "
          "Kapıkaya köyünde bulunan kanyon."
          "Kanyonu Seyhan Nehri'nin kollarından Çakıt'"
          " Deresi açmıştır. Çakıt Deresi, Seyhan Nehri'"
          "nin Batı koludur. Pozantı Boğazından dağlık "
          "alanlara doğru uzanır. Kanyon Varda Köprüsü'ne '"
          "'2 km uzaklığındadır."
          "Kanyon çevresinde bitki örtüsü; zakkum, "
          " zeytin, keçiboynuzu ve çınar ağaçlarından oluşur.",
      'puan': "4",
      "route": "/kanyon"
    },
    {
      "route": "/yerkopru",
      'puan': "4",
      'ad': "YERKÖPRÜ",
      'image': "assets/karaisali/yerkopru/y3.jpg",
      'bilgi': "Yerköprü Mesire Alanı Adana şehir merkezine 53 km "
          "Karaisalı ilçemize 13 km mesafede yer almaktadır. "
    },
    {
      "route": "/varda",
      'puan': "5",
      'ad': "VARDA KÖPRÜSÜ",
      'image': "assets/karaisali/varda/v4.jpg",
      'bilgi': "Varda Köprüsü, Adana ili Karaisalı ilçesi Hacıkırı "
          "(Kıralan) mahallesi'nde bulunan, yöre halkı tarafından Koca "
          "Köprü diye anılan köprü. Hacıkırı Demiryolu"
          " Köprüsü olarak ya da 1912 yılında Almanlar"
          " tarafından inşa edildiği için Alman köprüsü olarak bilinmektedir.",
    },
    {
      "route": "/dokuzoluk",
      'puan': "5",
      'ad': "DOKUZOLUK",
      'image': "assets/karaisali/dokuzoluk/d2.jpg",
      'bilgi': "Dokuzoluk piknik alanı bir kanyonun hemen kenarında çeşitli "
          "noktalardan fışkıran pınarlar, yemyeşil bitki örtüsü ve"
          " ziyaretçilerin buz gibi suyunda serinledikleri göletlerden"
          " oluşmaktadır. Piknik yapmak, yüzmek, balık tutmak,"
          " yürüyüş yapmak, fotoğraf çekmek burada gerçekleştirilebilecek"
          " aktiviteler arasındadır. Köprünün üzerinden kanyon manzarasının "
          "fotoğrafının çekilmesi tavsiye edilir.",
    },
    {
      "route": "/karapinar",
      'puan': "4",
      'ad': "KARAPINAR PARKI",
      'image': "assets/karaisali/park/k11.jpg",
      'bilgi': " Karaisalı, Roma Döneminden önemli izler taşıyan"
          " ilçe konumuna sahip olan bir bölgedir. Bu ilçe,"
          " soyunun Ramazanoğulları ve Menemencioğullarından geldiği"
          " günümüzdeki adını"
          " da Ramazanoğullarından Kara İsa Bey’den aldığı bilinen bir husustur.",
    },
    {
      "route": "/kizildag",
      'puan': "5",
      'ad': "KIZILDAĞ YAYLASI",
      'image': "assets/karaisali/kizildag/k3.jpg",
      'bilgi': "Varda Köprüsü, Adana ili Karaisalı ilçesi Hacıkırı "
          "(Kıralan) mahallesi'nde bulunan, yöre halkı tarafından Koca "
          "Köprü diye anılan köprü. Hacıkırı Demiryolu"
          " Köprüsü olarak ya da 1912 yılında Almanlar"
          " tarafından inşa edildiği için Alman köprüsü olarak bilinmektedir."
    },
    {
      "route": "/kesire",
      'puan': "4",
      'ad': "KESİRE HAN",
      'image': "assets/karaisali/kesire/k1.jpg",
      'bilgi': "İçinde yaşadığımız coğrafya insanlık tarihinin en "
          "önemli değişimlerine tanıklık etmiş binlerce"
          " kültür mirasına sahip bir coğrafyadır. Ancak "
          "şu da bir gerçektir ki bu tarihi mirası olması "
          "gerektiği biçimde koruma, kollama ve yaşatma "
          "görevlerini bu toplum yönetenler ve bu toplumun"
          " bireyleri yerine getirememiştir.",
    },
  ];

  List typesCeyhan = [
    {
      "route": "/anavarza",
      'ad': "ANAVARZA",
      'image': "assets/ceyhan/anavarza.jpg",
      'bilgi': "Kapıkaya Kanyonu, Adana ili Karaisalı ilçesinde "
          "Kapıkaya köyünde bulunan kanyon."
          "Kanyonu Seyhan Nehri'nin kollarından Çakıt'"
          " Deresi açmıştır. Çakıt Deresi, Seyhan Nehri'"
          "nin Batı koludur. Pozantı Boğazından dağlık "
          "alanlara doğru uzanır. Kanyon Varda Köprüsü'ne '"
          "'2 km uzaklığındadır."
          "Kanyon çevresinde bitki örtüsü; zakkum, "
          " zeytin, keçiboynuzu ve çınar ağaçlarından oluşur.",
      'puan': "4",
    },
    {
      "route": "/durhasan",
      'puan': "4",
      'ad': "DURHASAN",
      'image': "assets/ceyhan/durhasan.jpg",
      'bilgi':
          "Adana'nın Reşatbey Semti'nde, Merkez Park'ın güneyinde ve Seyhan "
              "Nehri'nin batı kıyısında yer alan cami, 1998 yılında hizmete "
              "açılmıştır. 32 metre çaplı ana kubbesi vardır.",
    },
    {
      "route": "/kurt",
      'puan': "5",
      'ad': "KURTKULAĞI",
      'image': "assets/ceyhan/kurt.jpg",
      'bilgi': "Ceyhan'ın 12 km güneydoğusunda Kurtkulağı mahallesi'ndedir. "
          "Adana Müzesinde bulunan kervansaray kitabesine göre eser "
          "1659'da Hüseyin Paşa tarafından yaptırılmış olup, mimarı Mehmed "
          "Ağa'dır.",
    },
    {
      "route": "/tumlu",
      'puan': "5",
      'ad': "TUMLU KALESİ",
      'image': "assets/ceyhan/dumli.jpg",
      'bilgi': "Ceyhan'ın 17 km kuzeybatısında Sağkaya bucağının Dumlu (Tumlu) "
          "mahallesinin batısında ve 75 m kadar yükseklikteki sert kalkerli"
          " bir tepe üzerindedir. 12. yüzyılda yapıldığı sanılmaktadır."
          " Çevresi 800 metredir. Sekiz burçludur. Ovaya bakan doğu köşesinde "
          "gözetleme kulesi bulunmaktadır.",
    },
    {
      "route": "/yilan",
      'puan': "5",
      'ad': "YILANKALE",
      'image': "assets/ceyhan/yilan.jpg",
      'bilgi': "Toros Dağları’nı aşarak Antakya’ya giden tarihi İpek Yolu "
          "üzerinde yer alan Yılan Kalesi, Orta Çağ’da Çukurova'nın"
          " Haçlı işgali döneminde Bizanslılar tarafından yapılmıştır."
          " Anavarza, Tumlu ve Kozan Kaleleri gibi ovadaki"
          " diğer kaleleri de görüş alanının içine alan"
          " kalenin sekiz yuvarlak burcu vardır.",
    },
  ];
  List typesCukurova = [
    {
      "route": "/dogal",
      'ad': "DOĞAL PARK",
      'image': "assets/ova/dogal.jpg",
      'bilgi':
          "Çukurova Belediyesi tarafından ilçenin içerisine yapılan bu park"
              " gerçekten dikkat çekici bir kullanım yapısına sahiptir."
              " İçerisinde akarsular, piknik alanları, kuşlar ve farklı "
              "hayvan türleri bulunmaktadır. ",
      'puan': "4",
    },
    {
      "route": "/karatas",
      'puan': "4",
      'ad': "KARATAŞ PLAJI",
      'image': "assets/ova/karatas.jpg",
      'bilgi': "Karataş Plajı Çukurova’ya yaklaşık 90 km uzaklıktadır."
          " Türkiye’nin ve Dünya’nın en önemli ve uzun "
          "kumsallarından biridir."
    },
    {
      "route": "/muze",
      'puan': "5",
      'ad': "MÜZE KOMPLEKSİ",
      'image': "assets/ova/muze.jpg",
      'bilgi': "Adana’nın birçok farklı noktasında yapılan kazı çalışmaları ile"
          " ortaya çıkan tarihi eserleri tek bir noktada sergilemeyi"
          " amaçlayan ve eski bir fabrika restore edilerek yapılan"
          " geniş müze kompleksi 2017 yılında açılmıştır. ",
    },
    {
      "route": "/sevgi",
      'puan': "5",
      'ad': "SEVGİ ADASI",
      'image': "assets/ova/sevgi.jpg",
      'bilgi': "Baraj gölü içerisinde yer alan en yüksek nokta olan ve halk tarafından"
          " Sevgi Adası olarak bilinen adayı mutlaka görmeniz önerilmektedir."
          " Gece olduğunda yanan neon ışıklar adanın güzelliğini taçlandırmaktadır. "
    },
    {
      "route": "/baraj",
      'puan': "5",
      'ad': "SEYHAN BARAJI",
      'image': "assets/ova/baraj.jpg",
      'bilgi':
          "Çukurova’ya gidildiğinde ilk uğranılması gereken yerlerin başında"
              " Seyhan Baraj Gölü gelmektedir. 1956 yılında inşa edilen baraj"
              " gölü şuan şehre sadece elektrik sağlamamakta aynı zamanda"
              " turizm faaliyetleriyle de dikkat çekmektedir.",
    },
    {
      "route": "/lagun",
      'puan': "5",
      'ad': "YUMURTALIK LAGÜNÜ",
      'image': "assets/ova/lagun.jpg",
      'bilgi': "Yumurtalık Lagünü Milli Parkı Çukurova’ya yaklaşık 40 km"
          " uzaklıktadır. Birçok kuş türüne ev sahipliği yapan ve"
          " onların göç yolu üzerinde bulunan özel bir yerdir."
    },
  ];

  List typesSeyhan = [
    {
      "route": "/ataturk",
      'ad': "ATATÜRK EVİ",
      'image': "assets/seyhan/ata.jpg",
      'bilgi': "Adana Atatürk Evi Müzesi, Adana Seyhan Caddesi üzerinde bulunan müze."
          " 15 Mart 1923 tarihinde Mustafa Kemal Atatürk ve eşi Adana'yı ziyaret "
          "ettiğinde bu binada konaklamıştır. Bina daha önceleri Ramazanoğulları"
          " ailesine mensup Suphi Paşa'ya aitti. Bina sonraları Atatürk Bilim "
          "ve Kültür Müzesi Koruma ve Yaşatma Derneği'nce kamulaştırılmış ve "
          "restore edilmiştir.",
      'puan': "4",
    },
    {
      "route": "/kilise",
      'puan': "4",
      'ad': "BEBEKLİ KİLİSESİ",
      'image': "assets/seyhan/kilise.jpg",
      'bilgi': "Adana Bebekli Kilise veya Aziz Pavlus Kilisesi, "
          "üzerinde Meryem'in tunçtan heykelinin bulunduğu, tahminen 1880-90"
          " yılları arasında yapılan Adana'nın merkezindeki İtalyan katolik"
          " kilisesidir. Ermeni Apostolik Kilisesi olarak inşa edilmiştir."
    },
    {
      "route": "/dede",
      'puan': "5",
      'ad': "ÇOBAN DEDE PARKI",
      'image': "assets/seyhan/dede.jpg",
      'bilgi': "Çoban Dede Türbesinin ve Parkın bulunduğu alanın bir "
          "kısmı 2015 yılında kuş cenneti ve mini hayvanat bahçesine "
          "dönüştürüldü. Hayvanat bahçesinde memeliler, su kuşları,"
          " yırtıcı kuşlar, süs tavukları gibi hayvanlar yer almaktadır."
    },
    {
      "route": "/saat",
      'puan': "5",
      'ad': "SAAT KULESİ",
      'image': "assets/seyhan/saat.jpg",
      'bilgi': "Kule kesme taştan yapılmıştır. Uzunluğu 32 metre olan kule "
          "kare prizma şeklindedir ve kulenin duvarları tuğla ile"
          " inşa edilmiştir. Temel derinliğinin 35 metre olduğu "
          "söylenir. Saat kulesi dikdörtgen şeklinde taş tuğlalardan "
          "yapılmıştır."
    },
    {
      "route": "/merkez",
      'puan': "4",
      'ad': "SABANCI MERKEZ CAMİ",
      'image': "assets/seyhan/merkezcami.jpg",
      'bilgi':
          "Adana'nın Reşatbey Semti'nde, Merkez Park'ın güneyinde ve Seyhan "
              "Nehri'nin batı kıyısında yer alan cami, 1998 yılında hizmete "
              "açılmıştır. 32 metre çaplı ana kubbesi vardır.",
    },
    {
      "route": "/sinema",
      'puan': "5",
      'ad': "SİNEMA MÜZESİ",
      'image': "assets/seyhan/sinema.jpg",
      'bilgi': "Adana Sinema Müzesi, Türkiye'nin Adana kentinde bulunan "
          "bir sinema müzesidir. Müze, 23 Eylül 2011 tarihinde eski "
          "bir Adana evinde kurulmuş olup Seyhan ilçesine bağlı Kayalıbağ"
          " Mahallesi'nde Seyhan Nehri'nin batısında yer almaktadır."
    },
    {
      "route": "/taskopru",
      'puan': "5",
      'ad': "TAŞKÖPRÜ",
      'image': "assets/seyhan/taskopru.jpg",
      'bilgi': "Adana Taş Köprü Seyhan Nehri üzerindedir. IV. (385) yüzyılda "
          "Roma İmparatoru Hadrianus tarafından yaptırılmıştır."
          " Yüzyıllarca Avrupa ile Asya arasında önemli bir köprü "
          "olmuştur. Harun Reşit (766-809) köprüyü bazı eklerle"
          " Adana Kalesi'ne birleştirmiştir."
    },
    {
      "route": "/ulu",
      'puan': "5",
      'ad': "ULU CAMİİ",
      'image': "assets/seyhan/alu.jpg",
      'bilgi': "Ulu Cami büyüklüğü ve tarihî açısından Adana'nın önemli "
          "eserleri arasında gösterilmektedir. Selçuklu, Memlûklu"
          " ve Osmanlılar Dönem'lerine ait mimarî karakterleri"
          " üzerinde toplayan bu eserin üç ayrı kitabesinden,"
          " ilk defa 1513 yıllarında Ramazan oğlu Halil Bey"
          " tarafından inşasına başlandığı, 1541 yılında Halil"
          " Beyin oğlu Piri Mehmet Paşa tarafından bitirilerek "
          "ibadete açıldığı anlaşılmaktadır."
    },
  ];

  List pozantiList = [
    {
      "route": "/seker",
      'puan': "5",
      'ad': "ŞEKER PINARI",
      'image': "assets/pozanti/seker.jpg",
      'bilgi': "Şekerpınarı’nın hemen aşağısında Şapkalının "
          "Köprüsü olarak bilinen asma köprüyü geçerken "
          "ırmağı ve üzerindeki Akköprü’yü fotoğraflamanızı,"
          " köprüden geçince karşıda bulunan oluktan "
          "su içmenizi tavsiye ediyoruz."
    },
    {
      "route": "/armut",
      'puan': "5",
      'ad': "ARMUTOĞLU YAYLASI",
      'image': "assets/pozanti/armut.jpg",
      'bilgi': "Tamamen bakir durumda olan"
          " yayla sedir, köknar, ardıç ağaçları ve kır çiçekleri "
          "ile iç içedir. Sarımsak Dağı’nın eteğinde bulunması "
          "nedeniyle yaban hayatı bakımından da çok zengindir."
    },
    {
      "route": "/akca_tekir",
      'puan': "5",
      'ad': "AKÇAKTEKİR YAYLASI",
      'image': "assets/pozanti/tekir.jpg",
      'bilgi': "Bürücek Yaylası, Akçaköy ve"
          " Tekir Yaylası'nın birleşmesiyle oluşan Akçatekir "
          "Beldesi'nin bir mahallesi konumundadır. Çam, ardıç ve"
          " meyve bahçeleri arasında kurulmuş olan yaylada, yayla"
          " mimarisine uygun yapıların yanında farklı mimari"
          " tarzların örneklerini de görmek mümkündür."
    },
    {
      "route": "/tabya",
      'puan': "5",
      'ad': "İBRAHİM PAŞA TABYASI",
      'image': "assets/pozanti/tabya.jpg",
      'bilgi': "İbrahim Paşa Tabyaları oldukça sağlam ve bölgede"
          " sayısı çok az olan Osmanlı Dönemi yapılarındandır."
          " Yaklaşık 1830’lu yıllarda, doğudan gelecek saldırılara"
          " karşı koymak için İbrahim Paşa tarafından "
          "yaptırılmıştır.",
    },
    {
      "route": "/anit",
      'puan': "5",
      'ad': "ANIT AĞACI",
      'image': "assets/pozanti/anit.jpg",
      'bilgi': "Pozantı ilçesi sınırlarında 3 adet ağaç mevcuttur."
          " Bunlar Çetinlik Dağı orman arazisi içinde "
          "bulunan Sedir ağacı, Belemedik köyünde "
          "bulunan Çınar Ağacı ve Bürücek Yaylasında bulunan"
          " Ceviz Ağacıdır",
    },
    {
      "route": "/anahsa",
      'puan': "4",
      'ad': "ANAHSA KALESİ",
      'image': "assets/pozanti/anahsa.jpg",
      'bilgi': "Geniş bir tepe üzerindedir. Kuzeyde iki burun "
          "vardır. İç kısmında ise tonozlu yapılar ve"
          " su sarnıçları yer alır. Üst kısmında bilhassa"
          " doğu ve batıda mazgal dedikleri kaleyi "
          "çevrelemektedir.",
    },
  ];
  List yumurtaList = [
    {
      "route": "/ayas",
      'puan': "5",
      'ad': "AYAS ANTİK KENTİ",
      'image': "assets/yumurta/ayas.jpg",
      'bilgi': "Antik Kilikya’nın önemli liman kenti olan Aegeae M.Ö. 1'inci"
          " yüzyılda en parlak dönemini yaşamıştır.",
    },
    {
      "route": "/kizkalesi",
      'puan': "5",
      'ad': "KIZ KALESİ",
      'image': "assets/yumurta/kizkalesi.jpg",
      'bilgi': "Yumurtalık ilçesinin kuruluşu ilçe merkezi İskenderun "
          "Körfezinin kuzeyinde M.Ö. 4. Yüzyılın son çeyreğinde "
          "Büyük İskender’in Pers İmparatoru Dara’yı bugünkü İskenderun"
          " ile Dörtyol arasında kalan ovada mağlup etmesinden sonra "
          "İskenderin halefleri olan Makedonyalı komutanlar tarafından "
          "bir liman şehri olarak kurulmuştur."
    },
    {
      "route": "/suleyman",
      'puan': "5",
      'ad': "SÜLEYMAN KALESİ",
      'image': "assets/yumurta/suluman.jpg",
      'bilgi': "Osmanlı Hükümdarı Kanuni Sultan Süleyman zamanında yaptırıldığı"
          " için padişahın adını almıştır."
          "Ana gövdesinden kat kat yükselen kule denizden gelebilecek saldırıyı "
          "erken haber alabilmek için yapılmıştır."
    },

  ];

  void getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInuser = user;
      });
    }
  }

  void initState() {
    super.initState();
    getCurrentUser();
    baglantiAl();
  }

  baglantiAl() async {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(loggedInuser.email!)
        .child("profilResmi.png")
        .getDownloadURL();

    setState(() {
      indirmeBaglantisi = baglanti;
      getImage = true;
    });
  }

  kameradanYukle() async {
    var alinanDosya =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      yuklenecekDosya = File(alinanDosya!.path);
    });

    Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(loggedInuser.email!)
        .child("profilResmi.png");

    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya!);
    String url = await (await yuklemeGorevi.whenComplete(() => null))
        .ref
        .getDownloadURL();
    setState(() {
      indirmeBaglantisi = url;
    });
  }

  DateTime timeDifference = DateTime.now();

  Future<bool> exitApp() async {
    FirebaseAuth.instance.signOut().then((_) {
      Get.offAll(Login());
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeDifference);
        final isExitWarning = difference >= Duration(seconds: 2);

        timeDifference = DateTime.now();
        if (isExitWarning) {
          final message = "Çıkış Yapmak için artarda 2 kez tıklayın";
          Get.snackbar(
            "Bilgi",
            message,
            backgroundColor: Colors.grey.shade200,
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        } else {
          exitApp();
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: kutu,
          drawer: Drawer(
            child: Container(
              decoration: BoxDecoration(
                gradient: deneme,
              ),
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          kameradanYukle();
                        },
                        child: Center(
                          child: ClipOval(
                              child: indirmeBaglantisi == null
                                  ? Image.asset(
                                      "assets/profile.png",
                                      width: 30.w,
                                      height: 33.w,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      indirmeBaglantisi!,
                                      width: 30.w,
                                      height:33.w,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ),
                    ],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loggedInuser.email.toString(),
                        style: metin,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: 4.h,
                    left: 5.w,
                    right:5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: boxGradient,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: 30,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState!.openDrawer();
                          },
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(12),
                          gradient: boxGradient,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.exit_to_app,
                            size: 28,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((deger) {
                              Get.toNamed("/login");
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      titles.length,
                      (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                curIndex = index;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 5.w,
                                  right: 2.5.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      kutu,
                                      curIndex == index ? kutu3 : kutu,
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(
                                      vertical: 1.6.h, horizontal: 4.w),
                                  child: Text(
                                    titles[index],
                                    style: GoogleFonts.roboto(
                                      color: curIndex == index
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                height: size.height / 1.4,
                child: curIndex == 0
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: typesKaraisali.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => TileScreen(), arguments: [
                                index,
                                typesKaraisali[index]['image'],
                                typesKaraisali[index]['ad'],
                                typesKaraisali[index]['bilgi'],
                                typesKaraisali[index]['puan'],
                                typesKaraisali[index]['route'],
                              ]);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 5.h),
                              child: Stack(children: [
                                Hero(
                                  tag: "target$index",
                                  child: Container(
                                    width: size.width / 1.4,
                                    height: size.height / 1.8,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.8),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      image: DecorationImage(
                                          image: AssetImage(
                                            typesKaraisali[index]['image'],
                                          ),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width / 1.4,
                                  height: size.height / 1.8,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.9)
                                          ],
                                          stops: const [
                                            0.4,
                                            0.9
                                          ]),
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                Positioned(
                                    bottom: size.width / 3,
                                    left: 15.w,
                                    child: Text(
                                      typesKaraisali[index]['ad'],
                                      style: xdBeyaz,
                                    ))
                              ]),
                            ),
                          );
                        },
                      )
                    : curIndex == 1
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: typesCeyhan.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => TileScreen(), arguments: [
                                    index,
                                    typesCeyhan[index]['image'],
                                    typesCeyhan[index]['ad'],
                                    typesCeyhan[index]['bilgi'],
                                    typesCeyhan[index]['puan'],
                                    typesCeyhan[index]['route'],
                                  ]);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width / 20,
                                      vertical: size.height / 20),
                                  child: Stack(children: [
                                    Hero(
                                      tag: "target$index",
                                      child: Container(
                                        width: size.width / 1.4,
                                        height: size.height / 1.8,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  typesCeyhan[index]['image'],
                                                ),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                    ),
                                    Container(
                                      width: size.width / 1.4,
                                      height: size.height / 1.8,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.9)
                                              ],
                                              stops: const [
                                                0.4,
                                                0.9
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    Positioned(
                                        bottom: size.width / 4,
                                        left: 15.w,
                                        child: Text(
                                          typesCeyhan[index]['ad'],
                                          style: xdBeyaz,
                                        ))
                                  ]),
                                ),
                              );
                            },
                          )
                        : curIndex == 2
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: typesCukurova.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(() => TileScreen(), arguments: [
                                        index,
                                        typesCukurova[index]['image'],
                                        typesCukurova[index]['ad'],
                                        typesCukurova[index]['bilgi'],
                                        typesCukurova[index]['puan'],
                                        typesCukurova[index]['route'],
                                      ]);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 20,
                                          vertical: size.height / 20),
                                      child: Stack(children: [
                                        Hero(
                                          tag: "target$index",
                                          child: Container(
                                            width: size.width / 1.4,
                                            height: size.height / 1.8,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                      typesCukurova[index]
                                                          ['image'],
                                                    ),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                        ),
                                        Container(
                                          width: size.width / 1.4,
                                          height: size.height / 1.8,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black
                                                        .withOpacity(0.9)
                                                  ],
                                                  stops: const [
                                                    0.4,
                                                    0.9
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                        Positioned(
                                            bottom: size.width / 4,
                                            left: 15.w,
                                            child: Text(
                                              typesCukurova[index]['ad'],
                                              style: xdBeyaz,
                                            ))
                                      ]),
                                    ),
                                  );
                                },
                              )
                            : curIndex == 3
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: typesSeyhan.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => TileScreen(),
                                              arguments: [
                                                index,
                                                typesSeyhan[index]['image'],
                                                typesSeyhan[index]['ad'],
                                                typesSeyhan[index]['bilgi'],
                                                typesSeyhan[index]['puan'],
                                                typesSeyhan[index]['route'],
                                              ]);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width / 20,
                                              vertical: size.height / 20),
                                          child: Stack(children: [
                                            Hero(
                                              tag: "target$index",
                                              child: Container(
                                                width: size.width / 1.4,
                                                height: size.height / 1.8,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                          typesSeyhan[index]
                                                              ['image'],
                                                        ),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                              ),
                                            ),
                                            Container(
                                              width: size.width / 1.4,
                                              height: size.height / 1.8,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                            .withOpacity(0.9)
                                                      ],
                                                      stops: const [
                                                        0.4,
                                                        0.9
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            ),
                                            Positioned(
                                                bottom: size.width / 4,
                                                left: 15.w,
                                                child: Text(
                                                  typesSeyhan[index]['ad'],
                                                  style: xdBeyaz,
                                                ))
                                          ]),
                                        ),
                                      );
                                    },
                                  )
                                :  curIndex == 4 ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: pozantiList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => TileScreen(),
                                              arguments: [
                                                index,
                                                pozantiList[index]['image'],
                                                pozantiList[index]['ad'],
                                                pozantiList[index]['bilgi'],
                                                pozantiList[index]['puan'],
                                                pozantiList[index]['route'],
                                              ]);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width / 20,
                                              vertical: size.height / 20),
                                          child: Stack(children: [
                                            Hero(
                                              tag: "target$index",
                                              child: Container(
                                                width: size.width / 1.4,
                                                height: size.height / 1.8,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                          pozantiList[index]
                                                              ['image'],
                                                        ),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                              ),
                                            ),
                                            Container(
                                              width: size.width / 1.4,
                                              height: size.height / 1.8,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                            .withOpacity(0.9)
                                                      ],
                                                      stops: const [
                                                        0.4,
                                                        0.9
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            ),
                                            Positioned(
                                                bottom: size.width / 4,
                                                left: 15.w,
                                                child: Text(
                                                  pozantiList[index]['ad'],
                                                  style: xdBeyaz,
                                                ))
                                          ]),
                                        ),
                                      );
                                    },
                                  )
                    :  ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: yumurtaList.length,
                  itemBuilder:
                      (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => TileScreen(),
                            arguments: [
                              index,
                              yumurtaList[index]['image'],
                              yumurtaList[index]['ad'],
                              yumurtaList[index]['bilgi'],
                              yumurtaList[index]['puan'],
                              yumurtaList[index]['route'],
                            ]);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width / 20,
                            vertical: size.height / 20),
                        child: Stack(children: [
                          Hero(
                            tag: "target$index",
                            child: Container(
                              width: size.width / 1.4,
                              height: size.height / 1.8,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        yumurtaList[index]
                                        ['image'],
                                      ),
                                      fit: BoxFit.cover),
                                  borderRadius:
                                  BorderRadius.circular(
                                      12)),
                            ),
                          ),
                          Container(
                            width: size.width / 1.4,
                            height: size.height / 1.8,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin:
                                    Alignment.topCenter,
                                    end: Alignment
                                        .bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black
                                          .withOpacity(0.9)
                                    ],
                                    stops: const [
                                      0.4,
                                      0.9
                                    ]),
                                borderRadius:
                                BorderRadius.circular(
                                    12)),
                          ),
                          Positioned(
                              bottom: size.width / 4,
                              left: 15.w,
                              child: Text(
                                yumurtaList[index]['ad'],
                                style: xdBeyaz,
                              ))
                        ]),
                      ),
                    );
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
