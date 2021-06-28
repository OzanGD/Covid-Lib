import 'package:flutter/material.dart';
import 'package:covid_lib/models/CountryData.dart';

class ManyCountryData {
  List<CountryData> dataList;

  ManyCountryData({
    @required this.dataList,
  });

  factory ManyCountryData.fromJson(List<dynamic> parsedJson) {
    List<CountryData> dataSrcList = new List<CountryData>();
    dataSrcList = parsedJson.map((i) => CountryData.fromJson(i)).toList();

    return ManyCountryData(
      dataList: dataSrcList,
    );
  }
}
