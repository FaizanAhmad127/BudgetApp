import 'package:budget_app/Screens/total_screen.dart';
import 'package:budget_app/Screens/transaction_screen.dart';
import 'package:budget_app/sheets/api/user_sheets_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);

  List<Worksheet?> workSheetList= await UserSheetApi.init();

  runApp( MyApp(workSheetList));
}

class MyApp extends StatelessWidget {
  final List<Worksheet?> workSheetList;
  MyApp(this.workSheetList, {Key? key}) : super(key: key) ;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  TotalScreen(workSheetList:workSheetList),
    );
  }
}
