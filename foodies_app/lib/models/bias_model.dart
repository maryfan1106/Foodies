class Bias {
  final int cid;
  final String description;
  final double bias;

  Bias({
    this.cid,
    this.description,
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
