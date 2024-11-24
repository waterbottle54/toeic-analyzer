import 'dart:math';

class ToeicResult {
  String id;
  List<Point<double>> _shares;
  List<Point<double>> _accums;
  DateTime date;
  String title;
  double average;

  ToeicResult(String id, List<Point<double>> shares, DateTime date, String title, double average) {
    this.id = id;
    _shares = shares;
    _initAccums();
    this.date = date;
    this.title = title;
    this.average = average;
  }

  List<Point<double>> get shares => _shares;

  List<Point<double>> get accums => _accums;

  void _initAccums() {
    _accums = [Point<double>(0, 0)];
    for (Point<double> share in _shares) {
      _accums.add(Point<double>(share.x, _accums.last.y + share.y));
    }
  }
}
