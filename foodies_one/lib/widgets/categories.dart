import 'package:flutter/material.dart';
import '../test_data_base.dart';

class Categories extends StatefulWidget {
  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  final Set<String> _likes = Set<String>();
  final Set<String> _dislikes = Set<String>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: allCategories.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final String category = allCategories[i];
          final bool alreadyLiked = _likes.contains(category);
          final bool alreadyDisliked = _dislikes.contains(category);
          return ListTile(
            leading: IconButton(
              icon: alreadyDisliked ? Icon(Icons.thumb_down) : Icon(Icons.thumb_down),
              color: alreadyDisliked? Colors.red : null,
              onPressed: alreadyLiked ? null : () {
                setState(() {
                  if (alreadyDisliked) {
                    _dislikes.remove(category);
                  } else {
                    _dislikes.add(category);
                  }
                });
              },
            ),
            title: Center(
              child: Text(category),
            ),
            trailing: IconButton(
              icon: alreadyLiked ? Icon(Icons.thumb_up) : Icon(Icons.thumb_up),
              color: alreadyLiked ? Colors.green : null,
              onPressed: alreadyDisliked ? null: () {
                setState(() {
                  if (alreadyLiked) {
                    _likes.remove(category);
                  } else {
                    _likes.add(category);
                  }
                });
              },
            ),
          );
        }
      ),
    );
  }
}

