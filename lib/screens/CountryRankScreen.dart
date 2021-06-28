import 'package:flutter/material.dart';

import '../constants/globals.dart';
import 'package:covid_lib/services/fetchCountries.dart';
import 'package:covid_lib/models/ManyCountryData.dart';
import 'package:covid_lib/constants/listCountries.dart';
import 'package:covid_lib/constants/listFlags.dart';

class CountryRankScreen extends StatefulWidget {
  @override
  _CountryRankScreenState createState() => _CountryRankScreenState();
}

class _CountryRankScreenState extends State<CountryRankScreen> {
  var page = 0;
  var pageTwo = 0;

  @override
  void initState() {
    super.initState();
    allCases = fetchManycountry("todayCases");
    allDead = fetchManycountry("todayCases");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Country Stats"),
        backgroundColor: Color(0xff1b1b1b),
      ),
      body: Container(
          color: Color(0xff424242),
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    'Cases',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: FlatButton(
                          color: (page == 0)
                              ? Color(0xff555555)
                              : Color(0xff6d6d6d),
                          textColor: Colors.white,
                          disabledColor: Color(0xff555555),
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.all(4),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            setState(() {
                              page = 0;
                              allCases = fetchManycountry("todayCases");
                            });
                          },
                          child: Text(
                            "Today",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: FlatButton(
                          color: (page == 1)
                              ? Color(0xff555555)
                              : Color(0xff6d6d6d),
                          textColor: Colors.white,
                          disabledColor: Color(0xff555555),
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.all(4),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            setState(() {
                              page = 1;
                              allCases = fetchManycountry("cases");
                            });
                          },
                          child: Text(
                            "All Time",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ]),
                Expanded(
                  child: FutureBuilder<ManyCountryData>(
                      future: allCases,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: snapshot.data.dataList.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: double.infinity,
                                  color: Color(0xff424242),
                                  height: 30,
                                  child: TextButton.icon(
                                      icon: CircleAvatar(
                                        radius: 10,
                                        backgroundImage: NetworkImage(
                                            '${listFlags[listCountries.indexOf(snapshot.data.dataList[index].country)]}'),
                                      ),
                                      label: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                snapshot.data.dataList[index]
                                                    .country,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                            page == 0
                                                ? Text(
                                                    formatter
                                                        .format(snapshot
                                                            .data
                                                            .dataList[index]
                                                            .todayCases)
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ))
                                                : Text(
                                                    formatter
                                                        .format(snapshot
                                                            .data
                                                            .dataList[index]
                                                            .cases)
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )),
                                          ]),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xff6d6d6d),
                                      ),
                                      onPressed: () {}),
                                );
                              });
                        }
                        return CircularProgressIndicator();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    'Deaths',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: FlatButton(
                          color: (pageTwo == 0)
                              ? Color(0xff555555)
                              : Color(0xff6d6d6d),
                          textColor: Colors.white,
                          disabledColor: Color(0xff555555),
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.all(4),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            setState(() {
                              pageTwo = 0;
                              allDead = fetchManycountry("todayDeaths");
                            });
                          },
                          child: Text(
                            "Today",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: FlatButton(
                          color: (pageTwo == 1)
                              ? Color(0xff555555)
                              : Color(0xff6d6d6d),
                          textColor: Colors.white,
                          disabledColor: Color(0xff555555),
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.all(4),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            setState(() {
                              pageTwo = 1;
                              allDead = fetchManycountry("deaths");
                            });
                          },
                          child: Text(
                            "All Time",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ]),
                Expanded(
                  child: FutureBuilder<ManyCountryData>(
                      future: allDead,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: snapshot.data.dataList.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: double.infinity,
                                  color: Color(0xff424242),
                                  height: 30,
                                  child: TextButton.icon(
                                      icon: CircleAvatar(
                                        radius: 10,
                                        backgroundImage: NetworkImage(
                                            '${listFlags[listCountries.indexOf(snapshot.data.dataList[index].country)]}'),
                                      ),
                                      label: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                snapshot.data.dataList[index]
                                                    .country,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                            pageTwo == 0
                                                ? Text(
                                                    formatter
                                                        .format(snapshot
                                                            .data
                                                            .dataList[index]
                                                            .todayDeaths)
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ))
                                                : Text(
                                                    formatter
                                                        .format(snapshot
                                                            .data
                                                            .dataList[index]
                                                            .deaths)
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )),
                                          ]),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xff6d6d6d),
                                      ),
                                      onPressed: () {}),
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
