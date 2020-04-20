import 'package:flutter/material.dart';
import 'package:foodiesapp/models/event_details_model.dart';
import 'package:foodiesapp/services/event_service.dart';

class RestaurantVotingScreen extends StatefulWidget {
  final int eid;
  final List<Restaurant> restaurants;
  RestaurantVotingScreen({
    this.eid,
    this.restaurants,
  });

  @override
  _RestaurantVotingScreen createState() => _RestaurantVotingScreen();
}

class _RestaurantVotingScreen extends State<RestaurantVotingScreen> {
  Restaurant _vote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text('Recommended Restaurants',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.restaurants.length,
            itemBuilder: (BuildContext context, int index) {
              final Restaurant restaurant =  widget.restaurants[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _vote = restaurant;
                  });
                },
                child: Card(
                  color: restaurant==_vote ? Colors.lightBlueAccent : null,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        Center(
                          child: Text(
                            restaurant.address,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        Center(
                          child: Text(
                            restaurant.phone.toString(),
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            height: 90.0,
            child: Center(
                child: RaisedButton(
                  child: Text(
                    'Vote',
                  ),
                  onPressed: () async {
                    await EventService().voteForRestaurant(widget.eid, _vote.camis);
                    Navigator.pop(context);
                  },
                )
            ),
          ),
        ],
      ),
    );
  }
}