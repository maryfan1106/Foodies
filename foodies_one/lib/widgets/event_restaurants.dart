import 'package:flutter/material.dart';
import 'package:foodiesone/models/restaurant_model.dart';
import '../test_data_base.dart';

class EventRestaurants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            )
        ),
        child: ListView.builder(
          itemCount: allRestaurants.length,
          itemBuilder: (BuildContext context, int index) {
            final Restaurant restaurant = allRestaurants[index];
            return Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
