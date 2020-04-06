import 'package:flutter/material.dart';
import 'package:foodiesapp/widgets/create_event_form.dart';

//    // GET /users/:email
//    final client = http.Client();
//    String testEmail = "julian@gmail.com";
//    final request = new http.Request('GET', Uri.parse("http://localhost:3000/users/$testEmail"));
//    request.headers['Authorization'] = "Bearer " + sharedPreferences.getString("token");
//    request.headers['Accept'] = "application/json";
//    request.headers['Content-type'] = "application/json";
//    request.followRedirects = false;
//    final response = await client.send(request);
//    final respStr = await response.stream.bytesToString();
//    var jsonResponse = jsonDecode(respStr);
//    User user = new User.fromJson(jsonResponse);
//    print(user);

class CreateEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CreateEventForm(),
    );
  }
}