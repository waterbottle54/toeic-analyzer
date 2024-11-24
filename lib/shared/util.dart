
import 'dart:math';

String dateToKorean(DateTime date) {
  return '${date.year}년 ${date.month}월 ${date.day}일';
}

String weekdayToKorean(int weekday) {
  List<String> kor = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
  return kor[weekday-1];
}

double roundAt(double val, int depth) {
  double factor = pow(10.0, depth.toDouble());
  return ((val * factor).round()/factor);
}
