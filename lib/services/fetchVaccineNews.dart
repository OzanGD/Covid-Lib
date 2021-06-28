import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:covid_lib/models/Articles.dart';
import 'package:covid_lib/utils/nameToCode.dart';

Future<Articles> fetchVaccineNews(String countryName) async {
  String countryCode = nameToCode(countryName);
  if (countryCode == "null") {
    final response = await http.get(Uri.https('newsapi.org',
        '/v2/top-headlines?q=vaccine&apiKey=ee79d4972a0e41ad8234cc573886b4f2'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Articles.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  } else if (countryCode == "tr") {
    final response =
        await http.get(Uri.https('newsapi.org', '/v2/top-headlines', {
      'q': 'koronavirüs aşı',
      'apiKey': 'ee79d4972a0e41ad8234cc573886b4f2',
      'country': countryCode
    }));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Articles.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  } else {
    final response =
        await http.get(Uri.https('newsapi.org', '/v2/top-headlines', {
      'q': 'vaccine',
      'apiKey': 'ee79d4972a0e41ad8234cc573886b4f2',
      'country': countryCode
    }));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Articles.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }
}
