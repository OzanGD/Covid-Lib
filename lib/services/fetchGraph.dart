import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:covid_lib/models/GraphFull.dart';

Future<GraphFull> fetchGraph(String country, String days) async {
  final response = await http.get(Uri.https(
      'disease.sh', '/v3/covid-19/historical/' + country, {'lastdays': days}));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return GraphFull.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}
