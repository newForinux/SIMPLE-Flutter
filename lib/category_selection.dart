import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: convenienceStore);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/convenience_store.png'),
                        ),
                      ),
                      Text('편의점', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: officeSupplies);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/office_supplies.png'),
                        ),
                      ),
                      Text('사무용품', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: coffee);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/coffee.png'),
                        ),
                      ),
                      Text('커피&디저트', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: transaction);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/transaction.png'),
                        ),
                      ),
                      Text('중고거래대행', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: pharmacy);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/pharmacy.png'),
                        ),
                      ),
                      Text('약국', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: package);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/package.png'),
                        ),
                      ),
                      Text('택배&우편물', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: laundry);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/laundry.png'),
                        ),
                      ),
                      Text('세탁소&구두', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: exchange);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/exchange.png'),
                        ),
                      ),
                      Text('상품교환', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: luggage);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/luggage.png'),
                        ),
                      ),
                      Text('짐옮기기', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home', arguments: ect);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3/1.5,
                        child: Image(
                          image: AssetImage('assets/ect.png'),
                        ),
                      ),
                      Text('기타', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
