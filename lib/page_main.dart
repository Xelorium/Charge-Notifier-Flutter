import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Alarm is",
              style: TextStyle(color: Colors.black),
            ),
            Switch(
                value: isOn,
                onChanged: (value) {
                  setState(() {
                    isOn = value;
                  });
                  if (isOn) {
                    Workmanager().registerPeriodicTask(
                      tag: "chk",
                        "checkBatteryTsk", "checkBattery",
                        frequency: const Duration(minutes: 15), initialDelay: Duration(seconds: 20) );


                  } else {
                    print("iptal");
                    Workmanager().cancelAll();

                  }
                }),
            isOn
                ? Text(
                    "ON",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )
                : Text(
                    "OFF",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
          ],
        ),
      ),
    );
  }
}


