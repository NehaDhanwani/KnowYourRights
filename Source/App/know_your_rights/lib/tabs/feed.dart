import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:know_your_rights/data/category_data.dart';
import 'package:know_your_rights/data/category_presenter.dart';
import 'package:know_your_rights/data/items.dart';


void main() {
  runApp(new MaterialApp(
    home: new Feed(),
  ));
}

class Feed extends StatefulWidget {
  @override
  FeedState createState() {
    FeedState state = new FeedState();
    new CategoryListPresenter(state);
    return state;
  }

}

class FeedState extends State<Feed> implements CategoryListViewContract {


  static const String routeName = "/home";

  final _kHeightItem = 300.0;

  CategoryListPresenter _presenter;
  List<Category> _recipes;
  bool _isLoading;
  bool _isError = false;

  ScaffoldState _parentView;

  @override
  void setPresenter(CategoryListPresenter presenter) {
    _presenter = presenter;
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _presenter.loadCategorys();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    _parentView = Scaffold.of(context);

    if (_isLoading) {
      widget = new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new CircularProgressIndicator()
          )
      );
    } else {
      if (_isError || _recipes == null || _recipes.isEmpty) {
        widget = new Center(
            child: new Text("Error fetching server data")
        );
      } else {
        widget = new ListView(
            itemExtent: _kHeightItem,
            children: _buildCategorysWidgetList()
        );
      }
    }

    return widget;
  }

  @override
  void onLoadCategorysComplete(List<Category> recipes) {
    print("onLoadCategoriesCOmplete");
    print(recipes);

    setState(() {
      _recipes = recipes;
      _isLoading = false;
    });
  }


  @override
  void onLoadCategorysError() {
    setState(() {
      _isError = true;
    });
  }

  List<Widget> _buildCategorysWidgetList() {
    List<Widget> list = new List<Widget>();

    _recipes.forEach((recipe) =>
        list.add(new CategoryItem(recipe, _parentView)));
    return list;
  }

}
