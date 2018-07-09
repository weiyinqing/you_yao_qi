import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:banner/banner.dart';

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
    itemCount: 3,
    itemBuilder: (context, index) {
      if (index == 0) {
        final gallerys = map[gallery];
        final categorys = map[category];
        return _generatorBannerWidget(context, gallerys, categorys);
      } else {
        final contents = map[content];
        print(contents.length);
        return _generatorContentWidget(context, contents[index-1]);
      }
    },
  );
}

/// 最上面的无限滚动的Banner和5个小按钮
Widget _generatorBannerWidget(
  BuildContext context,
  List<GalleryItem> gallertyItems, 
  List<ComicCategaryItem> categorys
  ) {
  // 创建Banner和5个小按钮的容器
  Widget _generatorBannerContainer(BuildContext context) {
    final fix = MediaQuery.of(context).size.width / 645.0;
    final imageHeight = fix * 415.0;
    return Container(
      child: Column(
        children: [
          Container(
            child: BannerView(
              height: imageHeight,
              data: gallertyItems,
              onBannerClickListener: (index, data) {
                print(data);
              },
              buildShowView: (index, data) {
                return Image(
                  image: CachedNetworkImageProvider(data.cover),
                  fit: BoxFit.cover,
                );
              },
            )
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
    return categorys.map((category) {
      print(category.cover);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            child: Image(
              image: CachedNetworkImageProvider(category.cover), 
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

/// 创建Section Content Widget
Widget _generatorContentWidget(
  BuildContext context, 
  ComicContentItem content
  ) {
  Widget _generatorArgValue1() {
    return Column(
        children: <Widget>[
          ListTile(
            leading: Text(''),
            title: Center(
              child: Text(content.itemTitle, style: TextStyle(fontSize: 17.0)),
            ),
            trailing: Text(content.description, style: TextStyle(fontSize: 13.0, color: Colors.grey)),
          ),
          Container(
            height: 350.0,
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              children: content.comicItems.map<Widget>((comic) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(image: CachedNetworkImageProvider(comic.cover), fit: BoxFit.fitWidth),
                      Container(
                        padding: EdgeInsets.only(top: 12.0, left: 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(comic.name, style: TextStyle(fontSize: 17.0)),
                            Text(comic.shortDescription, style: TextStyle(color: Colors.grey))
                          ],
                        ),
                      )
                    ],
                  ),  
                );
              }).toList()
            ),
          )
          
        ],
      );
  }

  Widget _generatorArgValue2() {
    return Column(
        children: <Widget>[
          ListTile(
            leading: Text(''),
            title: Center(
              child: Text(content.itemTitle, style: TextStyle(fontSize: 17.0)),
            ),
            trailing: Text(content.description, style: TextStyle(fontSize: 13.0, color: Colors.grey)),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Image(image: CachedNetworkImageProvider(content.comicItems[0].cover)),
                  ),
                  Text(content.comicItems[0].name),
                ],
              ),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width-30)/3,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(image: CachedNetworkImageProvider(content.comicItems[1].cover), fit: BoxFit.cover),
                      Text(content.comicItems[1].name, style: TextStyle(fontSize: 17.0)),
                      Text(content.comicItems[1].shortDescription, style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width-30)/3,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(image: CachedNetworkImageProvider(content.comicItems[2].cover), fit: BoxFit.cover),
                      Text(content.comicItems[2].name, style: TextStyle(fontSize: 17.0)),
                      Text(content.comicItems[2].shortDescription, style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width-30)/3,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(image: CachedNetworkImageProvider(content.comicItems[1].cover), fit: BoxFit.cover),
                      Text(content.comicItems[2].name, style: TextStyle(fontSize: 17.0)),
                      Text(content.comicItems[2].shortDescription, style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ],
          )
        ]
    );
  }

  if (int.parse(content.argValue) == 1) {
    return _generatorArgValue1();
  } else if(int.parse(content.argValue) == 2) {
    return _generatorArgValue2();
  }
}

const gallery = "gallery";
const category = "category";
const content = "content";

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

class ComicCategaryItem implements DiscoverItem {
  var cover;
  var name;
  var argName;
  var argValue;
  var argCon;
  var itemTitle;

  ComicCategaryItem.fromJSON({Map object}) {
    this.cover = object["cover"];
    this.name = object["name"];
    this.argName = object["cover"];
    this.argValue = object["argValue"];
    this.argCon = object["cover"];
    this.itemTitle = object["itemTitle"];
  }
}

class ComicContentItem implements DiscoverItem {
  var titleIconUrl;
  var newTitleIconUrl;
  var itemTitle;
  var description;
  var sortId;
  var argName;
  var argValue;
  var comicItems; 

  ComicContentItem.fromJSON({Map object}) {
    this.titleIconUrl = object["titleIconUrl"];
    this.newTitleIconUrl = object["newTitleIconUrl"];
    this.itemTitle = object["itemTitle"];
    this.description = object["description"];
    this.sortId = object["sortId"];
    this.argName = object["argName"];
    this.argValue = object["argValue"];
  }
}
class ComicItem {
  var comicId;
  var name;
  var cover;
  var shortDescription;

  ComicItem.fromJSON({Map object}) {
    this.comicId = object["comicId"];
    this.name = object["name"];
    this.cover = object["cover"];
    this.shortDescription = object["short_description"];
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
    final categoryList = List<ComicCategaryItem>();
    final contentList = List<ComicContentItem>();
    for (int i = 0; i < galleryItems.length; i++) {
      var item = GalleryItem.fromJSON(object: galleryItems[i]);
      galleryList.add(item);
    }

    final comicLists = returnData["comicLists"];
    for (int i = 0; i < comicLists.length; i++) {
      if (i == 0) {
        final comicsObject = comicLists[i];
        final comics = comicsObject["comics"];
        for (int i = 0; i < comics.length; i++) {
          var item = ComicCategaryItem.fromJSON(object: comics[i]);
          categoryList.add(item);
        }
        
      } else {
        final comicsObject = comicLists[i];
        final comics = comicsObject["comics"];
        var contentItem = ComicContentItem.fromJSON(object: comicsObject);
        contentItem.comicItems = List<ComicItem>();
        for (int j = 0; j < comics.length; j++) {
          final comicsObject2 = comics[j];
          final comicItem = ComicItem.fromJSON(object: comicsObject2);
          contentItem.comicItems.add(comicItem);
        }
        contentList.add(contentItem);
      }
    }

    discoverMap[gallery] = galleryList;
    discoverMap[category] = categoryList;
    discoverMap[content] = contentList;

    return discoverMap; 
  }
}