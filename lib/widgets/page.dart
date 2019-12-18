import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:test2/core/global/global.dart';
import 'package:test2/models/page.dart';
import 'package:test2/widgets/post.dart';

class Page extends StatefulWidget {
  final String url;

  Page({Key key, this.url}) : super(key: key);

  @override
  createState() => _PageState();
}

class _PageState extends State<Page> {
  JoyPage model;

  @override
  void initState() {
    super.initState();
    _get();
  }

  _get() async {
    var client = Client();
    final response = await client.get(joyURL);

    setState(() => model = JoyPage(parse(response.body)));
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        body: ListView.builder(
          itemCount: model.posts.length,
          itemBuilder: (context, postIndex) {
            return new Post(model: model.posts[postIndex]);
          },
        ),
        persistentFooterButtons: <Widget>[
          FlatButton(
            color: Colors.orange,
            textColor: Colors.black,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.orange[900],
            onPressed: () {},
            child: Text(
              "Дальше >",
              style: TextStyle(fontSize: 20.0),
            ),
          )
        ],
      );
    }
  }
}
