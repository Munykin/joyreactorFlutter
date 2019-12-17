import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as DOM;

const joyURL = 'http://joyreactor.cc';

void main() async {
  var joyPage = await initiate();
  runApp(MyApp(
    joyPage: joyPage
  ));
}

Future<JoyPage> initiate() async {
  var client = Client();
  Response response = await client.get(joyURL);
  return JoyPage(parse(response.body));
}

class MyApp extends StatelessWidget {
  final JoyPage joyPage;

  MyApp({Key key, @required this.joyPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'JoyReactor';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: joyPage.posts.length,
          itemBuilder: (context, postIndex) {
            List<Widget> children = [
                Icon(
                  Icons.star,
                  color: Colors.red[500],
                ),
                Text(joyPage.posts[postIndex].rating)
              ];

            // new Row(children: posts[postIndex].tags.map((tag) => Chip(label: new Text(tag.title))).toList());
            children.add(new Row(children: joyPage.posts[postIndex].tags.map((tag) => Chip(label: new Text(tag.title))).toList()));
            children.addAll(joyPage.posts[postIndex].images.map((img) => Image.network(img)).toList());

            return Column(

                children: children

            );
          },
        ),
      ),
    );
  }
}

class JoyPost {
  static const tagListSelector = '.taglist a';
  static const imageSelector = '.post_content img';
  static const ratingSelector = '.post_rating span';

  final DOM.Element _rootElement;

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

class JoyPage {
  static const nextPageSelector = '.next';
  static const postsSelector = '.postContainer';

  final DOM.Element nextButtonElement;
  final List<JoyPost> posts;

  String get nextPageUrl => joyURL + nextButtonElement.attributes['ref'];
  String get allURL => '$joyURL/all';
  String get goodURL => '$joyURL/';
  String get bestURL => '$joyURL/best';

  JoyPage(DOM.Document rootElement) :
    nextButtonElement = rootElement.querySelector(nextPageSelector),
    posts = rootElement.querySelectorAll(postsSelector).map((postContainer) => JoyPost(postContainer)).toList();
}

class JoyTag extends Link {
  JoyTag(title, href): super(title, href);
}

abstract class Link {
  final title;
  final href;

  Link(this.title, this.href);
}
