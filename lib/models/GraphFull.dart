import 'package:flutter/material.dart';
import 'package:covid_lib/models/GraphTimeline.dart';

class GraphFull {
  GraphTimeline timeline;
  GraphFull({
    @required this.timeline,
  });
  factory GraphFull.fromJson(Map<String, dynamic> json) {
    return GraphFull(
      timeline: GraphTimeline.fromJson(json['timeline']),
    );
  }
}
