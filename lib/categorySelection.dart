import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

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
    'assets/office_supplies.png',
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
  String convenienceStore = '편의점';
  String officeSupplies = '사무용품';
  String coffee = '커피&디저트';
  String transaction = '중고거래대행';
  String pharmacy = '약국';
  String package = '택배&우편물';
  String laundry = '세탁소&구두';
  String exchange = '상품교환';
  String luggage = '짐옮기기';
  String ect = '기타';

  @override
  void initState() {
    super.initState();
    pageController = PageController(
        initialPage: 1, viewportFraction: 0.8
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        title: Text('심플'),
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
            crossAxisCount: 3,
            padding: EdgeInsets.all(8),
            children: errandsList.map((errand) {
              int index = errandsList.indexOf(errand);
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, HomePage.routeName, arguments: errand);
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