import 'package:flutter/material.dart';

import '../constants/globals.dart';
import 'package:covid_lib/utils/saveLocal.dart';
import 'package:covid_lib/services/fetchCountry.dart';
import 'package:covid_lib/screens/MyHomePage.dart';
import 'package:covid_lib/constants/listCountries.dart';
import 'package:covid_lib/constants/listFlags.dart';
import 'package:covid_lib/constants/listMaps.dart';

class UnselectedCountriesList extends StatefulWidget {
  @override
  _UnselectedCountriesListState createState() =>
      _UnselectedCountriesListState();
}

class _UnselectedCountriesListState extends State<UnselectedCountriesList> {
  final _controller = TextEditingController();
  bool _isSearching;
  String _searchText = "";
  List searchResult = [];

  _UnselectedCountriesListState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < listCountries.length; i++) {
        String data = listCountries[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult.add(data);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff424242),
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                      height: 70,
                    ),
                    SizedBox(
                      width: 370,
                      height: 70,
                      child: TextFormField(
                        controller: _controller,
                        cursorColor: Colors.white,
                        onChanged: searchOperation,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Enter a Country...",
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a Country';
                          }
                          return null;
                        },
                      ),
                    ),
                  ]),
              SizedBox(
                height: 409,
                child: searchResult.length != 0 || _controller.text.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: searchResult.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            color: Color(0xff424242),
                            height: 50,
                            child: TextButton.icon(
                                label: Row(children: [
                                  Text('${searchResult[index]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                ]),
                                icon: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '${listFlags[listCountries.indexOf(searchResult[index])]}'),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xff6d6d6d),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedCountries.add(
                                        '${listCountries[listCountries.indexOf(searchResult[index])]}');
                                    selectedFlags.add(
                                        '${listFlags[listCountries.indexOf(searchResult[index])]}');
                                    selectedMaps.add(
                                        '${listMaps[listCountries.indexOf(searchResult[index])]}');
                                    countryName =
                                        '${listCountries[listCountries.indexOf(searchResult[index])]}';
                                    flagUrl =
                                        '${listFlags[listCountries.indexOf(searchResult[index])]}';
                                    mapUrl =
                                        '${listMaps[listCountries.indexOf(searchResult[index])]}';
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
                        })
                    : ListView.builder(
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
            ]));
  }
}
