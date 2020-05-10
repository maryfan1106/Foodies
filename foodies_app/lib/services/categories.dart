import 'dart:io' show HttpStatus;

import '../models/categorymap.dart' show CategoryMap;
import 'foodiesapi.dart' show FoodiesData, foodiesGet;

Future<CategoryMap> getCategories() async {
  FoodiesData fdata = await foodiesGet('/categories');

  switch (fdata.status) {
    case HttpStatus.found:
      CategoryMap categoryMap = CategoryMap.fromJson(fdata.body);
      return categoryMap;
  }

  return null;
}
