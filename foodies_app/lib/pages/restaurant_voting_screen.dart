import 'package:flutter/material.dart';

import '../models/restaurant.dart' show Restaurant;
import '../widgets/restaurant_card.dart' show RestaurantCard;

class RestaurantVotingScreen extends StatefulWidget {
  final List<Restaurant> restaurants;

  const RestaurantVotingScreen({
    @required this.restaurants,
  });

  @override
  _RestaurantVotingScreen createState() => _RestaurantVotingScreen();
}

class _RestaurantVotingScreen extends State<RestaurantVotingScreen> {
  Restaurant _vote;

  void _setVote(Restaurant restaurant) => setState(() => _vote = restaurant);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Restaurants'),
      ),
      body: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.restaurants.length,
            itemBuilder: (BuildContext context, int index) {
              final Restaurant restaurant = widget.restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                selected: restaurant == _vote,
                setVote: _setVote,
              );
            },
          ),
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
