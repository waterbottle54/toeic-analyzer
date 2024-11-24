import 'package:flutter/material.dart';
import 'dart:math';


List<Point<double>> interpolateAccumulations(List<Point<double>> accums, int offset) {

  List<Offset> accumsOffset = accums.map((p) => Offset(p.x, p.y)).toList();
  CatmullRomSpline accumSpline = CatmullRomSpline(accumsOffset);

  List<Point<double>> intpAccums = []; // interpolated accumulations
  for (double score = 0; score <= 990; score += offset) {
    double t = accumSpline.findInverse(score);
    Offset intpAccum = accumSpline.transform(t);
    intpAccums.add(Point<double>(intpAccum.dx, intpAccum.dy));
  }

  return intpAccums;
}

List<Point<double>> sharesFromAccumulations(List<Point<double>> accums) {

  List<Point<double>> shares = [ accums.first ];
  for (int i = 1; i < accums.length; i++) {
    double dy = accums[i].y - accums[i - 1].y;
    shares.add(Point<double>(accums[i].x, dy));
  }

  return shares;
}

void correctAccumulations(List<Point<double>> accums, double correction) {
  for (int i = 0; i < accums.length; i++) {
    Point<double> p = accums[i];
    accums[i] = Point<double>(
        p.x, (p.y + 2 * correction) * (100 / (100 + 2 * correction)));
  }
}

