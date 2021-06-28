import 'package:flutter/material.dart';
import 'package:covid_lib/models/GraphCases.dart';

class GraphTimeline {
  GraphCases graphCases;
  GraphCases graphDeaths;

  GraphTimeline({
    @required this.graphCases,
    @required this.graphDeaths,
  });
  factory GraphTimeline.fromJson(Map<String, dynamic> json) {
    return GraphTimeline(
      graphCases: GraphCases.fromJson(json['cases']),
      graphDeaths: GraphCases.fromJson(json['deaths']),
    );
  }
}
