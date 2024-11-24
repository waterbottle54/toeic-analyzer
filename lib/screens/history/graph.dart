import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:toeic_percent/models/toeic_result.dart';
import 'package:toeic_percent/models/user_result.dart';
import 'package:toeic_percent/shared/util.dart';

class Graph extends StatefulWidget {
  final List<UserResult> userResults;
  final List<ToeicResult> testResults;

  final Color bkColor = Colors.grey[900];
  final Color gridColor = Colors.grey[800];
  final List<Color> gradientColors = [
    Color.fromARGB(255, 250, 229, 50),
    Color.fromARGB(255, 255, 255, 6),
  ];
  final TextStyle _titleStyle = TextStyle(
    color: Colors.grey[500],
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  final TextStyle _tooltipStyle = TextStyle(
    color: Colors.grey[700],
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  Graph({this.userResults, this.testResults});

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 28.0, left: 12.0, top: 0, bottom: 12),
      child: AspectRatio(
        aspectRatio: 2.0,
        child: LineChart(_historyData()),
      ),
    );
  }

  LineChartData _historyData() {
    if (widget.userResults.isEmpty) {
      return null;
    }

    List<FlSpot> historySpots = new List();
    for (int i = 0; i < widget.userResults.length; i++) {
      historySpots.add(FlSpot(i.toDouble(), widget.userResults[i].percent));
    }

    return LineChartData(
      minX: 0,
      maxX: historySpots.length.toDouble() - 1,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: historySpots,
          isCurved: false,
          colors: widget.gradientColors,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: widget.gradientColors
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ],
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          if (value.round() % 20 == 0) {
            return FlLine(
              color: widget.gridColor,
              strokeWidth: 1,
            );
          }
          return FlLine(
            color: widget.bkColor,
            strokeWidth: 0,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: widget._titleStyle,
          getTitles: (value) {
            int idx = value.round();
            String title = widget.testResults[idx].title;
            DateTime date = widget.testResults[idx].date;
            return '$title회\n${date.year - 2000}.${date.month}.${date.day}';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: widget._titleStyle,
          getTitles: (value) {
            if (value > 0 && value.round() % 20 == 0) {
              return value.toInt().toString() + '%';
            }
            return '';
          },
          reservedSize: 36,
          margin: 12,
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white.withOpacity(0.7),
          fitInsideHorizontally: true,
          getTooltipItems: (List<LineBarSpot> spots) {
            return spots.map((spot) {
              int idx = spot.x.round();
              int score = widget.userResults[idx].score.round().toInt();
              String text = '${roundAt(spot.y, 1)}%\n$score점';
              return LineTooltipItem(text, widget._tooltipStyle);
            }).toList();
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: widget.gridColor, width: 1),
      ),
    );
  }
}
