import 'package:flutter/material.dart';

import 'package:covid_lib/widgets/SelectedCountriesList.dart';
import 'package:covid_lib/widgets/UnselectedCountriesList.dart';

class CountrySelect extends StatefulWidget {
  CountrySelect({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CountrySelectState createState() => _CountrySelectState();
}

class _CountrySelectState extends State<CountrySelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                SelectedCountriesList(),
                Divider(
                  color: Color(0xff8e8e8e),
                  thickness: 2,
                  indent: 10,
                  endIndent: 10,
                ),
                UnselectedCountriesList(),
              ],
            )));
  }
}
