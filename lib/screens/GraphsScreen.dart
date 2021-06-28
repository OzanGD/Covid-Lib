import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../constants/globals.dart';
import 'package:covid_lib/services/fetchGraph.dart';
import 'package:covid_lib/models/GraphFull.dart';
import 'package:covid_lib/utils/mainChartData.dart';

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
    varGraphData3 = fetchGraph(countryName, 'all');
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
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: FutureBuilder<GraphFull>(
                          future: varGraphData3,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var varMax = snapshot
                                  .data.timeline.graphCases.cases
                                  .reduce(max);
                              var varIndex = snapshot
                                  .data.timeline.graphCases.cases
                                  .indexOf(varMax);
                              var varDate = snapshot
                                  .data.timeline.graphCases.dates[varIndex];
                              return Text(
                                "Highest recorded cases: " +
                                    varMax.toString() +
                                    " at " +
                                    varDate,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              );
                            }
                            return CircularProgressIndicator();
                          }),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: FutureBuilder<GraphFull>(
                          future: varGraphData3,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var varMax = snapshot
                                  .data.timeline.graphDeaths.cases
                                  .reduce(max);
                              var varIndex = snapshot
                                  .data.timeline.graphDeaths.cases
                                  .indexOf(varMax);
                              var varDate = snapshot
                                  .data.timeline.graphDeaths.dates[varIndex];
                              return Text(
                                "Highest recorded deaths: " +
                                    varMax.toString() +
                                    " at " +
                                    varDate,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              );
                            }
                            return CircularProgressIndicator();
                          }),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ])),
        ]));
  }
}
