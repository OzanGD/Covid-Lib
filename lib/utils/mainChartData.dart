import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:covid_lib/utils/spotConverter.dart';

LineChartData mainChartData(List<String> dates, List<int> spots) {
  List<Color> gradientColors = [
    const Color(0xffff4040),
    const Color(0xffff6060),
  ];
  List<int> numberTitles = new List<int>.from(spots);
  numberTitles.sort();
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        getTitles: (value) {
          if (value == 0)
            return dates[0];
          else if (value.toInt() == (dates.length ~/ 2).round())
            return dates[(dates.length ~/ 2).round()];
          else if (value.toInt() == (dates.length) - 1)
            return dates[(dates.length) - 1];
          else
            return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: defaultGetTitle,
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: dates.length.toDouble() - 1,
    minY: 0,
    maxY: numberTitles[numberTitles.length - 1].toDouble(),
    lineBarsData: [
      LineChartBarData(
        spots: spotConverter(spots),
        //    [FlSpot(0, 3), FlSpot(2.6, 2), FlSpot(4.9, 5), FlSpot(6.8, 3.1), FlSpot(8, 4), FlSpot(9.5, 3), FlSpot(11, 4),],
        isCurved: false, //true,
        colors: gradientColors,
        barWidth: 2,
        isStrokeCapRound: false, //true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}
