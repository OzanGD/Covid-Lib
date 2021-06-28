import 'package:flutter/material.dart';

import '../constants/globals.dart';
import 'package:covid_lib/utils/saveLocal.dart';

class SelectedCountriesList extends StatefulWidget {
  @override
  _SelectedCountriesListState createState() => _SelectedCountriesListState();
}

class _SelectedCountriesListState extends State<SelectedCountriesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                  backgroundImage: NetworkImage('${selectedFlags[index]}'),
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
        });
  }
}
