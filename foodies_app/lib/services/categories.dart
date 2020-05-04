import 'dart:io' show HttpStatus;

import '../models/category.dart' show Category;
import 'foodiesapi.dart' show FoodiesData, foodiesGet, foodiesPut;

Future<List<Category>> getCategories() async {
  FoodiesData fdata = await foodiesGet('/categories');

  switch (fdata.status) {
    case HttpStatus.found:
      List<Category> categories = fdata.body.map<Category>(Category.fromJson).toList();
      return categories;
  }
  return [];
}

Future<bool> setBias(int cid, int bias) async {
  final FoodiesData fdata = await foodiesPut('/categories/$cid', data: {'bias': bias});

  switch (fdata.status) {
    case HttpStatus.noContent:
      return true;
  }
  return false;
}
