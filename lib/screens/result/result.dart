import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toeic_percent/models/toeic_result.dart';
import 'package:toeic_percent/models/user_result.dart';
import 'package:toeic_percent/services/preferences.dart';
import 'package:toeic_percent/shared/interpolation.dart';
import 'package:toeic_percent/shared/util.dart';
import 'date_form.dart';
import 'graph.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int _selectedResultIndex = 0;
  ToeicResult _selectedResult;
  double _selectedScore = 200;
  double _selectedPercent;

  @override
  Widget build(BuildContext context) {
    List<ToeicResult> resultList = Provider.of<List<ToeicResult>>(context);
    List<Point<double>> accumsDetail, accums, shares;
    double shareZero;

    if (resultList != null) {
      if (resultList.length > 0 && _selectedResultIndex < resultList.length) {
        _selectedResult = resultList[_selectedResultIndex];
        _selectedResult = resultList[_selectedResultIndex];

        accumsDetail = interpolateAccumulations(_selectedResult.accums, 1);
        double correction =
            50 - accumsDetail[_selectedResult.average.round()].y;

        accums = interpolateAccumulations(_selectedResult.accums, 5);
        correctAccumulations(accums, correction);
        shares = sharesFromAccumulations(accums);

        shareZero = shares[0].y;
        shares[0] = Point<double>(shares[0].x, 0);

        int index = (_selectedScore / 5).round();
        if (index > -1 && index < accums.length) {
          _selectedPercent = accums[index].y;
        }
      }
    }

    return Container(
      child: Column(
        children: [
          SizedBox(height: 4),
          Expanded(
            flex: 3,
            child: _headerSection(resultList, _selectedResult),
          ),
          _graphSection(accums, shares, _selectedResult, shareZero),
          Expanded(
            flex: 4,
            child: _footerSection(_selectedResult, _selectedPercent),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _headerSection(resultList, result) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: FlatButton(
            onPressed: () {
              setState(() {
                if (_selectedResultIndex < resultList.length - 1) {
                  _selectedResultIndex++;
                }
              });
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              color: _selectedResultIndex < resultList.length - 1
                  ? Colors.white54
                  : Colors.white12,
              size: 32,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showDateBottomSheet,
              child: Text(
                '${result.title} 회차 TOEIC',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            FlatButton.icon(
              onPressed: _showDateBottomSheet,
              icon: Icon(
                Icons.date_range,
                color: Colors.white,
                size: 26,
              ),
              label: Text(
                dateToKorean(result.date),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: FlatButton(
            onPressed: () {
              setState(() {
                if (_selectedResultIndex > 0) {
                  _selectedResultIndex--;
                }
              });
            },
            child: Icon(
              Icons.keyboard_arrow_right,
              color: _selectedResultIndex > 0 ? Colors.white54 : Colors.white12,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget _graphSection(accums, shares, result, shareZero) {
    return Provider<double>.value(
      value: _selectedScore,
      child: Graph(
        accumulations: accums,
        shares: shares,
        average: result.average,
        shareZero: shareZero,
        onTouch: (x, y) {
          setState(() => _selectedScore = x);
        },
      ),
    );
  }

  Widget _footerSection(result, percent) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Text(
                  '점　수',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Text(
                  '백분위',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedScore.round() > 0) {
                              _selectedScore -= 5;
                            }
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white70,
                          size: 20,
                        ),
                        color: Colors.blueGrey[800],
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${_selectedScore.round()}',
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedScore.round() < 990) {
                              _selectedScore += 5;
                            }
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white70,
                          size: 20,
                        ),
                        color: Colors.blueGrey[800],
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: Text(
                  (percent >= 50 ? '상위' : '하위') +
                      ' ${roundAt(percent >= 50 ? 100 - percent : percent, 1)}%',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(child: SizedBox()),
                FloatingActionButton(
                  child: Icon(Icons.add_chart),
                  onPressed: () => _saveUserResult(),
                ),
              ]
            )
          ),
        ],
      ),
    );
  }

  Future<void> _saveUserResult() async {
    if (_selectedScore == null ||
        _selectedPercent == null ||
        _selectedResult == null) {
      return;
    }

    bool updated = await PreferencesService.saveUserResult(UserResult(
      score: _selectedScore,
      percent: _selectedPercent,
      date: _selectedResult.date,
      referenceId: _selectedResult.id,
    ));

    Fluttertoast.showToast(
        msg: '기록이 ${updated ? '수정' : '추가'}되었습니다.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white70,
        fontSize: 16.0);
  }

  void _showDateBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: DateForm(
              onItemClick: (index) {
                setState(() => _selectedResultIndex = index);
              },
            ),
          ),
        );
      },
    );
  }
}
