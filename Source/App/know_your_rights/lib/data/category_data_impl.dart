import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:know_your_rights/data/category_data.dart';
import 'dart:io';

class RemoteCategoryRepository implements CategoryRepository {

  static const _apiKEY = "e43509260e518431d4ebf809b0a4cd1f"; // Paste here your API Key
  static const _apiURL = "http://demo1519874.mockable.io/getCategories";// + _apiKEY;

  final JsonDecoder _decoder = new JsonDecoder();

  @override
  Future<List<Category>> fetch() async {
    var response = await http.get(Uri.parse(_apiURL));

    print(response.body);
    var jsonBody = JSON.decode(response.body);
    print(jsonBody);
    final statusCode = response.statusCode;

    if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
      throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:${response}]");
    }

    final recipesContainer = _decoder.convert(jsonBody);
    final List recipeItems = recipesContainer['categories'];
    print(recipeItems[1]);
    return recipeItems.map((contactRaw) => new Category.fromMap(contactRaw))
        .toList();
  }

}