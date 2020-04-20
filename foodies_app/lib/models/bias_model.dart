import 'package:meta/meta.dart';

class Bias {
  final int cid;
  final String description;
  final int bias;

  const Bias({
    @required this.cid,
    @required this.description,
    this.bias,
  });

  factory Bias.fromJson(Map<String, dynamic> parsedJson) {
    return Bias(
      cid: parsedJson['cid'],
      description: parsedJson['description'],
      bias: parsedJson['bias'],
    );
  }
}
