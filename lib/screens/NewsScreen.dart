import 'package:flutter/material.dart';

import '../constants/globals.dart';
import 'package:covid_lib/services/fetchNews.dart';
import 'package:covid_lib/services/fetchVaccineNews.dart';
import 'package:covid_lib/models/Articles.dart';
import 'package:covid_lib/utils/launchURL.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  var page = 0;

  @override
  void initState() {
    super.initState();
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 5),
                        child: FlatButton(
                          color: (page == 0)
                              ? Color(0xff555555)
                              : Color(0xff6d6d6d),
                          textColor: Colors.white,
                          disabledColor: Color(0xff555555),
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            setState(() {
                              page = 0;
                              newsData = fetchNews(countryName);
                            });
                          },
                          child: Text(
                            "Covid-19 News",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 5),
                        child: FlatButton(
                          color: (page == 1)
                              ? Color(0xff555555)
                              : Color(0xff6d6d6d),
                          textColor: Colors.white,
                          disabledColor: Color(0xff555555),
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            setState(() {
                              page = 1;
                              newsData = fetchVaccineNews(countryName);
                            });
                          },
                          child: Text(
                            "Vaccine News",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ]),
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
