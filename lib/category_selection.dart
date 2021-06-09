import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:simple_flutter/home.dart';


class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  late PageController pageController;
  final List<String> imagesList = [
    'assets/images/slider/simple_intro.png',
    'assets/images/slider/simple_sd.png',
    'assets/images/slider/simple_ad.png',
    'assets/images/slider/simple_spectrum.png',
  ];

  final List<String> errandsList = [
    '편의점',
    '사무용품',
    '카페/디저트',
    '거래 대행',
    '상비약',
    '택배/우편',
    '세탁/클리닝',
    '물품 교환',
    '물품 옮기기',
    '기타'
  ];

  final List<String> errandsImgList = [
    'assets/convenience_store.png',
    'assets/office_supply.png',
    'assets/coffee.png',
    'assets/transaction.png',
    'assets/pharmacy.png',
    'assets/package.png',
    'assets/laundry.png',
    'assets/exchange.png',
    'assets/luggage.png',
    'assets/ect.png'
  ];

  int _currentIndex = 0;
  double _latitude = 0;
  double _longitude = 0;
  String _locality = "";
  String _subLocality = "";
  String _thoroughfare = "";
  String _subThoroughfare = "";
  String _currentLoc = "";


  @override
  void initState() {
    super.initState();
    pageController = PageController(
        initialPage: 1, viewportFraction: 0.8
    );
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      _latitude = position.latitude;
      _longitude = position.longitude;
      _getCurrentAddress();
    } catch(e) {
      print(e);
    }
  }

  Future<void> _getCurrentAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(_latitude, _longitude, localeIdentifier: "ko_KR");
      Placemark place = placemarks[0];

      setState(() {
        _locality = place.locality!;
        _subLocality = place.subLocality!;
        _thoroughfare = place.thoroughfare!;
        _subThoroughfare = place.subThoroughfare!;

        _currentLoc = _locality + " " + _subLocality + " " + _thoroughfare + " " + _subThoroughfare;
      });
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        title: _locality == "" ?
        Text(
          "위치 찾는 중...",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vitro Pride',
          ),
        ) :
        Tooltip(
          message: "Ddd",

          child: TextButton(
            autofocus: true,
            onPressed: () {
              Navigator.pushNamed(context, '/map', arguments: {'lat': _latitude, 'lng': _longitude});
            },
            child: Text(
              _currentLoc,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Vitro Pride',
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.85,
              autoPlay: true,
              height: 300,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: imagesList.map((item) =>
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 30.0),
                  child: Card(
                    margin: EdgeInsets.only(
                      top: 10.0,
                    ),
                    elevation: 6.0,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      child: Image.asset(
                        item,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),
                    ),
                  ),
                )
            ).toList(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imagesList.map((item) {
              int index = imagesList.indexOf(item);
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                    ? Color.fromRGBO(0, 0, 0, 0.6)
                    : Color.fromRGBO(0, 0, 0, 0.3)
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 15),
          Divider(
            indent: 40,
            endIndent: 40,
            thickness: 2.0,
          ),
          SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            primary: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            padding: EdgeInsets.all(8),
            children: errandsList.map((errand) {
              int index = errandsList.indexOf(errand);
                return InkWell(
                  onTap: () {
                    // {'errand': errand, 'loc': _currentLoc}
                    Navigator.pushNamed(context, HomePage.routeName, arguments: {'category': errand, 'address': _currentLoc});
                  },
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(
                                errandsImgList[index],
                              )
                            ),
                          ),
                          child: SizedBox(),
                        ),
                        Text(
                          errandsList[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
