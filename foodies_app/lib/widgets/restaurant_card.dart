import 'package:flutter/material.dart';

import '../models/restaurant.dart' show Restaurant;

class RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantCard({
    @required this.restaurant,
  });

  @override
  _RestaurantCardState createState() => new _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              widget.restaurant.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Center(
            child: Text(
              widget.restaurant.address,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Center(
            child: Text(
              widget.restaurant.phone.toString(),
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
