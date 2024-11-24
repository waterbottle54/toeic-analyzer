import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:toeic_percent/models/toeic_result.dart';
import 'package:toeic_percent/screens/home_screen.dart';
import 'package:toeic_percent/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ToeicResult>>.value(
      value: DatabaseService().getToeicResultList(),
      child: MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return HomeScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey[900],
          accentColor: Colors.blueGrey[700],
          scaffoldBackgroundColor: Colors.blueGrey[900],
          canvasColor: Colors.blueGrey[900],
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white70),
            bodyText2: TextStyle(color: Colors.white70),
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.white70,
            ),
            textTheme: TextTheme(
              headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.blueGrey[900],
          ),
        ),
      ),
    );
  }
}
