import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:toeic_percent/models/toeic_result.dart';

class DatabaseService {

  final CollectionReference resultsReference = FirebaseFirestore.instance
      .collection('results');

  ToeicResult _resultFromSnapshot(DocumentSnapshot snapshot) {

    Timestamp date = snapshot.data()['date'];
    String title = snapshot.data()['title'];
    String sharesInStr = snapshot.data()['shares'];
    double average = snapshot.data()['average'];

    List<double> shareValues = sharesInStr.split(' ').map(double.parse).toList();
    List<Point<double>> shares = [];
    for (int i = 0; i < shareValues.length; i++) {
      double score = (i == shareValues.length - 1) ? 990 : 50.0 * (i + 1);
      shares.add(Point<double>(score, shareValues[i]));
    }

    return ToeicResult(snapshot.id, shares, date.toDate(), title, average);
  }

  List<ToeicResult> _resultListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(_resultFromSnapshot).toList();
  }

  Stream<List<ToeicResult>> getToeicResultList() {
    return resultsReference.orderBy('date', descending: true)
        .snapshots().map(_resultListFromSnapshot);
  }

}