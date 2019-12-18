import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';

import 'core/global/global.dart';
import 'models/page.dart';
import 'widgets/page.dart';


void main() async {
  var joyPage = await initiate();
  runApp(MyApp(
    joyPage: joyPage
  ));
}

Future<JoyPage> initiate() async {
  var client = Client();
  final response = await client.get(joyURL);
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
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.new_releases)),
                Tab(icon: Icon(Icons.linked_camera)),
                Tab(icon: Icon(Icons.thumb_up)),
              ],
            ),
            title: Text('JoyReactor'),
          ),
          body: TabBarView(
            children: [
              Page(url: joyURL),
              Page(url: joyURL),
              Page(url: joyURL)
            ],
          ),
        ),
      ),
    );
  }
}
