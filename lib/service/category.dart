import 'package:api_for_dart/src/core/module.dart';

import '../model/category.dart';

class CategoryModule extends Module<CategoryModel, int> {
  @override
  CategoryModel parser(Map<String, dynamic> json) => CategoryModel.fromJson(json);

  @override
  String get primary => 'id';

  @override
  String get table => 'category';
}
