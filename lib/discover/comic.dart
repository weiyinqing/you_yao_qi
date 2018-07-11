import 'package:flutter/material.dart';
import 'discoverModel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ComicWidget15 extends StatelessWidget {
  final ComicModel comicModel;
  ComicWidget15({Key key, this.comicModel}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          _generatorTitleWidget(context, comicModel.itemTitle, comicModel.description),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: 320.0,
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              childAspectRatio: 0.9,
              children: comicModel.comics.map<Widget>((comic) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        image: CachedNetworkImageProvider(comic.cover),
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(comic.name, style: TextStyle(fontSize: 15.0)),
                            Text(comic.shortDescription, style: TextStyle(fontSize: 12.0, color: Colors.grey))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


Widget _generatorTitleWidget(BuildContext context, String title, String des) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(""),
        Container(
          padding: EdgeInsets.only(left: 38.0),
          child: Text(title, style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: EdgeInsets.only(right: 10.0),
          child: Text(des, style: TextStyle(color: Colors.grey, fontSize: 13.0)),
        ),
      ],
    ),
  );
}