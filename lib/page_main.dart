import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:workmanager/workmanager.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  initState() {
    OptimizeBattery.isIgnoringBatteryOptimizations().then((onValue) {
      setState(() {
        if (onValue) {
          // Igonring Battery Optimization
        } else {
          OptimizeBattery.stopOptimizingBatteryUsage();
          OptimizeBattery.openBatteryOptimizationSettings();
        }
      });
    });

    super.initState();
  }

  final box = GetStorage();

  bool isOn = GetStorage().read("isOn") ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Alarm is",
              style: TextStyle(color: Colors.black),
            ),
            Switch(
                value: isOn,
                onChanged: (value) {
                  setState(() {
                    isOn = value;
                    box.write("isOn", isOn);
                  });
                  if (isOn) {
                    Workmanager().registerPeriodicTask(
                        tag: "chk",
                        "checkBatteryTsk",
                        "checkBattery",
                        frequency: const Duration(minutes: 15),
                        initialDelay: const Duration(seconds: 20));
                  } else {
                    print("iptal");
                    Workmanager().cancelAll();
                  }
                }),
            isOn
                ? const Text(
                    "ON",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )
                : const Text(
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
