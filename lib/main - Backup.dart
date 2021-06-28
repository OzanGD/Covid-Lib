import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

final formatter = new NumberFormat("#,###,##0");

Future<CountryData> varCountryData;
Future<CountryData> yesterdayCountryData;
Future<GraphFull> varGraphData;
Future<GraphFull> varGraphData2;

Future<Articles> newsData;

String countryName = 'Turkey';
String flagUrl = 'https://disease.sh/assets/img/flags/tr.png';
String mapUrl = 'https://www.ducksters.com/geography/flagmaps/tu-map.gif';

List<String> selectedCountries = <String>['Turkey', 'Germany'];
List<String> selectedFlags = <String>[
  'https://disease.sh/assets/img/flags/tr.png',
  'https://disease.sh/assets/img/flags/de.png'
];
List<String> selectedMaps = <String>[
  'https://www.ducksters.com/geography/flagmaps/tu-map.gif',
  'https://www.ducksters.com/geography/flagmaps/gm-map.gif'
];

//      models/CountryData.dart

class CountryData {
  String country;
  String flag;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int population;

  CountryData({
    @required this.country,
    @required this.flag,
    @required this.cases,
    @required this.todayCases,
    @required this.deaths,
    @required this.todayDeaths,
    @required this.population,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      country: json['country'],
      flag: json['countryInfo.flag'],
      cases: json['cases'],
      todayCases: json['todayCases'],
      deaths: json['deaths'],
      todayDeaths: json['todayDeaths'],
      population: json['population'],
    );
  }
}

//      models/CountryData.dart

//WIP
// All converted

class GraphFull {
  GraphTimeline timeline;
  GraphFull({
    @required this.timeline,
  });
  factory GraphFull.fromJson(Map<String, dynamic> json) {
    return GraphFull(
      timeline: GraphTimeline.fromJson(json['timeline']),
    );
  }
}

class GraphTimeline {
  GraphCases graphCases;
  GraphCases graphDeaths;

  GraphTimeline({
    @required this.graphCases,
    @required this.graphDeaths,
  });
  factory GraphTimeline.fromJson(Map<String, dynamic> json) {
    return GraphTimeline(
      graphCases: GraphCases.fromJson(json['cases']),
      graphDeaths: GraphCases.fromJson(json['deaths']),
    );
  }
}

class GraphCases {
  List<String> dates;
  List<int> cases;

  GraphCases({
    @required this.dates,
    @required this.cases,
  });

  factory GraphCases.fromJson(Map<String, dynamic> json) {
    List<String> dateList = [];
    List<int> caseList = [];
    for (var date in json.keys) {
      dateList.add(date);
      caseList.add(json[date]);
    }
    for (var i = 0; i < caseList.length - 1; i++) {
      caseList[i] = caseList[i + 1] - caseList[i];
    }
    caseList.removeAt(caseList.length - 1);
    dateList.removeAt(0);
    return GraphCases(
      dates: dateList,
      cases: caseList,
    );
  }
}

// All converted

List<FlSpot> spotConverter(List<int> values) {
  List<FlSpot> spots = [];
  for (var item in values) {
    spots.add(new FlSpot(values.indexOf(item).toDouble(), item.toDouble()));
  }
  return spots;
}

