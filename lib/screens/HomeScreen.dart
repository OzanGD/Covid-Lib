import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:covid_lib/constants/globals.dart';
import 'package:covid_lib/models/CountryData.dart';
import 'package:covid_lib/services/fetchCountry.dart';
import 'package:covid_lib/services/fetchWorld.dart';
import 'package:covid_lib/utils/saveLocal.dart';
import 'package:covid_lib/screens/CountrySelect.dart';
import 'package:covid_lib/screens/SymptomsScreen.dart';
import 'package:covid_lib/screens/PreventionScreen.dart';
import 'package:covid_lib/screens/TreatmentsScreen.dart';
import 'package:covid_lib/screens/CountryRankScreen.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toBeginningOfSentenceCase(countryName)),
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
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                    return Text(
                                      formatter
                                          .format(snapshot.data[0].todayCases)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
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
                                            fontSize: 25,
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
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }
                                  return Text(
                                    formatter
                                        .format(snapshot.data[0].todayDeaths)
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
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
                                        fontSize: 25,
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
                  yesterdayCountryData = fetchWorld();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/world-map.jpg'),
              ),
              title: Text(
                'Country Rankings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CountryRankScreen()),
                ).then((value) => setState(() => {}));
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SymptomsScreen()),
                ).then((value) => setState(() => {}));
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreventionScreen()),
                ).then((value) => setState(() => {}));
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TreatmentsScreen()),
                ).then((value) => setState(() => {}));
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
                  'Ver. 1.0',
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
