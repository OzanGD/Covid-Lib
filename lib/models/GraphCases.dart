import 'package:flutter/material.dart';

class GraphCases {
  List<String> dates;
  List<int> cases;

  GraphCases({
    @required this.dates,
    @required this.cases,
  });

  factory GraphCases.fromJson(Map<String, dynamic> json) {
    List<String> dateList = [];
    List<int> caseList = [];
    for (var date in json.keys) {
      dateList.add(date);
      caseList.add(json[date]);
    }
    for (var i = 0; i < caseList.length - 1; i++) {
      caseList[i] = caseList[i + 1] - caseList[i];
    }
    caseList.removeAt(caseList.length - 1);
    dateList.removeAt(0);
    return GraphCases(
      dates: dateList,
      cases: caseList,
    );
  }
}
