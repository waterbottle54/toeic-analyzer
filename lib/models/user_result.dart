
class UserResult {

  double score;
  double percent;
  DateTime date;
  String referenceId;

  static UserResult fromMap(Map<String, dynamic> map) {
    return UserResult(
      score: map['score'],
      percent: map['percent'],
      date: DateTime.parse(map['date']),
      referenceId: map['referenceId']
    );
  }

  UserResult({ this.score, this.percent, this.date, this.referenceId });

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'percent': percent,
      'date': date.toString(),
      'referenceId': referenceId,
    };
  }

}