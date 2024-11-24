import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:toeic_percent/shared/util.dart';

class Graph extends StatefulWidget {
  final List<Point<double>> accumulations;
  final List<Point<double>> shares;
  final double average;
  final double shareZero;
  final Function onTouch;

  final Color bkColor = Colors.grey[900];
  final Color gridColor = Colors.grey[800];
  final List<Color> gradientColors = [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];
  final TextStyle _tooltipStyle = TextStyle(
    color: Colors.grey[700],
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  final TextStyle _titleStyle = TextStyle(
    color: Colors.grey[500],
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Graph(
      {this.accumulations,
      this.shares,
      this.average,
      this.shareZero,
      this.onTouch});

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  bool _showShare = true;
  double _indicatedScore;

  void _toggleView() {
    setState(() {
      _showShare = !_showShare;
    });
  }

  VerticalLine _getScoreLine() {
    return VerticalLine(
      x: _indicatedScore,
      color: Colors.white54,
      strokeWidth: 1,
      label: VerticalLineLabel(
        show: true,
        alignment: Alignment.topCenter,
        labelResolver: (line) {
          int index = (_indicatedScore / 5).round();
          if (index > -1 && index < widget.shares.length) {
            return widget.shares[index].y < 0.7 ? '▼' : '';
          }
          return '';
        },
        style: TextStyle(
          color: Colors.lightGreenAccent,
          fontSize: 18,
        ),
      ),
    );
  }

  VerticalLine _getAverageLine() {
    return VerticalLine(
        x: widget.average,
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [5, 5],
        label: VerticalLineLabel(
          show: true,
          alignment: Alignment.centerRight,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
          labelResolver: (line) => '평균\n${roundAt(widget.average, 1)}',
        ));
  }

  FlLine _getDrawingVerticalLine(value) {
    if (value.round() % 100 == 0) {
      return FlLine(
        color: widget.gridColor,
        strokeWidth: 1,
      );
    }
    return FlLine(
      color: widget.bkColor,
      strokeWidth: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    double score = Provider.of<double>(context);
    if (score != null) {
      _indicatedScore = score;
    }

    return Container(
      decoration: BoxDecoration(color: widget.bkColor),
      padding: EdgeInsets.only(right: 20.0, left: 12.0, top: 0, bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 40),
              Text('그래프를 클릭하세요',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              Expanded(child: SizedBox()),
              FlatButton.icon(
                onPressed: () => _toggleView(),
                icon: Icon(
                  _showShare ? Icons.stacked_line_chart : Icons.show_chart,
                  color: Colors.white70,
                ),
                label: Text(
                  _showShare ? '누적' : '분포',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          AspectRatio(
            aspectRatio: 2.2,
            child: LineChart(_showShare ? _shareData() : _accumData()),
          ),
        ],
      ),
    );
  }

  LineChartData _accumData() {
    List<FlSpot> accumSpots =
        widget.accumulations.map((p) => FlSpot(p.x, p.y)).toList();

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white.withOpacity(0.7),
          fitInsideHorizontally: true,
          getTooltipItems: (List<LineBarSpot> spots) {
            return spots.map((spot) {
              String text = '${spot.x.round()} : ${roundAt(spot.y, 1)}%';
              return LineTooltipItem(text, widget._tooltipStyle);
            }).toList();
          },
        ),
        touchCallback: (LineTouchResponse response) {
          if (response.lineBarSpots.length == 1) {
            LineBarSpot spot = response.lineBarSpots[0];
            setState(() => _indicatedScore = spot.x);
            widget.onTouch(spot.x, spot.y);
          }
        },
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
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
        getDrawingVerticalLine: _getDrawingVerticalLine,
      ),
      extraLinesData: ExtraLinesData(
        verticalLines: [
          _getScoreLine(),
          _getAverageLine(),
        ],
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: widget.gridColor, width: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: widget._titleStyle,
          getTitles: (value) {
            int score = value.round();
            if (score % 100 == 0) {
              return score.toString();
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: widget._titleStyle,
          getTitles: (value) {
            if (value.round() % 20 == 0) {
              return value.round().toString() + '%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      minX: 0,
      maxX: 990,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: accumSpots,
          isCurved: true,
          colors: widget.gradientColors,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: widget.gradientColors
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ],
    );
  }

  // Shares Data

  LineChartData _shareData() {
    List<FlSpot> shareSpots =
        widget.shares.map((p) => FlSpot(p.x, p.y * 100)).toList();

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white.withOpacity(0.7),
          fitInsideHorizontally: true,
          getTooltipItems: (List<LineBarSpot> spots) {
            return spots.map((spot) {
              int score = spot.x.round();
              double accum = roundAt(widget.accumulations[spot.spotIndex].y, 1);
              String text = '$score점 : $accum%';
              return LineTooltipItem(text, widget._tooltipStyle);
            }).toList();
          },
        ),
        touchCallback: (LineTouchResponse response) {
          if (response.lineBarSpots.length == 1) {
            LineBarSpot spot = response.lineBarSpots[0];
            double accum = widget.accumulations[spot.spotIndex].y;
            setState(() => _indicatedScore = spot.x);
            widget.onTouch(spot.x, accum);
          }
        },
      ),
      extraLinesData: ExtraLinesData(
        verticalLines: [
          _getScoreLine(),
          _getAverageLine(),
        ],
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          if (value.round() % 50 == 0) {
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
        getDrawingVerticalLine: _getDrawingVerticalLine,
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: widget.gridColor, width: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: widget._titleStyle,
          getTitles: (value) {
            int score = value.round();
            if (score % 100 == 0) {
              return score.toString();
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: widget._titleStyle,
          getTitles: (value) {
            if (value.round() % 50 == 0) {
              return (value / 100).toString() + '%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      minX: 0,
      maxX: 990,
      minY: 0,
      maxY: 150,
      lineBarsData: [
        LineChartBarData(
          spots: shareSpots,
          isCurved: true,
          colors: widget.gradientColors,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: widget.gradientColors
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ],
    );
  }
}
