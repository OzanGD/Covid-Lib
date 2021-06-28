import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:covid_lib/models/ManyCountryData.dart';

Future<ManyCountryData> fetchManycountry(String sort) async {
  final response = await http.get(Uri.https('disease.sh',
      '/v3/covid-19/countries/', {'yesterday': 'true', 'sort': sort}));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ManyCountryData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}
