import 'package:flutter/material.dart';

import '../models/restaurant.dart' show Restaurant;

class RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  final bool selected;
  final Function setVote;

  const RestaurantCard({
    @required this.restaurant,
    @required this.selected,
    @required this.setVote,
  });

  @override
  _RestaurantCardState createState() => new _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.selected ? Colors.lightBlueAccent : null,
      child: InkWell(
        onTap: () => widget.setVote(widget.restaurant),
        child: ListTile(
          title: Text(widget.restaurant.name),
          subtitle: Text(widget.restaurant.description),
        ),
      ),
    );
  }
}
