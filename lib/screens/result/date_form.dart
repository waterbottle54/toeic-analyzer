import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toeic_percent/models/toeic_result.dart';
import 'package:toeic_percent/shared/util.dart';

import '../loading.dart';

class DateForm extends StatelessWidget {

  final Function onItemClick;

  DateForm({this.onItemClick});

  @override
  Widget build(BuildContext context) {
    final List<ToeicResult> resultList =
        Provider.of<List<ToeicResult>>(context);
    List<DateTime> dateList;

    if (resultList != null) {
      dateList = resultList.map((result) => result.date).toList();
    }

    return resultList == null
        ? Loading()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: dateList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  onItemClick(index);
                  Navigator.pop(context);
                },
                leading: CircleAvatar(
                  child: Text(
                    '${dateList[index].month}월',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: _colorOfMonth(dateList[index].month),
                ),
                title: Text(
                  dateToKorean(dateList[index]),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  weekdayToKorean(dateList[index].weekday),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              );
            },
          );
  }

  Color _colorOfMonth(int month) {
    switch (month) {
      case 11:
      case 12:
      case 1:
      case 2:
        return Colors.white70;
      case 3:
      case 4:
      case 5:
        return Colors.green[800];
      case 6:
      case 7:
      case 8:
        return Colors.blue[800];
      case 9:
      case 10:
        return Color.fromARGB(255, 166, 59, 26);
    }
    return Colors.white;
  }
}
