import 'package:flutter/material.dart';
import '../request/request.dart';
import 'todayModel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TodayWidget extends StatefulWidget {
  _TodayWidgetState createState() => _TodayWidgetState();
}

class _TodayWidgetState extends State<TodayWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: YYQRequest.requestToday(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasData) {
                return _generatorTodayListView(context, snapshot.data);
              } else {
                return Center(
                  child: Text(snapshot.error)
                );
              }
          }
        }
      )
    );
  }
}

/// 创建ListView
ListView _generatorTodayListView(BuildContext context, TodayResult result) {
  return ListView.builder(
    itemCount: result.dayDataList.length,
    itemBuilder: (context, index){
      final model = result.dayDataList[index];
      // return _generatorTodayDateWidget(context);
      if (model is TodayPublishDate) {
        return _generatorTodayDateWidget(context, model);
      } 
      if (model is DayItemData) {
        return _generatorTodayCardWidget(context, model);
      }
      if (model is DayItemData2) {
        return _generatorTodayRecommendWidget(context, model);
      }
    },
  );
}

/// 创建日期小部件
Widget _generatorTodayDateWidget(BuildContext context, TodayPublishDate publish) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Text(publish.date, style: Theme.of(context).textTheme.display2),
        ),
        Text(publish.week, style: Theme.of(context).textTheme.display3)
      ],
    ),
  );
}

/// 创建卡片小部件
Widget _generatorTodayCardWidget(BuildContext context, DayItemData item) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
    child: Stack(
      children: <Widget>[
        Card(
          child: Image(image: CachedNetworkImageProvider(item.cover)),
        ),
        Positioned(
          right: 20.0,
          bottom: 20.0,
          child: Container(
            height: 30.0,
            width: 80.0,
            decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(15.0), right: Radius.circular(15.0))
            ),
            // padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Align(child: Text('阅读漫画', style: TextStyle(color: Colors.white))),
          ),
        )
      ],
    )
  );
}

/// 创建推荐小部件
Widget _generatorTodayRecommendWidget(BuildContext context, DayItemData2 item) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
    child: Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(item.comicListTitle, style: Theme.of(context).textTheme.display3),
            ),
          ),
          Container(
            child: Column(
              children: item.list.take(3).map<Widget>((comic) {
                return Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      width: 100.0,
                      child: Image(image: CachedNetworkImageProvider(comic.cover))
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 23.0, bottom: 5.0),
                              child: Text(comic.name, style: Theme.of(context).textTheme.display1),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Text(comic.tags, style: Theme.of(context).textTheme.display2),
                            ),
                            Container(
                              color: Colors.black12,
                              height: .5,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Container(
                        height: 30.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).buttonColor,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(15.0), right: Radius.circular(15.0))
                        ),
                        child: Align(
                          child: Text('阅读漫画', style: TextStyle(color: Colors.white))
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.star_border, color: Theme.of(context).buttonColor),
                Text('全部收藏', style: TextStyle(color: Theme.of(context).buttonColor))
              ],
            ),
          ),
        ],
      ),
    )
  );
}


