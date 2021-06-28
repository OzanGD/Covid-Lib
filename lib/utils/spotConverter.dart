import 'package:fl_chart/fl_chart.dart';

List<FlSpot> spotConverter(List<int> values) {
  List<FlSpot> spots = [];
  for (var item in values) {
    spots.add(new FlSpot(values.indexOf(item).toDouble(), item.toDouble()));
  }
  return spots;
}
