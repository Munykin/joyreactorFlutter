import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as DOM;

const joyURL = 'http://joyreactor.cc';

void main() async {
  var posts = await initiate();
  runApp(MyApp(
    posts: posts
  ));
}

Future<List<JoyPost>> initiate() async {
  // Make API call to Hackernews homepage
  var client = Client();
  Response response = await client.get(joyURL);

  // Use html parser
  var document = parse(response.body);
  List<DOM.Element> posts = document.querySelectorAll('.postContainer');

  return posts.map((postContainer) => JoyPost(postContainer)).toList();
}

class MyApp extends StatelessWidget {
  final List<JoyPost> posts;

  MyApp({Key key, @required this.posts}) : super(key: key);

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
          itemCount: posts.length,
          itemBuilder: (context, postIndex) {
            List<Widget> children = [
                Icon(
                  Icons.star,
                  color: Colors.red[500],
                ),
                Text(posts[postIndex].rating)
              ];

            // new Row(children: posts[postIndex].tags.map((tag) => Chip(label: new Text(tag.title))).toList());
            children.add(new Row(children: posts[postIndex].tags.map((tag) => Chip(label: new Text(tag.title))).toList()));
            children.addAll(posts[postIndex].images.map((img) => Image.network(img)).toList());

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
  final Iterable<JoyPost> posts;

  String get nextPageUrl => joyURL + nextButtonElement.attributes['ref'];
  String get allURL => '$joyURL/all';
  String get goodURL => '$joyURL/';
  String get bestURL => '$joyURL/best';

  JoyPage(DOM.Element rootElement) :
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
