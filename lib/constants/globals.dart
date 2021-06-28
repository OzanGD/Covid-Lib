import 'package:intl/intl.dart';
import 'package:covid_lib/models/CountryData.dart';
import 'package:covid_lib/models/GraphFull.dart';
import 'package:covid_lib/models/Articles.dart';
import 'package:covid_lib/models/ManyCountryData.dart';

final formatter = new NumberFormat("#,###,##0");

Future<CountryData> varCountryData;
Future<CountryData> yesterdayCountryData;
Future<GraphFull> varGraphData;
Future<GraphFull> varGraphData2;
Future<GraphFull> varGraphData3;

Future<Articles> newsData;
Future<Articles> vaccineData;

Future<ManyCountryData> allCases;
Future<ManyCountryData> allDead;

String countryName = 'world';
String flagUrl =
    "https://www.sketchappsources.com/resources/source-image/detailed-world-map.png";
String mapUrl = 'https://www.ilibrarian.net/flagmaps/world_map_large.jpg';

List<String> selectedCountries = <String>['Turkey', 'Germany'];
List<String> selectedFlags = <String>[
  'https://disease.sh/assets/img/flags/tr.png',
  'https://disease.sh/assets/img/flags/de.png'
];
List<String> selectedMaps = <String>[
  'https://www.ducksters.com/geography/flagmaps/tu-map.gif',
  'https://www.ducksters.com/geography/flagmaps/gm-map.gif'
];
