import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toeic_percent/models/user_result.dart';
import 'package:toeic_percent/models/toeic_result.dart';
import 'package:toeic_percent/services/preferences.dart';
import 'package:toeic_percent/shared/util.dart';
import '../loading.dart';
import 'graph.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    List<ToeicResult> toeicResults = Provider.of<List<ToeicResult>>(context);

    return toeicResults == null
        ? Loading()
        : StreamBuilder<List<UserResult>>(
            stream: PreferencesService.getUserResult().asStream(),
            builder: (context, snapshot) {
              List<UserResult> userResults = snapshot.data;

              List<ToeicResult> testResults = userResults == null
                  ? null
                  : userResults.map((userResult) {
                      return toeicResults.singleWhere((toeicResult) =>
                          toeicResult.id == userResult.referenceId);
                    }).toList();

              return userResults == null
                  ? Loading()
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey[900],
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.blueGrey[900],
                                  Colors.grey[900],
                                ],
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20),
                            alignment: Alignment.center,
                            child: Text(
                              '나의 기록',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          userResults.isEmpty
                              ? SizedBox()
                              : Graph(
                                  userResults: userResults,
                                  testResults: testResults,
                                ),
                          SizedBox(height: 26),
                          Expanded(
                            child: ListView.builder(
                              itemCount: userResults.length,
                              itemBuilder: (context, index) {
                                UserResult userResult =
                                    userResults[userResults.length - 1 - index];
                                ToeicResult testResult =
                                    testResults[userResults.length - 1 - index];
                                DateTime date = userResult.date;
                                String dateStr =
                                    '${date.year}.${date.month}.${date.day}'
                                        .substring(2);

                                return Card(
                                  margin: EdgeInsets.fromLTRB(14, 0, 14, 14),
                                  color: Colors.blueGrey[800],
                                  child: ListTile(
                                    leading: Padding(
                                      padding: EdgeInsets.fromLTRB(4, 0, 20, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${testResult.title}회',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$dateStr',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await PreferencesService
                                                .deleteUserResult(
                                                    userResult.referenceId);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      '${roundAt(userResult.percent, 1)}%',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      '${userResult.score.round()}점',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
            });
  }
}
