import 'package:flutter/material.dart';

class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  late PageController pageController;
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
      body: Column(
        children: [
          Flexible(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Container(
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(8),
                    // childAspectRatio: 2/3,
                    children: [
                        /*
                        navigate to home with certain (value)
                        to build list card view with switch(value)
                         */
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
                ),
              ),
          ),
        ],
      ),
    );
  }
}
