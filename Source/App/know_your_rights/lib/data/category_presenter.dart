import 'package:know_your_rights/data/category_data.dart';
import 'package:know_your_rights/data/category_data_impl.dart';


abstract class CategoryListViewContract {
  void setPresenter(CategoryListPresenter presenter);

  void onLoadCategorysComplete(List<Category> recipes);

  void onLoadCategorysError();
}

abstract class CategoryListPresenterContract {
  void loadCategorys();
}

class CategoryListPresenter implements CategoryListPresenterContract {

  CategoryListViewContract _view;
  CategoryRepository _repository;

  CategoryListPresenter(this._view) {
    _repository = new RemoteCategoryRepository();
    _view.setPresenter(this);
  }

  @override
  void loadCategorys() {
    assert(_view != null); // Check that view is not null
    print("fetch categories...");
    _repository.fetch()
        .then((recipes) => _view.onLoadCategorysComplete(recipes))
        .catchError((onError) {
      print(onError);
      _view.onLoadCategorysError();
    });
  }

}