import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Event {
  final String name;
  final members;
  Event(this.name, this.members);
}

List<Event> allEvents = [
  Event('Kellys Birthday', ['Jolyne','Erica','Liam','Brian','Stacy']),
  Event('Saturday Hangout', ['Jolyne','Bob','Jeffrey','Doug','Kit']),
  Event('Drinks w/ coworkers', ['Marco','Justin','Stephanie','Jessica','Carol']),
  Event('Graduation party', ['Emilia','Carlos','Cesar','Amy','Kat'])
];

List<String> allCategories = [
  'Burgers','Pizza','Sushi','Ham','Nuts','Thats right jeffrey nuts is a valid category','Ramen','Halal','Curry','Korean','American','Chinese'
];

void main() {
  runApp(MaterialApp(
    title: 'Foodies',
    theme: ThemeData(
        primaryColor: Colors.white
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(events: allEvents),
      '/profilePage': (context) => ProfilePage(),
      '/createEventPage': (context) => CreateEventPage(),
    },
  ));
}

class HomePage extends StatelessWidget {
  final List<Event> events;

  HomePage({Key key, @required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Profile"),
              onPressed: () {
                Navigator.pushNamed(context, '/profilePage');
              },
            ),
            RaisedButton(
              child: Text("Add Event"),
              onPressed: () {
                Navigator.pushNamed(context, '/createEventPage');
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(events[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventScreen(),
                        settings: RouteSettings(
                          arguments: events[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        )
      )
    );
  }
}

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Event event = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(event.name),
        ),
        body: ListView.builder(
            itemCount: event.members.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              return _memberRow(event.members[index]);
            })
    );
  }
}

Widget _memberRow(String member) {
  return ListTile(
      title: Text(
          member,
          style: TextStyle(fontSize: 18.0)
      )
  );
}

class CreateEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event"),
      ),
      body: CreateEventForm()
    );
  }
}

class CreateEventForm extends StatefulWidget {
  @override
  CreateEventFormState createState() {
    return CreateEventFormState();
  }
}

class CreateEventFormState extends State<CreateEventForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Event Name'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter event name';
              }
              return null;
            },
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter guests';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  allEvents.add(Event('Newly added event',['Friend 1','Friend 2']));
                  // TODO dumb bitch fix this
                  Navigator.pushNamed(context, '/');
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Categories()
    );
  }
}

class Categories extends StatefulWidget {
  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  final _categories = allCategories;
  final Set<String> _saved = Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildCategories() {
    return ListView.builder(
        itemCount: _categories.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          return _buildRow(_categories[i]);
        });
  }

  Widget _buildRow(String category) {
    final bool alreadySaved = _saved.contains(category);
    return ListTile(
      title: Text(
        category,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(category);
          } else {
            _saved.add(category);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildCategories(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (String category) {
              return ListTile(
                title: Text(
                  category,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Liked Categories'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}