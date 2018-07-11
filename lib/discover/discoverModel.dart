abstract class DiscoverModel {}

class DiscoverResult {
  int code;
  int stateCode;
  String message;
  List<GalleryModel> galleryItems;
  List<CategoryModel> categoryList;

  DiscoverResult({this.code, this.stateCode, this.message, this.galleryItems, this.categoryList});
}

class GalleryModel extends DiscoverModel {
  int linkType;
  String cover;
  int id;
  String title;
  String content;
  List<_GalleryExt> exts;

  GalleryModel.fromJSON(Map covariant) {
    this.linkType = covariant["linkType"];
    this.cover = covariant["cover"];
    this.id = covariant["id"];
    this.title = covariant["title"];
    this.content = covariant["content"];
    this.exts = List<_GalleryExt>();
    final tempExts = covariant["ext"];
    for (int i = 0; i < tempExts.length; i++) {
      final ext = _GalleryExt.fromJSON(tempExts[i]);
      this.exts.add(ext);
    }
  }
}
class _GalleryExt {
  String key;
  var val;

  _GalleryExt.fromJSON(Map covariant) {
    this.key = covariant["key"];
    this.val = covariant["val"];
  }
}

class CategoryModel extends DiscoverModel {
  var cover;
  var name;
  var argName;
  var argValue;
  var itemTitle;

  CategoryModel.fromJSON(Map covariant) {
    this.cover = covariant["cover"];
    this.name = covariant["name"];
    this.argName = covariant["argName"];
    this.argValue = covariant["argValue"];
    this.itemTitle = covariant["itemTitle"];
  }
}