import 'package:flutter/material.dart';
import 'today/today.dart';
import 'discover/discover.dart';
import 'collection/collection.dart';
import 'profile/profile.dart';

void main() => runApp(
  MaterialApp(
    home: MyApp(),
    theme: ThemeData(
      buttonColor: Colors.green,
      backgroundColor: Colors.grey[200],
      textTheme: TextTheme(
        display1: TextStyle(fontSize: 17.0, color: Colors.black),
        display2: TextStyle(fontSize: 13.0, color: Colors.grey),
        display3: TextStyle(fontSize: 23.0, color: Colors.black)
      ),
    ),
  )
);

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.pageController = PageController(initialPage: this.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text("今日"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("发现"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            title: Text("收藏"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("我的"),
          ),
        ],
        fixedColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        onTap: (page) {
          pageController.jumpToPage(page);
        },
        currentIndex: this.currentIndex,
      ),
      body: PageView(
        children: <Widget>[
          TodayWidget(),
          DiscoverWidget(),
          CollectionWidget(),
          ProfileWidget()
        ],
        controller: this.pageController,
        onPageChanged: (index) {
          setState((){
            this.currentIndex = index;
          });
        },
      ),
    );
  }
}
