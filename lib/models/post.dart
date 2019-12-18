import 'package:html/dom.dart';

import 'tag.dart';

class JoyPost {
  static const tagListSelector = '.taglist a';
  static const imageSelector = '.post_content img';
  static const ratingSelector = '.post_rating span';

  final Element _rootElement;

  List<JoyTag> tags;
  List<String> images;
  String rating;

  JoyPost(this._rootElement) {
    tags = _rootElement.querySelectorAll(tagListSelector).map((tagRaw) =>
      JoyTag(
        tagRaw.attributes['title'], tagRaw.attributes['href'])
      ).toList();
    images = _rootElement.querySelectorAll(imageSelector).map((img) => img.attributes['src']).toList();
    rating = _rootElement.querySelector(ratingSelector).text;
  }
}