LineChartData mainChartData(List<String> dates, List<int> spots) {
  List<Color> gradientColors = [
    const Color(0xffff4040),
    const Color(0xffff6060),
  ];
  List<int> numberTitles = new List<int>.from(spots);
  numberTitles.sort();
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        getTitles: (value) {
          if (value == 0)
            return dates[0];
          else if (value.toInt() == (dates.length ~/ 2).round())
            return dates[(dates.length ~/ 2).round()];
          else if (value.toInt() == (dates.length) - 1)
            return dates[(dates.length) - 1];
          else
            return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: defaultGetTitle,
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: dates.length.toDouble() - 1,
    minY: 0,
    maxY: numberTitles[numberTitles.length - 1].toDouble(),
    lineBarsData: [
      LineChartBarData(
        spots: spotConverter(spots),
        //    [FlSpot(0, 3), FlSpot(2.6, 2), FlSpot(4.9, 5), FlSpot(6.8, 3.1), FlSpot(8, 4), FlSpot(9.5, 3), FlSpot(11, 4),],
        isCurved: false, //true,
        colors: gradientColors,
        barWidth: 2,
        isStrokeCapRound: false, //true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}

// all imported

class Articles {
  List<Article> articles;

  Articles({
    @required this.articles,
  });

  factory Articles.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['articles'] as List;
    List<Article> articlesList = list.map((i) => Article.fromJson(i)).toList();

    return Articles(
      articles: articlesList,
    );
  }
}

//
class Article {
  String author;
  String title;
  String description;
  String url;
  String urlToImage;

  Article({
    @required this.author,
    @required this.title,
    @required this.description,
    @required this.url,
    @required this.urlToImage,
  });

  factory Article.fromJson(Map<String, dynamic> parsedJson) {
    return Article(
      author: parsedJson['author'],
      title: parsedJson['title'],
      description: parsedJson['description'],
      url: parsedJson['url'],
      urlToImage: parsedJson['urlToImage'],
    );
  }
}

// All imported

void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

void saveLocal() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList('selectedCountries', selectedCountries);
  prefs.setStringList('selectedFlags', selectedFlags);
}

void getLocal() async {
  final prefs = await SharedPreferences.getInstance();
  selectedCountries =
      prefs.getStringList('SelectedCountries') ?? <String>['Turkey', 'Germany'];
  selectedFlags = prefs.getStringList('SelectedFlags') ??
      <String>[
        'https://disease.sh/assets/img/flags/tr.png',
        'https://disease.sh/assets/img/flags/de.png'
      ];
  countryName = selectedCountries[0];
  flagUrl = selectedFlags[0];
}

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

Future<Articles> fetchNews(String countryName) async {
  String countryCode;
  switch (countryName) {
    case "Argentina":
      countryCode = "ar";
      break;
    case "Greece":
      countryCode = "gr";
      break;
    case "Netherlands":
      countryCode = "nl";
      break;
    case "South Africa":
      countryCode = "za";
      break;
    case "Australia":
      countryCode = "au";
      break;
    case "Hong Kong":
      countryCode = "hk";
      break;
    case "New Zealand":
      countryCode = "nz";
      break;
    case "South Korea":
      countryCode = "kr";
      break;
    case "Austria":
      countryCode = "at";
      break;
    case "Hungary":
      countryCode = "hu";
      break;
    case "Nigeria":
      countryCode = "ng";
      break;
    case "Sweden":
      countryCode = "se";
      break;
    case "Belgium":
      countryCode = "be";
      break;
    case "India":
      countryCode = "in";
      break;
    case "Norway":
      countryCode = "no";
      break;
    case "Switzerland":
      countryCode = "ch";
      break;
    case "Brazil":
      countryCode = "br";
      break;
    case "Indonesia":
      countryCode = "id";
      break;
    case "Philippines":
      countryCode = "ph";
      break;
    case "Taiwan":
      countryCode = "tw";
      break;
    case "Bulgaria":
      countryCode = "bg";
      break;
    case "Ireland":
      countryCode = "ie";
      break;
    case "Poland":
      countryCode = "pl";
      break;
    case "Thailand":
      countryCode = "th";
      break;
    case "Canada":
      countryCode = "ca";
      break;
    case "Israel":
      countryCode = "il";
      break;
    case "Portugal":
      countryCode = "pt";
      break;
    case "Turkey":
      countryCode = "tr";
      break;
    case "China":
      countryCode = "cn";
      break;
    case "Italy":
      countryCode = "it";
      break;
    case "Romania":
      countryCode = "ro";
      break;
    case "UAE":
      countryCode = "ae";
      break;
    case "Colombia":
      countryCode = "co";
      break;
    case "Japan":
      countryCode = "jp";
      break;
    case "Russia":
      countryCode = "ru";
      break;
    case "Ukraine":
      countryCode = "ua";
      break;
    case "Cuba":
      countryCode = "cu";
      break;
    case "Latvia":
      countryCode = "lv";
      break;
    case "Saudi Arabia":
      countryCode = "sa";
      break;
    case "UK":
      countryCode = "gb";
      break;
    case "Czechia":
      countryCode = "cz";
      break;
    case "Lithuania":
      countryCode = "lt";
      break;
    case "Serbia":
      countryCode = "rs";
      break;
    case "USA":
      countryCode = "us";
      break;
    case "Egypt":
      countryCode = "eg";
      break;
    case "Malaysia":
      countryCode = "my";
      break;
    case "Singapore":
      countryCode = "sg";
      break;
    case "Venuzuela":
      countryCode = "ve";
      break;
    case "France":
      countryCode = "fr";
      break;
    case "Mexico":
      countryCode = "mx";
      break;
    case "Slovakia":
      countryCode = "sk";
      break;
    case "Germany":
      countryCode = "de";
      break;
    case "Morocco":
      countryCode = "ma";
      break;
    case "Slovenia":
      countryCode = "si";
      break;
    default:
      countryCode = "null";
  }
  if (countryCode == "null") {
    final response = await http.get(Uri.https('newsapi.org',
        '/v2/top-headlines?q=covid&apiKey=ee79d4972a0e41ad8234cc573886b4f2'));

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
      'q': 'covid',
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

Future<CountryData> fetchCountry(String country, bool yesterday) async {
  if (yesterday == false) {
    final response = await http
        .get(Uri.https('disease.sh', '/v3/covid-19/countries/' + country));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CountryData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }
  if (yesterday == true) {
    final response = await http.get(Uri.https('disease.sh',
        '/v3/covid-19/countries/' + country, {'yesterday': 'true'}));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CountryData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }
}

Future<CountryData> fetchWorld() async {
  final response = await http.get(Uri.https('disease.sh', '/v3/covid-19/all'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CountryData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getLocal();
    varCountryData = fetchCountry(countryName, false);
    yesterdayCountryData = fetchCountry(countryName, true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CountryData>(
      future: varCountryData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.red,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomeScreen(),
    GraphsScreen(),
    NewsScreen(),
    CommentsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          newsData = fetchNews(countryName);
          break;
        case 3:
          break;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'GRAPHS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'NEWS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'COMMENTS',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        backgroundColor: Color(0xff6d6d6d),
        iconSize: 50.0,
        selectedFontSize: 15.0,
        unselectedFontSize: 15.0,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toBeginningOfSentenceCase(countryName)),
//        actions: <Widget>[
//          Padding(
//              padding: EdgeInsets.only(right: 20.0),
//              child: GestureDetector(
//                onTap: () {},
//                child: Icon(
//                  Icons.info,
//                  size: 26.0,
//                ),
//              )),
//        ],
        backgroundColor: Color(0xff1b1b1b),
      ),
      body: Container(
        color: Color(0xff424242),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(flagUrl),
                    ),
                    SizedBox(width: 10),
                    Text(
                      countryName.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FutureBuilder<CountryData>(
                      future: yesterdayCountryData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.todayCases > 10000) {
                            return RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: 'Risk: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                                TextSpan(
                                  text: 'HIGH',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 30,
                                  ),
                                ),
                              ]),
                            );
                          } else if (snapshot.data.todayCases > 1000) {
                            return RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: 'Risk: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Medium',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 30,
                                  ),
                                ),
                              ]),
                            );
                          } else {
                            return RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: 'Risk: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Low',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 30,
                                  ),
                                ),
                              ]),
                            );
                          }
                        }
                        return CircularProgressIndicator();
                      })),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: Image.network(mapUrl, fit: BoxFit.fitHeight),
                  )),
              Row(children: <Widget>[
                SizedBox(width: 30),
                Expanded(
                  child: Card(
                    color: Color(0xff6d6d6d),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ListTile(
                            title: Text(
                              'Cases Today',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: FutureBuilder(
                                future: Future.wait(
                                    [varCountryData, yesterdayCountryData]),
                                builder: (context,
                                    AsyncSnapshot<List<dynamic>> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data[0].todayCases == 0) {
                                      return Text(
                                        formatter
                                            .format(snapshot.data[1].todayCases)
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                    return Text(
                                      formatter
                                          .format(snapshot.data[0].todayCases)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }
                                  return CircularProgressIndicator();
                                })),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Color(0xff6d6d6d),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Cases Total',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: FutureBuilder<CountryData>(
                              future: varCountryData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        formatter
                                            .format(snapshot.data.cases)
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ));
                                }
                                return CircularProgressIndicator();
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 30),
              ]),
              Row(children: <Widget>[
                SizedBox(width: 30),
                Expanded(
                  child: Card(
                    color: Color(0xff6d6d6d),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Deaths Today',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: FutureBuilder(
                              future: Future.wait(
                                  [varCountryData, yesterdayCountryData]),
                              builder: (context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data[0].todayDeaths == 0) {
                                    return Text(
                                      formatter
                                          .format(snapshot.data[1].todayDeaths)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }
                                  return Text(
                                    formatter
                                        .format(snapshot.data[0].todayDeaths)
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                                return CircularProgressIndicator();
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Color(0xff6d6d6d),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Deaths Total',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: FutureBuilder<CountryData>(
                              future: varCountryData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    formatter
                                        .format(snapshot.data.deaths)
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                                return CircularProgressIndicator();
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 30),
              ]),
            ],
          ),
        ),
      ),
      drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: Container(
        color: Color(0xff424242),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Text(
                'Countries',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: Color(0xff8e8e8e),
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: selectedCountries.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('${selectedFlags[index]}'),
                    ),
                    title: Text(
                      '${selectedCountries[index]}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      setState(() {
                        countryName = '${selectedCountries[index]}';
                        flagUrl = '${selectedFlags[index]}';
                        mapUrl = '${selectedMaps[index]}';
                        varCountryData = fetchCountry(countryName, false);
                        yesterdayCountryData = fetchCountry(countryName, true);
                        saveLocal();
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
            ListTile(
              leading: Icon(
                Icons.add_circle,
                color: Color(0xff8e8e8e),
                size: 40.0,
              ),
              title: Text(
                'Add Country...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CountrySelect()),
                ).then((value) => setState(() => {}));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Text(
                'World',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: Color(0xff8e8e8e),
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/world-map.jpg'),
              ),
              title: Text(
                'Global Stats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                setState(() {
                  countryName = 'world';
                  flagUrl =
                      "https://www.sketchappsources.com/resources/source-image/detailed-world-map.png";
                  mapUrl =
                      'https://www.ilibrarian.net/flagmaps/world_map_large.jpg';
                  varCountryData = fetchWorld();
                });
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Text(
                'Covid-19 Information',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: Color(0xff8e8e8e),
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.error,
                color: Color(0xff8e8e8e),
                size: 40.0,
              ),
              title: Text(
                'Symptoms',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.error,
                color: Color(0xff8e8e8e),
                size: 40.0,
              ),
              title: Text(
                'Prevention',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.error,
                color: Color(0xff8e8e8e),
                size: 40.0,
              ),
              title: Text(
                'Treatments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )),
      endDrawer: Drawer(
        child: Container(
          color: Color(0xff424242),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Icon(Icons.coronavirus),
                Icon(
                  Icons.language,
                  color: Colors.white,
                  size: 180.0,
                ),
                Text(
                  'The Covid',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                Text(
                  'Library',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                Text(
                  'ver. 0.07',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 120),
                Text(
                  'Developed by',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Ozan Gündüz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Disable opening the end drawer with a swipe gesture.
      endDrawerEnableOpenDragGesture: false,
    );
  }
}

class GraphsScreen extends StatefulWidget {
  @override
  _GraphsScreenState createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  var pageCases = 1;
  var pageDeaths = 1;
  @override
  void initState() {
    super.initState();
    varGraphData = fetchGraph(countryName, '31');
    varGraphData2 = fetchGraph(countryName, '31');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(countryName + " Graphs"),
          backgroundColor: Color(0xff1b1b1b),
        ),
        body: ListView(children: <Widget>[
          Container(
              color: Color(0xff424242),
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        'Cases',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 5),
                            child: FlatButton(
                              color: (pageCases == 0)
                                  ? Color(0xff555555)
                                  : Color(0xff6d6d6d),
                              textColor: Colors.white,
                              disabledColor: Color(0xff555555),
                              disabledTextColor: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () {
                                setState(() {
                                  pageCases = 0;
                                  varGraphData = fetchGraph(countryName, '8');
                                });
                              },
                              child: Text(
                                "Weekly",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 5),
                            child: FlatButton(
                              color: (pageCases == 1)
                                  ? Color(0xff555555)
                                  : Color(0xff6d6d6d),
                              textColor: Colors.white,
                              disabledColor: Color(0xff555555),
                              disabledTextColor: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () {
                                setState(() {
                                  pageCases = 1;
                                  varGraphData = fetchGraph(countryName, '31');
                                });
                              },
                              child: Text(
                                "Monthly",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 5),
                            child: FlatButton(
                              color: (pageCases == 2)
                                  ? Color(0xff555555)
                                  : Color(0xff6d6d6d),
                              textColor: Colors.white,
                              disabledColor: Color(0xff555555),
                              disabledTextColor: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () {
                                setState(() {
                                  pageCases = 2;
                                  varGraphData = fetchGraph(countryName, 'all');
                                });
                              },
                              child: Text(
                                "All Time",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                        ]),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: SizedBox(
                        width: 350,
                        height: 200,
                        child: FutureBuilder<GraphFull>(
                            future: varGraphData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Stack(
                                  children: <Widget>[
                                    AspectRatio(
                                      aspectRatio: 1.70,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(3),
                                            ),
                                            color: Color(0xff1b1b1b)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 18.0,
                                              left: 12.0,
                                              top: 24,
                                              bottom: 12),
                                          child: LineChart(
                                            mainChartData(
                                              snapshot.data.timeline.graphCases
                                                  .dates,
                                              snapshot.data.timeline.graphCases
                                                  .cases,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return CircularProgressIndicator();
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        'Deaths',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 5),
                            child: FlatButton(
                              color: (pageDeaths == 0)
                                  ? Color(0xff555555)
                                  : Color(0xff6d6d6d),
                              textColor: Colors.white,
                              disabledColor: Color(0xff555555),
                              disabledTextColor: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () {
                                setState(() {
                                  pageDeaths = 0;
                                  varGraphData2 = fetchGraph(countryName, '8');
                                });
                              },
                              child: Text(
                                "Weekly",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 5),
                            child: FlatButton(
                              color: (pageDeaths == 1)
                                  ? Color(0xff555555)
                                  : Color(0xff6d6d6d),
                              textColor: Colors.white,
                              disabledColor: Color(0xff555555),
                              disabledTextColor: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () {
                                setState(() {
                                  pageDeaths = 1;
                                  varGraphData2 = fetchGraph(countryName, '31');
                                });
                              },
                              child: Text(
                                "Monthly",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 5),
                            child: FlatButton(
                              color: (pageDeaths == 2)
                                  ? Color(0xff555555)
                                  : Color(0xff6d6d6d),
                              textColor: Colors.white,
                              disabledColor: Color(0xff555555),
                              disabledTextColor: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () {
                                setState(() {
                                  pageDeaths = 2;
                                  varGraphData2 =
                                      fetchGraph(countryName, 'all');
                                });
                              },
                              child: Text(
                                "All Time",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                        ]),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: SizedBox(
                        width: 350,
                        height: 200,
                        child: FutureBuilder<GraphFull>(
                            future: varGraphData2,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Stack(
                                  children: <Widget>[
                                    AspectRatio(
                                      aspectRatio: 1.70,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(3),
                                            ),
                                            color: Color(0xff1b1b1b)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 18.0,
                                              left: 12.0,
                                              top: 24,
                                              bottom: 12),
                                          child: LineChart(
                                            mainChartData(
                                              snapshot.data.timeline.graphDeaths
                                                  .dates,
                                              snapshot.data.timeline.graphDeaths
                                                  .cases,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return CircularProgressIndicator();
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ])),
        ]));
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    fetchNews(countryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(countryName + " News"),
        backgroundColor: Color(0xff1b1b1b),
      ),
      body: Container(
          color: Color(0xff424242),
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: FutureBuilder<Articles>(
                      future: newsData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: snapshot.data.articles.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Card(
                                    color: Color(0xff6d6d6d),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ListTile(
                                          title: Row(children: <Widget>[
                                            SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: (snapshot
                                                          .data
                                                          .articles[index]
                                                          .urlToImage !=
                                                      null)
                                                  ? Image.network(snapshot
                                                      .data
                                                      .articles[index]
                                                      .urlToImage)
                                                  : Image.asset(
                                                      'images/placeholder-icon.png'),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot
                                                    .data.articles[index].title,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ]),
                                          subtitle: Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: (snapshot
                                                        .data
                                                        .articles[index]
                                                        .description !=
                                                    null)
                                                ? Text(
                                                    snapshot
                                                        .data
                                                        .articles[index]
                                                        .description,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  )
                                                : Text(
                                                    '',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            FlatButton(
                                              child: const Text(
                                                'READ MORE',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              onPressed: () => launchURL(
                                                  snapshot.data.articles[index]
                                                      .url),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                        return CircularProgressIndicator();
                      }),
                )
              ])),
    );
  }
}

class CommentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Turkey Comments"),
          backgroundColor: Color(0xff1b1b1b),
        ),
        body: ListView(children: <Widget>[
          Container(
              color: Color(0xff424242),
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        color: Color(0xff6d6d6d),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: Row(children: <Widget>[
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      AssetImage('images/placeholder-icon.png'),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Ali Velioğlu',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'City: İstanbul',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ]),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Comment goes here.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        color: Color(0xff6d6d6d),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: Row(children: <Widget>[
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      AssetImage('images/placeholder-icon.png'),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Ayşe Ayşeoğlu',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'City: İzmir',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ]),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Comment goes here.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        color: Color(0xff6d6d6d),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: Row(children: <Widget>[
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      AssetImage('images/placeholder-icon.png'),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Ahmet Mehmetoğlu',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'City: Edirne',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ]),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Comment goes here.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        color: Color(0xff6d6d6d),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: Row(children: <Widget>[
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      AssetImage('images/placeholder-icon.png'),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Veli Alioğlu',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'City: Ankara',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ]),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Comment goes here.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ])),
        ]));
  }
}

final List<String> listFlags = <String>[
  "https://disease.sh/assets/img/flags/ad.png",
  "https://disease.sh/assets/img/flags/ae.png",
  "https://disease.sh/assets/img/flags/af.png",
  "https://disease.sh/assets/img/flags/ag.png",
  "https://disease.sh/assets/img/flags/ai.png",
  "https://disease.sh/assets/img/flags/al.png",
  "https://disease.sh/assets/img/flags/am.png",
  "https://disease.sh/assets/img/flags/ao.png",
  "https://disease.sh/assets/img/flags/ar.png",
  "https://disease.sh/assets/img/flags/at.png",
  "https://disease.sh/assets/img/flags/au.png",
  "https://disease.sh/assets/img/flags/aw.png",
  "https://disease.sh/assets/img/flags/az.png",
  "https://disease.sh/assets/img/flags/ba.png",
  "https://disease.sh/assets/img/flags/bb.png",
  "https://disease.sh/assets/img/flags/bd.png",
  "https://disease.sh/assets/img/flags/be.png",
  "https://disease.sh/assets/img/flags/bf.png",
  "https://disease.sh/assets/img/flags/bg.png",
  "https://disease.sh/assets/img/flags/bh.png",
  "https://disease.sh/assets/img/flags/bi.png",
  "https://disease.sh/assets/img/flags/bj.png",
  "https://disease.sh/assets/img/flags/bl.png",
  "https://disease.sh/assets/img/flags/bm.png",
  "https://disease.sh/assets/img/flags/bn.png",
  "https://disease.sh/assets/img/flags/bo.png",
  "https://disease.sh/assets/img/flags/bq.png",
  "https://disease.sh/assets/img/flags/br.png",
  "https://disease.sh/assets/img/flags/bs.png",
  "https://disease.sh/assets/img/flags/bt.png",
  "https://disease.sh/assets/img/flags/bw.png",
  "https://disease.sh/assets/img/flags/by.png",
  "https://disease.sh/assets/img/flags/bz.png",
  "https://disease.sh/assets/img/flags/ca.png",
  "https://disease.sh/assets/img/flags/cd.png",
  "https://disease.sh/assets/img/flags/cf.png",
  "https://disease.sh/assets/img/flags/cg.png",
  "https://disease.sh/assets/img/flags/ch.png",
  "https://disease.sh/assets/img/flags/ci.png",
  "https://disease.sh/assets/img/flags/cl.png",
  "https://disease.sh/assets/img/flags/cm.png",
  "https://disease.sh/assets/img/flags/cn.png",
  "https://disease.sh/assets/img/flags/co.png",
  "https://disease.sh/assets/img/flags/cr.png",
  "https://disease.sh/assets/img/flags/cu.png",
  "https://disease.sh/assets/img/flags/cv.png",
  "https://disease.sh/assets/img/flags/cw.png",
  "https://disease.sh/assets/img/flags/cy.png",
  "https://disease.sh/assets/img/flags/cz.png",
  "https://disease.sh/assets/img/flags/de.png",
  "https://disease.sh/assets/img/flags/dj.png",
  "https://disease.sh/assets/img/flags/dk.png",
  "https://disease.sh/assets/img/flags/dm.png",
  "https://disease.sh/assets/img/flags/do.png",
  "https://disease.sh/assets/img/flags/dz.png",
  "https://disease.sh/assets/img/flags/ec.png",
  "https://disease.sh/assets/img/flags/ee.png",
  "https://disease.sh/assets/img/flags/eg.png",
  "https://disease.sh/assets/img/flags/eh.png",
  "https://disease.sh/assets/img/flags/er.png",
  "https://disease.sh/assets/img/flags/es.png",
  "https://disease.sh/assets/img/flags/et.png",
  "https://disease.sh/assets/img/flags/fi.png",
  "https://disease.sh/assets/img/flags/fj.png",
  "https://disease.sh/assets/img/flags/fk.png",
  "https://disease.sh/assets/img/flags/fm.png",
  "https://disease.sh/assets/img/flags/fo.png",
  "https://disease.sh/assets/img/flags/fr.png",
  "https://disease.sh/assets/img/flags/ga.png",
  "https://disease.sh/assets/img/flags/gb.png",
  "https://disease.sh/assets/img/flags/gd.png",
  "https://disease.sh/assets/img/flags/ge.png",
  "https://disease.sh/assets/img/flags/gf.png",
  "https://disease.sh/assets/img/flags/gh.png",
  "https://disease.sh/assets/img/flags/gi.png",
  "https://disease.sh/assets/img/flags/gl.png",
  "https://disease.sh/assets/img/flags/gm.png",
  "https://disease.sh/assets/img/flags/gn.png",
  "https://disease.sh/assets/img/flags/gp.png",
  "https://disease.sh/assets/img/flags/gq.png",
  "https://disease.sh/assets/img/flags/gr.png",
  "https://disease.sh/assets/img/flags/gt.png",
  "https://disease.sh/assets/img/flags/gw.png",
  "https://disease.sh/assets/img/flags/gy.png",
  "https://disease.sh/assets/img/flags/hk.png",
  "https://disease.sh/assets/img/flags/hn.png",
  "https://disease.sh/assets/img/flags/hr.png",
  "https://disease.sh/assets/img/flags/ht.png",
  "https://disease.sh/assets/img/flags/hu.png",
  "https://disease.sh/assets/img/flags/id.png",
  "https://disease.sh/assets/img/flags/ie.png",
  "https://disease.sh/assets/img/flags/il.png",
  "https://disease.sh/assets/img/flags/im.png",
  "https://disease.sh/assets/img/flags/in.png",
  "https://disease.sh/assets/img/flags/iq.png",
  "https://disease.sh/assets/img/flags/ir.png",
  "https://disease.sh/assets/img/flags/is.png",
  "https://disease.sh/assets/img/flags/it.png",
  "https://disease.sh/assets/img/flags/je.png",
  "https://disease.sh/assets/img/flags/jm.png",
  "https://disease.sh/assets/img/flags/jo.png",
  "https://disease.sh/assets/img/flags/jp.png",
  "https://disease.sh/assets/img/flags/ke.png",
  "https://disease.sh/assets/img/flags/kg.png",
  "https://disease.sh/assets/img/flags/kh.png",
  "https://disease.sh/assets/img/flags/km.png",
  "https://disease.sh/assets/img/flags/kn.png",
  "https://disease.sh/assets/img/flags/kr.png",
  "https://disease.sh/assets/img/flags/kw.png",
  "https://disease.sh/assets/img/flags/ky.png",
  "https://disease.sh/assets/img/flags/kz.png",
  "https://disease.sh/assets/img/flags/la.png",
  "https://disease.sh/assets/img/flags/lb.png",
  "https://disease.sh/assets/img/flags/lc.png",
  "https://disease.sh/assets/img/flags/li.png",
  "https://disease.sh/assets/img/flags/lk.png",
  "https://disease.sh/assets/img/flags/lr.png",
  "https://disease.sh/assets/img/flags/ls.png",
  "https://disease.sh/assets/img/flags/lt.png",
  "https://disease.sh/assets/img/flags/lu.png",
  "https://disease.sh/assets/img/flags/lv.png",
  "https://disease.sh/assets/img/flags/ly.png",
  "https://disease.sh/assets/img/flags/ma.png",
  "https://disease.sh/assets/img/flags/mc.png",
  "https://disease.sh/assets/img/flags/md.png",
  "https://disease.sh/assets/img/flags/me.png",
  "https://disease.sh/assets/img/flags/mf.png",
  "https://disease.sh/assets/img/flags/mg.png",
  "https://disease.sh/assets/img/flags/mh.png",
  "https://disease.sh/assets/img/flags/mk.png",
  "https://disease.sh/assets/img/flags/ml.png",
  "https://disease.sh/assets/img/flags/mm.png",
  "https://disease.sh/assets/img/flags/mn.png",
  "https://disease.sh/assets/img/flags/mo.png",
  "https://disease.sh/assets/img/flags/mq.png",
  "https://disease.sh/assets/img/flags/mr.png",
  "https://disease.sh/assets/img/flags/ms.png",
  "https://disease.sh/assets/img/flags/mt.png",
  "https://disease.sh/assets/img/flags/mu.png",
  "https://disease.sh/assets/img/flags/mv.png",
  "https://disease.sh/assets/img/flags/mw.png",
  "https://disease.sh/assets/img/flags/mx.png",
  "https://disease.sh/assets/img/flags/my.png",
  "https://disease.sh/assets/img/flags/mz.png",
  "https://disease.sh/assets/img/flags/na.png",
  "https://disease.sh/assets/img/flags/nc.png",
  "https://disease.sh/assets/img/flags/ne.png",
  "https://disease.sh/assets/img/flags/ng.png",
  "https://disease.sh/assets/img/flags/ni.png",
  "https://disease.sh/assets/img/flags/nl.png",
  "https://disease.sh/assets/img/flags/no.png",
  "https://disease.sh/assets/img/flags/np.png",
  "https://disease.sh/assets/img/flags/nz.png",
  "https://disease.sh/assets/img/flags/om.png",
  "https://disease.sh/assets/img/flags/pa.png",
  "https://disease.sh/assets/img/flags/pe.png",
  "https://disease.sh/assets/img/flags/pf.png",
  "https://disease.sh/assets/img/flags/pg.png",
  "https://disease.sh/assets/img/flags/ph.png",
  "https://disease.sh/assets/img/flags/pk.png",
  "https://disease.sh/assets/img/flags/pl.png",
  "https://disease.sh/assets/img/flags/pm.png",
  "https://disease.sh/assets/img/flags/ps.png",
  "https://disease.sh/assets/img/flags/pt.png",
  "https://disease.sh/assets/img/flags/py.png",
  "https://disease.sh/assets/img/flags/qa.png",
  "https://disease.sh/assets/img/flags/re.png",
  "https://disease.sh/assets/img/flags/ro.png",
  "https://disease.sh/assets/img/flags/rs.png",
  "https://disease.sh/assets/img/flags/ru.png",
  "https://disease.sh/assets/img/flags/rw.png",
  "https://disease.sh/assets/img/flags/sa.png",
  "https://disease.sh/assets/img/flags/sb.png",
  "https://disease.sh/assets/img/flags/sc.png",
  "https://disease.sh/assets/img/flags/sd.png",
  "https://disease.sh/assets/img/flags/se.png",
  "https://disease.sh/assets/img/flags/sg.png",
  "https://disease.sh/assets/img/flags/si.png",
  "https://disease.sh/assets/img/flags/sk.png",
  "https://disease.sh/assets/img/flags/sl.png",
  "https://disease.sh/assets/img/flags/sm.png",
  "https://disease.sh/assets/img/flags/sn.png",
  "https://disease.sh/assets/img/flags/so.png",
  "https://disease.sh/assets/img/flags/sr.png",
  "https://disease.sh/assets/img/flags/ss.png",
  "https://disease.sh/assets/img/flags/st.png",
  "https://disease.sh/assets/img/flags/sv.png",
  "https://disease.sh/assets/img/flags/sx.png",
  "https://disease.sh/assets/img/flags/sy.png",
  "https://disease.sh/assets/img/flags/sz.png",
  "https://disease.sh/assets/img/flags/tc.png",
  "https://disease.sh/assets/img/flags/td.png",
  "https://disease.sh/assets/img/flags/tg.png",
  "https://disease.sh/assets/img/flags/th.png",
  "https://disease.sh/assets/img/flags/tj.png",
  "https://disease.sh/assets/img/flags/tl.png",
  "https://disease.sh/assets/img/flags/tn.png",
  "https://disease.sh/assets/img/flags/tr.png",
  "https://disease.sh/assets/img/flags/tt.png",
  "https://disease.sh/assets/img/flags/tw.png",
  "https://disease.sh/assets/img/flags/tz.png",
  "https://disease.sh/assets/img/flags/ua.png",
  "https://disease.sh/assets/img/flags/ug.png",
  "https://disease.sh/assets/img/flags/unknown.png",
  "https://disease.sh/assets/img/flags/unknown.png",
  "https://disease.sh/assets/img/flags/us.png",
  "https://disease.sh/assets/img/flags/uy.png",
  "https://disease.sh/assets/img/flags/uz.png",
  "https://disease.sh/assets/img/flags/va.png",
  "https://disease.sh/assets/img/flags/vc.png",
  "https://disease.sh/assets/img/flags/ve.png",
  "https://disease.sh/assets/img/flags/vg.png",
  "https://disease.sh/assets/img/flags/vn.png",
  "https://disease.sh/assets/img/flags/vu.png",
  "https://disease.sh/assets/img/flags/wf.png",
  "https://disease.sh/assets/img/flags/ws.png",
  "https://disease.sh/assets/img/flags/ye.png",
  "https://disease.sh/assets/img/flags/yt.png",
  "https://disease.sh/assets/img/flags/za.png",
  "https://disease.sh/assets/img/flags/zm.png",
  "https://disease.sh/assets/img/flags/zw.png"
];

final List<String> listCountries = <String>[
  "Andorra",
  "UAE",
  "Afghanistan",
  "Antigua and Barbuda",
  "Anguilla",
  "Albania",
  "Armenia",
  "Angola",
  "Argentina",
  "Austria",
  "Australia",
  "Aruba",
  "Azerbaijan",
  "Bosnia",
  "Barbados",
  "Bangladesh",
  "Belgium",
  "Burkina Faso",
  "Bulgaria",
  "Bahrain",
  "Burundi",
  "Benin",
  "St. Barth",
  "Bermuda",
  "Brunei",
  "Bolivia",
  "Caribbean Netherlands",
  "Brazil",
  "Bahamas",
  "Bhutan",
  "Botswana",
  "Belarus",
  "Belize",
  "Canada",
  "DRC",
  "Central African Republic",
  "Congo",
  "Switzerland",
  "Côte d'Ivoire",
  "Chile",
  "Cameroon",
  "China",
  "Colombia",
  "Costa Rica",
  "Cuba",
  "Cabo Verde",
  "Curaçao",
  "Cyprus",
  "Czechia",
  "Germany",
  "Djibouti",
  "Denmark",
  "Dominica",
  "Dominican Republic",
  "Algeria",
  "Ecuador",
  "Estonia",
  "Egypt",
  "Western Sahara",
  "Eritrea",
  "Spain",
  "Ethiopia",
  "Finland",
  "Fiji",
  "Falkland Islands (Malvinas)",
  "Micronesia",
  "Faroe Islands",
  "France",
  "Gabon",
  "UK",
  "Grenada",
  "Georgia",
  "French Guiana",
  "Ghana",
  "Gibraltar",
  "Greenland",
  "Gambia",
  "Guinea",
  "Guadeloupe",
  "Equatorial Guinea",
  "Greece",
  "Guatemala",
  "Guinea-Bissau",
  "Guyana",
  "Hong Kong",
  "Honduras",
  "Croatia",
  "Haiti",
  "Hungary",
  "Indonesia",
  "Ireland",
  "Israel",
  "Isle of Man",
  "India",
  "Iraq",
  "Iran",
  "Iceland",
  "Italy",
  "Channel Islands",
  "Jamaica",
  "Jordan",
  "Japan",
  "Kenya",
  "Kyrgyzstan",
  "Cambodia",
  "Comoros",
  "Saint Kitts and Nevis",
  "S. Korea",
  "Kuwait",
  "Cayman Islands",
  "Kazakhstan",
  "Lao People's Democratic Republic",
  "Lebanon",
  "Saint Lucia",
  "Liechtenstein",
  "Sri Lanka",
  "Liberia",
  "Lesotho",
  "Lithuania",
  "Luxembourg",
  "Latvia",
  "Libyan Arab Jamahiriya",
  "Morocco",
  "Monaco",
  "Moldova",
  "Montenegro",
  "Saint Martin",
  "Madagascar",
  "Marshall Islands",
  "Macedonia",
  "Mali",
  "Myanmar",
  "Mongolia",
  "Macao",
  "Martinique",
  "Mauritania",
  "Montserrat",
  "Malta",
  "Mauritius",
  "Maldives",
  "Malawi",
  "Mexico",
  "Malaysia",
  "Mozambique",
  "Namibia",
  "New Caledonia",
  "Niger",
  "Nigeria",
  "Nicaragua",
  "Netherlands",
  "Norway",
  "Nepal",
  "New Zealand",
  "Oman",
  "Panama",
  "Peru",
  "French Polynesia",
  "Papua New Guinea",
  "Philippines",
  "Pakistan",
  "Poland",
  "Saint Pierre Miquelon",
  "Palestine",
  "Portugal",
  "Paraguay",
  "Qatar",
  "Réunion",
  "Romania",
  "Serbia",
  "Russia",
  "Rwanda",
  "Saudi Arabia",
  "Solomon Islands",
  "Seychelles",
  "Sudan",
  "Sweden",
  "Singapore",
  "Slovenia",
  "Slovakia",
  "Sierra Leone",
  "San Marino",
  "Senegal",
  "Somalia",
  "Suriname",
  "South Sudan",
  "Sao Tome and Principe",
  "El Salvador",
  "Sint Maarten",
  "Syrian Arab Republic",
  "Swaziland",
  "Turks and Caicos Islands",
  "Chad",
  "Togo",
  "Thailand",
  "Tajikistan",
  "Timor-Leste",
  "Tunisia",
  "Turkey",
  "Trinidad and Tobago",
  "Taiwan",
  "Tanzania",
  "Ukraine",
  "Uganda",
  "Diamond Princess",
  "MS Zaandam",
  "USA",
  "Uruguay",
  "Uzbekistan",
  "Holy See (Vatican City State)",
  "Saint Vincent and the Grenadines",
  "Venezuela",
  "British Virgin Islands",
  "Vietnam",
  "Vanuatu",
  "Wallis and Futuna",
  "Samoa",
  "Yemen",
  "Mayotte",
  "South Africa",
  "Zambia",
  "Zimbabwe"
];

final List<String> listMaps = <String>[
  "Andorra",
  "UAE",
  "Afghanistan",
  "Antigua and Barbuda",
  "Anguilla",
  "Albania",
  "Armenia",
  "Angola",
  "Argentina",
  "Austria",
  "https://www.ducksters.com/geography/flagmaps/as-map.gif",
  "Aruba",
  "Azerbaijan",
  "Bosnia",
  "Barbados",
  "Bangladesh",
  "Belgium",
  "Burkina Faso",
  "Bulgaria",
  "Bahrain",
  "Burundi",
  "Benin",
  "St. Barth",
  "Bermuda",
  "Brunei",
  "Bolivia",
  "Caribbean Netherlands",
  "https://www.ducksters.com/geography/flagmaps/br-map.gif",
  "Bahamas",
  "Bhutan",
  "Botswana",
  "Belarus",
  "Belize",
  "Canada",
  "DRC",
  "Central African Republic",
  "Congo",
  "Switzerland",
  "Côte d'Ivoire",
  "Chile",
  "Cameroon",
  "China",
  "Colombia",
  "Costa Rica",
  "Cuba",
  "Cabo Verde",
  "Curaçao",
  "Cyprus",
  "Czechia",
  "https://www.ducksters.com/geography/flagmaps/gm-map.gif",
  "Djibouti",
  "Denmark",
  "Dominica",
  "Dominican Republic",
  "Algeria",
  "Ecuador",
  "Estonia",
  "Egypt",
  "Western Sahara",
  "Eritrea",
  "Spain",
  "Ethiopia",
  "Finland",
  "Fiji",
  "Falkland Islands (Malvinas)",
  "Micronesia",
  "Faroe Islands",
  "France",
  "Gabon",
  "UK",
  "Grenada",
  "Georgia",
  "French Guiana",
  "Ghana",
  "Gibraltar",
  "Greenland",
  "Gambia",
  "Guinea",
  "Guadeloupe",
  "Equatorial Guinea",
  "Greece",
  "Guatemala",
  "Guinea-Bissau",
  "Guyana",
  "Hong Kong",
  "Honduras",
  "Croatia",
  "Haiti",
  "Hungary",
  "Indonesia",
  "Ireland",
  "Israel",
  "Isle of Man",
  "India",
  "Iraq",
  "Iran",
  "Iceland",
  "Italy",
  "Channel Islands",
  "Jamaica",
  "Jordan",
  "Japan",
  "Kenya",
  "Kyrgyzstan",
  "Cambodia",
  "Comoros",
  "Saint Kitts and Nevis",
  "S. Korea",
  "Kuwait",
  "Cayman Islands",
  "Kazakhstan",
  "Lao People's Democratic Republic",
  "Lebanon",
  "Saint Lucia",
  "Liechtenstein",
  "Sri Lanka",
  "Liberia",
  "Lesotho",
  "Lithuania",
  "Luxembourg",
  "Latvia",
  "Libyan Arab Jamahiriya",
  "Morocco",
  "Monaco",
  "Moldova",
  "Montenegro",
  "Saint Martin",
  "Madagascar",
  "Marshall Islands",
  "Macedonia",
  "Mali",
  "Myanmar",
  "Mongolia",
  "Macao",
  "Martinique",
  "Mauritania",
  "Montserrat",
  "Malta",
  "Mauritius",
  "Maldives",
  "Malawi",
  "Mexico",
  "Malaysia",
  "Mozambique",
  "Namibia",
  "New Caledonia",
  "Niger",
  "Nigeria",
  "Nicaragua",
  "Netherlands",
  "Norway",
  "Nepal",
  "New Zealand",
  "Oman",
  "Panama",
  "Peru",
  "French Polynesia",
  "Papua New Guinea",
  "Philippines",
  "Pakistan",
  "Poland",
  "Saint Pierre Miquelon",
  "Palestine",
  "Portugal",
  "Paraguay",
  "Qatar",
  "Réunion",
  "Romania",
  "Serbia",
  "Russia",
  "Rwanda",
  "Saudi Arabia",
  "Solomon Islands",
  "Seychelles",
  "Sudan",
  "Sweden",
  "Singapore",
  "Slovenia",
  "Slovakia",
  "Sierra Leone",
  "San Marino",
  "Senegal",
  "Somalia",
  "Suriname",
  "South Sudan",
  "Sao Tome and Principe",
  "El Salvador",
  "Sint Maarten",
  "Syrian Arab Republic",
  "Swaziland",
  "Turks and Caicos Islands",
  "Chad",
  "Togo",
  "Thailand",
  "Tajikistan",
  "Timor-Leste",
  "Tunisia",
  "https://www.ducksters.com/geography/flagmaps/tu-map.gif",
  "Trinidad and Tobago",
  "Taiwan",
  "Tanzania",
  "Ukraine",
  "Uganda",
  "Diamond Princess",
  "MS Zaandam",
  "USA",
  "Uruguay",
  "Uzbekistan",
  "Holy See (Vatican City State)",
  "Saint Vincent and the Grenadines",
  "Venezuela",
  "British Virgin Islands",
  "Vietnam",
  "Vanuatu",
  "Wallis and Futuna",
  "Samoa",
  "Yemen",
  "Mayotte",
  "South Africa",
  "Zambia",
  "Zimbabwe"
];

class CountrySelect extends StatefulWidget {
  CountrySelect({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _CountrySelectState createState() => _CountrySelectState();
}

class _CountrySelectState extends State<CountrySelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Country"),
          backgroundColor: Color(0xff1b1b1b),
        ),
        body: Container(
            color: Color(0xff424242),
            width: double.infinity,
            child: Column(
              children: [
                Row(children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Text(
                      'Remove Countries',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
                ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: selectedCountries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        color: Color(0xff424242),
                        height: 50,
                        child: TextButton.icon(
                            label: Row(children: [
                              Text('${selectedCountries[index]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              Icon(Icons.close, color: Colors.red)
                            ]),
                            icon: CircleAvatar(
                              backgroundImage:
                                  NetworkImage('${selectedFlags[index]}'),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xff6d6d6d),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedCountries.removeAt(index);
                                selectedFlags.removeAt(index);
                                selectedMaps.removeAt(index);
                                saveLocal();
                              });
                            }),
                      );
                    }),
                Divider(
                  color: Color(0xff8e8e8e),
                  thickness: 2,
                  indent: 10,
                  endIndent: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: listCountries.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          color: Color(0xff424242),
                          height: 50,
                          child: TextButton.icon(
                              label: Row(children: [
                                Text('${listCountries[index]}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ]),
                              icon: CircleAvatar(
                                backgroundImage:
                                    NetworkImage('${listFlags[index]}'),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xff6d6d6d),
                              ),
                              onPressed: () {
                                // Update the state of the app
                                // ...
                                // Then close the drawer
                                setState(() {
                                  selectedCountries
                                      .add('${listCountries[index]}');
                                  selectedFlags.add('${listFlags[index]}');
                                  selectedMaps.add('${listMaps[index]}');
                                  countryName = '${listCountries[index]}';
                                  flagUrl = '${listFlags[index]}';
                                  mapUrl = '${listMaps[index]}';
                                  varCountryData =
                                      fetchCountry(countryName, false);
                                  yesterdayCountryData =
                                      fetchCountry(countryName, true);
                                  saveLocal();
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()),
                                );
                              }),
                        );
                      }),
                ),
              ],
            )));
  }
}
