import 'package:flutter/material.dart';

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
