import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show HttpHeaders;

import 'package:flutter_dotenv/flutter_dotenv.dart' show DotEnv;
import 'package:http/http.dart'
    show Client, Request, Response, StreamedResponse;
import 'package:meta/meta.dart' show protected, required;
import 'package:shared_preferences/shared_preferences.dart';

class FoodiesData {
  final int status;
  final dynamic body;

  const FoodiesData({
    @required this.status,
    @required this.body,
  });
}

final Client _client = Client(); // FIXME: we should close this, but when?

Future<String> _getToken() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString('token') ?? '';
}

@protected
Future<FoodiesData> foodiesPost(String endpoint,
    {Map data, Map<String, String> headers}) async {
  final Response res = await _client.post(
    DotEnv().env['API_BASEURL'] + endpoint,
    body: jsonEncode(data),
    headers: headers ??
        {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${await _getToken()}',
        },
  );

  return FoodiesData(status: res.statusCode, body: jsonDecode(res.body));
}

Future<dynamic> foodiesGet(String endpoint) async {
  final Request req = new Request(
    'GET',
    Uri.parse(DotEnv().env['API_BASEURL'] + endpoint),
  )
    ..followRedirects = false
    ..headers.addAll({
      HttpHeaders.authorizationHeader: 'Bearer ${await _getToken()}',
    });

  final StreamedResponse res = await _client.send(req);
  final String body = await res.stream.bytesToString();
  return FoodiesData(status: res.statusCode, body: jsonDecode(body));
}

Future<FoodiesData> foodiesPut(String endpoint, {Map data}) async {
  final Response res = await _client.put(
    DotEnv().env['API_BASEURL'] + endpoint,
    body: jsonEncode(data),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ${await _getToken()}',
    },
  );

  return FoodiesData(status: res.statusCode);
}
