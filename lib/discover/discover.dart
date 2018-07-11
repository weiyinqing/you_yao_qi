import 'package:flutter/material.dart';
import '../request/request.dart';
import '../discover/discoverModel.dart';
import 'banner.dart';
import '../discover/category.dart';

class DiscoverWidget extends StatefulWidget {
  _DiscoverWidget createState() => _DiscoverWidget();
}
class _DiscoverWidget extends State<DiscoverWidget> {
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: YYQRequest.requestDiscover(),
      builder: (context, snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasData) {
              return _createDiscoverListView(context, snapshot.data);
            } else {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
        }
      },
    );
  }
}

/// 创建ListView
Widget _createDiscoverListView(BuildContext context, DiscoverResult result) {
  // print("result.galleryItems.length = ${result.galleryItems.length}");
  return ListView.builder(
    itemCount: 2,
    itemBuilder: (context, index) {
      if (index == 0) {
        final list = result.galleryItems.map<String>((gallery) {
          return gallery.cover;
        }).toList();
        list.add(result.galleryItems[0].cover);
        return BannerWidget(list);
      } else if (index == 1) {
        return CategoryWidget(list: result.categoryList);
      } else {

      }
    },
  );
}