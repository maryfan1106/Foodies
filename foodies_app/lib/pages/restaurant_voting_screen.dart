import 'package:flutter/material.dart';

import '../models/restaurant.dart' show Restaurant;
import '../services/votes.dart' show voteForRestaurant;
import '../widgets/restaurant_card.dart' show RestaurantCard;

class RestaurantVotingScreen extends StatefulWidget {
  final bool canVote;
  final int eid;
  final List<Restaurant> restaurants;

  const RestaurantVotingScreen({
    @required this.canVote,
    @required this.eid,
    @required this.restaurants,
  });

  @override
  _RestaurantVotingScreen createState() => _RestaurantVotingScreen();
}

class _RestaurantVotingScreen extends State<RestaurantVotingScreen> {
  Restaurant _vote;

  void _setVote(Restaurant restaurant) => setState(() => _vote = restaurant);

  Widget showResults = Column();

  @override
  Widget build(BuildContext context) {
    Widget showResults = ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.restaurants.length,
      itemBuilder: (BuildContext context, int index) {
        final Restaurant restaurant = widget.restaurants[index];
        return Card(
          color: index == 0 ? Theme.of(context).accentColor : null,
          child: ListTile(
            leading: Chip(
              label: Text(restaurant.votes.toString() + ' votes'),
            ),
            title: Text(restaurant.name),
            subtitle: index == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(restaurant.description),
                      Text(restaurant.address),
                      Text(restaurant.phone.toString()),
                    ],
                  )
                : Text(restaurant.description),
          ),
        );
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Recommended Restaurants'),
        ),
        body: widget.canVote
            ? Column(
                children: <Widget>[
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
                      child: ActionChip(
                        label: const Text(
                          'Vote',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          await voteForRestaurant(widget.eid, _vote.camis);
                          Navigator.pop(context);
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              )
            : showResults);
  }
}
