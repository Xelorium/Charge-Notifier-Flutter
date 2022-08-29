import 'package:battery_plus/battery_plus.dart';
import 'package:charge_notifier/page_main.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charge Notifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}


void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {

    try{

      var battery = await Battery().batteryLevel;
      print(battery);

      if(battery >= 30){

        Vibration.vibrate(duration: 1000, amplitude: 128);

        print("müzik çalması lazım");

      }
      else{
        print("çalmaz");
      }

    }catch(e){
      print(e);
    }

    return Future.value(true);
  });
}
