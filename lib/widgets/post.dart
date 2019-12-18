
import 'package:flutter/material.dart';
import 'package:test2/models/post.dart';

class Post extends StatefulWidget {
  final JoyPost model;

  Post({Key key, this.model}) : super(key: key);

  @override
  createState() => _PostState();
}

class _PostState extends State<Post> {

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Icon(
        Icons.star,
        color: Colors.red[500],
      ),
      Text(widget.model.rating)
    ];

    children.add(new Row(children: widget.model.tags.map((tag) => Chip(label: new Text(tag.title))).toList()));
    children.addAll(widget.model.images.map((img) => Image.network(img)).toList());

    return new Column(
      children: children,
    );
  }
}
