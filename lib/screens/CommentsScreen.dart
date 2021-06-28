import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../constants/globals.dart';
import 'package:covid_lib/screens/NewComment.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  CollectionReference commentsDB =
      FirebaseFirestore.instance.collection('comments');

  @override
  void initState() {
    super.initState();
    /*commentsDB
        .add({
          'name': "Deneme Kişisi",
          'country': "Turkey",
          'city': "İstanbul",
          'comment': "Deneme yorumu.",
          'date': DateTime.now(),
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(countryName + " Comments"),
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
                  padding: const EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: FlatButton(
                      color: Color(0xff333333),
                      textColor: Colors.white,
                      disabledColor: Color(0xff555555),
                      disabledTextColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewComment()),
                        ).then((value) => setState(() => {}));
                      },
                      height: 80,
                      minWidth: double.maxFinite,
                      child: Text(
                        "+ New Comment...",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('comments')
                          .where("country", isEqualTo: countryName)
                          .orderBy('date', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(8.0),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (_, int index) {
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
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundImage: AssetImage(
                                                  'images/placeholder-icon.png'),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Column(children: <Widget>[
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    snapshot.data.docs[index]
                                                        ['name'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'City: ' +
                                                        snapshot.data
                                                                .docs[index]
                                                            ['city'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 3),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Date: ' +
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(DateTime
                                                                .parse(snapshot
                                                                    .data
                                                                    .docs[index]
                                                                        ['date']
                                                                    .toDate()
                                                                    .toString())),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ]),
                                          subtitle: Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              snapshot.data.docs[index]
                                                  ['comment'],
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
                                );
                              });
                        }
                        return CircularProgressIndicator();
                      }),
                )
              ]),
        ));
  }
}
