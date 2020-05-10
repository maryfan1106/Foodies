import 'category.dart' show Category;

class CategoryMap {
  final Map<int, Category> _map;

  const CategoryMap(this._map);

  static CategoryMap fromJson(dynamic data) {
    final Map<int, Category> categoryMap = Map.fromIterable(
      data as List<dynamic>,
      key: (d) => d['cid'],
      value: Category.fromJson,
    );

    return CategoryMap(categoryMap);
  }

  operator [](int i) => _map[_map.keys.elementAt(i)];
  operator []=(int cid, int newBias) => _map[cid].bias = newBias;

  get length => _map.length;
}
