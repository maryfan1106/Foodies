import 'package:flutter/material.dart';

import '../models/restaurant.dart' show Restaurant;

class RestaurantVotingScreen extends StatefulWidget {
  final List<Restaurant> restaurants;

  const RestaurantVotingScreen({
    @required this.restaurants,
  });

  @override
  _RestaurantVotingScreen createState() => _RestaurantVotingScreen();
}

class _RestaurantVotingScreen extends State<RestaurantVotingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Restaurants'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 90.0,
            child: Center(
              child: RaisedButton(
                child: const Text('Vote'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
