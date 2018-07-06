import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class TodayWidget extends StatefulWidget {
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<TodayWidget> {
  var cards;

  Future<List<TodayModel>> _request() async {
    const String url =
        "http://app.u17.com/v3/appV3_3/ios/phone/comic/todayRecommend";
    final response = await http.get(url);
    final responseJson = JSON.decode(response.body);
    final data = responseJson["data"];
    final returnData = data["returnData"];
    final dayDataList = returnData["dayDataList"];
    cards = List<TodayModel>();

    for (int i = 0; i < dayDataList.length; i++) {
      final dayItemDataList = dayDataList[i]["dayItemDataList"];
      final weekDay = dayDataList[i]["weekDay"];
      final timeStamp = dayDataList[i]["timeStamp"];
      DateModel dateModel = DateModel();
      dateModel.weekDay = weekDay;
      dateModel.timeStamp = timeStamp;
      dateModel.getWeekDay();
      cards.add(dateModel);
      for (int j = 0; j < dayItemDataList.length; j++) {
        final object = dayItemDataList[j];
        //final type = object["type"];
        final card = CardModel();
        card.htmlId = object["htmlId"];
        card.cover = object["cover"];
        card.comicId = object["comicId"];
        card.comicName = object["comicName"];
        card.dataType = object["dataType"];
        card.comicCover = object["comicCover"];
        card.comicListTitle = object["comicListTitle"];
        cards.add(card);
        final dayComicItemList = object["dayComicItemList"];
        if (dayComicItemList != null && dayComicItemList.length > 0) {
          card.recommends = List<RecommendedModel>();
          for (int k = 0; k < dayComicItemList.length; k++) {
            final object2 = dayComicItemList[k];
            RecommendedModel recommendedModel = RecommendedModel();
            recommendedModel.name = object2["name"];
            recommendedModel.comicId = object2["comicId"];
            recommendedModel.cover = object2["cover"];
            recommendedModel.chapterCount = object2["chapterCount"];
            recommendedModel.tags = object2["tags"].join(", ").toString();
            card.recommends.add(recommendedModel);
          }
        }
      }
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _request(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child:
                  Text('Loading...', style: TextStyle(color: Colors.black87)),
            );
          default:
            if (snapshot.hasData) {
              return _createListView(context);
            } else {
              return Center(
                child: Text('${snapshot.error}',
                    style: TextStyle(color: Colors.red)),
              );
            }
        }
      }
    );
  }

  _createListView(BuildContext context) {
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        if (cards[index] is CardModel) {
          final card = cards[index] as CardModel;
          return _createCardWidget(context, card);
        } 
        if (cards[index] is DateModel) {
          final date = cards[index] as DateModel;
          return _createDateWeekWidget(context, date);
        }
    });
  }
}

/// 创建日期 周天小部件
Widget _createDateWeekWidget(BuildContext context, DateModel date) {
  return Container(
    padding: EdgeInsets.only(left: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${date.date}', style: TextStyle(color: Colors.grey)),
        Text(
          '${date.week}',
          style: TextStyle(fontSize: 30.0),
        )
      ],
    ),
  );
}
/// 创建卡片小部件
Widget _createCardWidget(BuildContext context, TodayModel today) {
  // 创建不可以阅读的卡片
  _createCard(BuildContext context, CardModel card) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: EdgeInsets.all(0.0),
      child: CachedNetworkImage(
        imageUrl: card.cover,
        placeholder: Center(
          child: Text('Loading...'),
        ),
        errorWidget: Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
  // 创建一个阅读的按钮
  _createPostioned(BuildContext context, CardModel card, {double bottom = 29.0, double right: 21.0}) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 3.0),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(15.0), right: Radius.circular(15.0))),
        child: Text('观看漫画', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // 创建推荐阅读
  _createRecommendWidget(BuildContext context, CardModel card) {
    List<Widget> widgets = List<Widget>();
    final recommendContainer = Container(
      margin: EdgeInsets.only(left: 15.0, top: 10.0),
      child: Row(
        children: [
          Text(card.comicListTitle, style: TextStyle(fontSize: 25.0))
        ],
      ),
    );
    widgets.add(recommendContainer);

    for (int i = 0; i < card.recommends.length-2; i++) {
      final recommed = card.recommends[i] as RecommendedModel;
      final listTile = ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        leading: Container(
          height: 90.0,
          child: Image(
            image: CachedNetworkImageProvider(recommed.cover),
            fit: BoxFit.cover,
          ),
        ),
        title: Text(recommed.name, style: TextStyle(fontSize: 17.0)),
        subtitle: Text(recommed.tags, style: TextStyle(fontSize: 13.0, color: Colors.grey)),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 3.0),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(15.0), right: Radius.circular(15.0))),
          child: Text('观看漫画', style: TextStyle(color: Colors.white)),
        ),
      );
      widgets.add(listTile);
    }

    final collectionContainer = Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, color: Colors.green),
            Text('全部收藏', style: TextStyle(color: Colors.green))
          ],
        ),
    );
    widgets.add(collectionContainer);

    return widgets;
  }

  if (today is CardModel && today.dataType == 1) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Stack(
        children: [
          _createCard(context, today),
          _createPostioned(context, today)
        ],
      ));
  } 
  if(today is CardModel && today.dataType == 2) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Stack(
        children: [
          _createCard(context, today),
        ],
      )
    );
  }
  if (today is CardModel && today.dataType == 3) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
        margin: EdgeInsets.all(0.0),
        child: Column(
          children: _createRecommendWidget(context, today),
        ),
      ),
    );
  }
}

class Today extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(child: TodayWidget()),
    );
  }
}

abstract class TodayModel {}
class DateModel implements TodayModel {
  String weekDay;
  String timeStamp;
  String week;
  String date;

  void getWeekDay() {
    final ts = int.parse(this.timeStamp);
    final date = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    final now = DateTime.now();
    var month = date.month.toString();
    var day = date.day.toString();
    if (date.month < 10) {
      month = "0${date.month}";
    }
    if (date.day < 10) {
      day = "0${date.day}";
    }

    if (date.weekday == now.weekday) {
      this.week = "今日";
      this.date = "$month月$day日 ${this.weekDay}";
    } else {
      this.week = this.weekDay;
      this.date = "$month月$day日";
    }
  }
}

class CardModel implements TodayModel {
  var htmlId;
  var cover;
  var comicId;
  var comicName;
  var comicCover;
  var dataType;
  var comicListTitle;
  var recommends;
}

class RecommendedModel implements TodayModel {
  var name;
  var comicId;
  var cover;
  var tags;
  var chapterCount;
}
