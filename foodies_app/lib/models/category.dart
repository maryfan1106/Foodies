import 'package:meta/meta.dart' show required;

class Category {
  final int cid;
  final String description;
  final int bias;

  const Category({
    @required this.cid,
    @required this.description,
    @required this.bias,
  });

  static Category fromJson(dynamic parsedJson) {
    return Category(
      cid: parsedJson['cid'],
      description: parsedJson['description'],
      bias: parsedJson['bias'],
    );
  }
}
