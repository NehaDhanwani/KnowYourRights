import 'dart:async';

class Category {

  final String name;
  final String imageURL;
  final String description;

  const Category({this.name, this.imageURL, this.description});

  Category.fromMap(Map<String, dynamic> map)
      :
        name = "${map['name']}",
        imageURL = "${map['imageUrl']}",
        description = "${map['description']}";

}

abstract class CategoryRepository {
  Future<List<Category>> fetch();
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}