import 'package:flutter/material.dart';
import 'Today.dart';

void main() => runApp(
  MaterialApp(
    home: Youyaoqi(),
    theme: ThemeData(primaryColor: Colors.green),
  )
);


class Youyaoqi extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Youyaoqi> {
  PageController pageController;
  int page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: this.page);
  }
  void onTap(int index) {
    print('index: $index');
    pageController.animateToPage(index, duration: Duration(microseconds: 1), curve: Curves.ease);
  }
  void onPageChanged(int page) {
    setState(() {
      print('this.page: ${this.page}');
      this.page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          Today(),
          Discover(),
          BookCase(),
          Mine()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            title: Text('今日'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('发现')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('书架')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text('我的')
          )
        ],
        fixedColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        currentIndex: page,
      ),
    );

  }
}


class Discover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('发现'),
      ),
    );
  }
}

class BookCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('书架'),
      ),
    );
  }
}

class Mine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('我的'),
      ),
    );
  }
}