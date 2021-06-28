import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants/globals.dart';
import 'utils/getLocal.dart';
import 'services/fetchCountry.dart';
import 'services/fetchWorld.dart';
import 'models/CountryData.dart';
import 'screens/MyHomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    getLocal();
    countryName = 'world';
    flagUrl =
        "https://www.sketchappsources.com/resources/source-image/detailed-world-map.png";
    mapUrl = 'https://www.ilibrarian.net/flagmaps/world_map_large.jpg';
    //(countryName != '')
    //    ? varCountryData = fetchCountry(countryName, false)
    //    : varCountryData = fetchCountry('Turkey', false);
    varCountryData = fetchWorld();
    //(countryName != '')
    //    ? yesterdayCountryData = fetchCountry(countryName, true)
    //    : varCountryData = fetchCountry('Turkey', true);
    yesterdayCountryData = fetchWorld();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([varCountryData, _initialization]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'The Covid Library',
            theme: ThemeData(
              primarySwatch: Colors.red,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage(title: 'Home Page'),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
