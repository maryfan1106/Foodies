import 'dart:io' show HttpStatus;

import '../models/category.dart' show Category;
import 'foodiesapi.dart' show FoodiesData, foodiesGet;

Future<List<Category>> getCategories() async {
  FoodiesData fdata = await foodiesGet('/categories');

  switch (fdata.status) {
    case HttpStatus.found:
      List<Category> categories = fdata.body.map(Category.fromJson).toList();
      return categories;
  }

  return [];
}
