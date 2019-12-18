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
  JoyPage _model;
  bool _shouldShowLoader = true;

  final _client = Client();
  @override
  void initState() {
    super.initState();
    _get();
  }

  _get() async {
    showLoader();
    final response = await _client.get(joyURL);
    hideLoader();
    setState(() => _model = JoyPage(parse(response.body)));
  }

  void _nextPageHandler() async {
    showLoader();
    final response = await _client.get(_model.nextPageUrl);
    hideLoader();
    setState(() => _model = JoyPage(parse(response.body)));
  }

  void _prevPageHandler() async {
    showLoader();
    final response = await _client.get(_model.prevPageUrl);
    hideLoader();
    setState(() => _model = JoyPage(parse(response.body)));
  }

  void showLoader() => setState(() => _shouldShowLoader = true);

  void hideLoader() => setState(() => _shouldShowLoader = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _shouldShowLoader ?
        new Center(
          child: new CircularProgressIndicator(),
        ) :
        ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.orange,
            height: 30,
          ),
          itemCount: _model.posts.length,
          itemBuilder: (context, postIndex) {
            return new Post(model: _model.posts[postIndex]);
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
          onPressed: _shouldShowLoader ? null : _prevPageHandler,
          child: Text(
            "< Назад",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        FlatButton(
          color: Colors.orange,
          textColor: Colors.black,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.orange[900],
          onPressed: _shouldShowLoader ? null : _nextPageHandler,
          child: Text(
            "Дальше >",
            style: TextStyle(fontSize: 20.0),
          ),
        )
      ],
    );
  }
}
