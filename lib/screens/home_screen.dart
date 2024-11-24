import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toeic_percent/models/toeic_result.dart';
import 'package:toeic_percent/screens/result/result.dart';
import 'package:toeic_percent/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'history/history.dart';
import 'loading.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<ToeicResult> resultList = Provider.of<List<ToeicResult>>(context);

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildAppBar(),
          body: Center(
            child: AspectRatio(
              aspectRatio: 0.777,
              child: resultList == null
                  ? Loading()
                  : TabBarView(
                      children: [
                        Result(),
                        History(),
                      ],
                      physics: NeverScrollableScrollPhysics(),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Center(
        child: Text("       TOEIC 백분위 조회"),
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.only(left: 10, right: 25),
          onPressed: () => _showAboutDialog(),
          icon: Icon(
            Icons.info,
            color: Colors.lightBlueAccent,
          ),
        )
      ],
      elevation: 5,
      bottom: TabBar(
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart),
                SizedBox(width: 8),
                Text("통계"),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.show_chart),
                SizedBox(width: 8),
                Text("기록"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: '토익 백분위 조회',
      applicationVersion: 'Version 1.0.0',
      applicationIcon: Icon(
        Icons.tag_faces,
        size: 40,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlatButton.icon(
              onPressed: () => _copyEmail(),
              icon: Icon(Icons.email),
              label: Text('waterbottle54@naver.com'),
            ),
            FlatButton.icon(
              onPressed: () => _launchPlayStore(),
              icon: Icon(Icons.smartphone),
              label: Text('앱 버전 다운로드'),
            ),
          ],
        ),
      ],
    );
  }

  void _launchPlayStore() async {
    if (await canLaunch(URL_PLAY_STORE)) {
      await launch(URL_PLAY_STORE);
    } else {
      throw 'Could not launch $URL_PLAY_STORE';
    }
  }

  void _copyEmail() {
    Clipboard.setData(new ClipboardData(text: URL_EMAIL));
    Fluttertoast.showToast(msg: "클립보드에 복사되었습니다");
  }
}
