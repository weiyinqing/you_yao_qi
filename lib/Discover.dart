import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class Discover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[120],
      body: DiscoverWidget()
    );
  }
}

class DiscoverWidget extends StatefulWidget {
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<DiscoverWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: YYQRequest.requestDiscover(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          return Center(
            child: CircularProgressIndicator()
          );
          default:
            if (snapshot.hasData) {
              print(snapshot.data);
              return _generatorListView(context, snapshot.data);
            } else  {
              print(snapshot.error);
              return Center(child: Icon(Icons.error));
            }
        }
      },
    );
  }
}

/// 创建最外层的ListView
Widget _generatorListView(BuildContext context, Map<String, List<DiscoverItem>> map) {
  return ListView.builder(
    itemCount: 2,
    itemBuilder: (context, index) {
      if (index == 0) {
        final gallerys = map[gallery];
        final comics = map[comic];
        return _generatorBannerWidget(context, gallerys, comics);
      } else {
        return _generatorSectionHeaderWidget(context);
      }
    },
  );
}

/// 最上面的无限滚动的Banner和5个小按钮
Widget _generatorBannerWidget(BuildContext context, List<GalleryItem> gallertyItems, List<ComicItem> comicItems) {
  // 创建Banner和5个小按钮的容器
  Widget _generatorBannerContainer(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Image.network(gallertyItems[0].cover),
            color: Colors.red,
          ),
          Container(
            height: 80.0,
          ),
        ],
      )
    );
  }

  // 创建5个小按钮
  List<Column> _generatorColumns(BuildContext context) {
    return comicItems.map((comic) {
      print(comic.cover);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            child: Image(
              image: CachedNetworkImageProvider(comic.cover), 
              fit: BoxFit.cover
            ),
          ),
        ],
      );
    }).toList();
  }

  return Container(
    child: Stack(
      children: [
        _generatorBannerContainer(context),
        Positioned(
          bottom: 6.0,
          child: Container(
            height: 80.0,
            width: MediaQuery.of(context).size.width-0.001,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0), 
                topRight: Radius.circular(10.0)
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: _generatorColumns(context)
            ),
          ),
        )
      ],
    ),
  );
}

/// 创建Section Header
Widget _generatorSectionHeaderWidget(BuildContext context) {
  return ListTile(
    leading: Text(''),
    title: Center(
      child: Text('超人气作品', style: TextStyle(fontSize: 17.0)),
    ),
    trailing: Text('更多', style: TextStyle(fontSize: 13.0, color: Colors.grey)),
  );
}

const gallery = "gallery";
const comic = "comic";

abstract class DiscoverItem {}
class GalleryItem implements DiscoverItem{
  var linkType;
  var cover;
  var id;
  var title;

  GalleryItem.fromJSON({Map object}) {
    this.linkType = object["linkType"];
    this.cover = object["cover"];
    this.id = object["id"];
    this.title = object["title"];
  }
}

class ComicItem implements DiscoverItem {
  var cover;
  var name;
  var argName;
  var argValue;
  var argCon;
  var itemTitle;

  ComicItem.fromJSON({Map object}) {
    this.cover = object["cover"];
    this.name = object["name"];
    this.argName = object["cover"];
    this.argValue = object["argValue"];
    this.argCon = object["cover"];
    this.itemTitle = object["itemTitle"];
  }
}

class YYQRequest {
  static Future<Map<String, List<DiscoverItem>>> requestDiscover() async {
    final discoverMap = Map<String, List<DiscoverItem>>();
    const url = 'http://app.u17.com/v3/appV3_3/ios/phone/comic/getDetectList';
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    final data = json["data"];
    final returnData = data["returnData"];
    final galleryItems = returnData["galleryItems"];
    final galleryList = List<GalleryItem>();
    for (int i = 0; i < galleryItems.length; i++) {
      var item = GalleryItem.fromJSON(object: galleryItems[i]);
      galleryList.add(item);
    }
    discoverMap[gallery] = galleryList;

    final comicLists = returnData["comicLists"];
    final comicsObject = comicLists[0];
    final comics = comicsObject["comics"];
    final comicsItems = List<ComicItem>();
    for (int i = 0; i < comics.length; i++) {
      var item = ComicItem.fromJSON(object: comics[i]);
      comicsItems.add(item);
    }
    discoverMap[comic] = comicsItems;

    return discoverMap; 
  }
}