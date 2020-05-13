import 'dart:io' show HttpStatus;

import '../models/categorymap.dart' show CategoryMap;
import 'foodiesapi.dart' show FoodiesData, foodiesGet, foodiesPut;

Future<CategoryMap> getCategories() async {
  FoodiesData fdata = await foodiesGet('/categories');

  switch (fdata.status) {
    case HttpStatus.found:
      CategoryMap categoryMap = CategoryMap.fromJson(fdata.body);
      return categoryMap;
  }

  return null;
}

Future<bool> setBias(int cid, int bias) async {
  final FoodiesData fdata =
      await foodiesPut('/categories/$cid', data: {'bias': bias});

  switch (fdata.status) {
    case HttpStatus.noContent:
      return true;
  }
  return false;
}
