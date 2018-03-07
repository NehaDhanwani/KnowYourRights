import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(new MaterialApp(
    home: new Feed(),
  ));
}

class Category extends StatelessWidget {
  final List data;

  Category(this.data);

  Widget build(BuildContext context) {
    return new CustomScrollView(
      slivers: <Widget>[
        new SliverGrid(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
            crossAxisCount: 2,
          ),
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return new Container(
                constraints: new BoxConstraints.expand(
                  height: 200.0,
                ),
                alignment: Alignment.bottomLeft,
                padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new NetworkImage(
                        'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: new Text(data[index]["name"],
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    )
                ),
              );
            },
            childCount: data.length,
          ),
        ),
      ],
    );
  }
}

class Feed extends StatefulWidget {
  @override
  FeedState createState() => new FeedState();

}

class FeedState extends State<Feed> {
  Future<http.Response> _response;

  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _response = http.get(
          'http://100.64.145.79:9000/kyr/category'
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed: _refresh,
      ),
      body: new Center(
          child: new FutureBuilder(
              future: _response,
              builder: (BuildContext context,
                  AsyncSnapshot<http.Response> response) {
                List data = JSON.decode(response.data.body);
                if (data != null)
                  return new Category(data);
                else
                  return new Text('service error: $json.');
              }
          )
      ),
    );
  }

}
