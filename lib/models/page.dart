import 'package:html/dom.dart';
import 'package:test2/core/global/global.dart';

import 'post.dart';


class JoyPage {
  static const nextPageSelector = '.next';
  static const postsSelector = '.postContainer';

  final Element nextButtonElement;
  final List<JoyPost> posts;

  String get nextPageUrl => joyURL + nextButtonElement.attributes['ref'];
  String get allURL => '$joyURL/all';
  String get goodURL => '$joyURL/';
  String get bestURL => '$joyURL/best';

  JoyPage(Document rootElement) :
    nextButtonElement = rootElement.querySelector(nextPageSelector),
    posts = rootElement.querySelectorAll(postsSelector).map((postContainer) => JoyPost(postContainer)).toList();
}