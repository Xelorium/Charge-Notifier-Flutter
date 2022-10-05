import 'package:battery_plus/battery_plus.dart';
import 'package:charge_notifier/helper_notification.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:vibration/vibration.dart';
import 'package:workmanager/workmanager.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> list = <String>[
    '15 minutes',
    '30 minutes',
    '1 hour',
    '2 hours',
    '3 hours'
  ];

  List<String> vibrationList = <String>[
    '500',
    '1000',
    '1500',
    '2000',
    '3000',
    '4000',
  ];

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

  static double _batValue = 100;
  static late int vibValue;

  late String dropdownValue = list.first;
  late String vibrationValue = vibrationList.first;

  bool isOn = GetStorage().read("isOn") ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isOn ? Colors.green.shade50 : Colors.red.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isOn == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Charge % Threshold",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.sp),
                      ),
                      SfSlider(
                        activeColor: Colors.green.shade300,
                        min: 0,
                        max: 100,
                        value: _batValue,
                        stepSize: 5,
                        interval: 10,
                        showTicks: true,
                        showLabels: true,
                        enableTooltip: true,
                        minorTicksPerInterval: 1,
                        onChanged: (dynamic value) {
                          setState(() {
                            _batValue = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Notifying Interval",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.sp),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.green.shade300,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Notifying Interval",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.sp),
                      ),
                      DropdownButton<String>(
                        value: vibrationValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.green.shade300,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            vibrationValue = value!;
                          });
                        },
                        items:
                        vibrationList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  )
                : SizedBox(),
            Text(
              "Notifier is",
              style: TextStyle(color: Colors.black, fontSize: 18.sp),
            ),
            Switch(
                activeTrackColor: Colors.green,
                activeColor: Colors.white,
                inactiveTrackColor: Colors.red,
                value: isOn,
                onChanged: (value) {
                  setState(() {
                    isOn = value;
                    box.write("isOn", isOn);
                  });
                  int intervalTime = 15;
                  if (isOn) {
                    switch (dropdownValue) {
                      case "15 minutes":
                        intervalTime = 15;
                        break;
                      case "30 minutes":
                        intervalTime = 30;
                        break;
                      case "1 hour":
                        intervalTime = 1;
                        break;
                      case "2 hours":
                        intervalTime = 2;
                        break;
                      case "3 hours":
                        intervalTime = 3;
                        break;
                    }

                    switch (vibrationValue) {
                      case "500":
                        vibValue = 500;
                        break;
                      case "1000":
                        vibValue = 1000;
                        break;
                      case "2000":
                        vibValue = 2000;
                        break;
                      case "3000":
                        vibValue = 3000;
                        break;
                      case "4000":
                        vibValue = 4000;
                        break;
                    }

                    print(intervalTime);
                    print(vibValue);
                    Workmanager().registerPeriodicTask(
                        tag: "chk",
                        "checkBatteryTsk",
                        "checkBattery",
                        frequency: Duration(
                            minutes: intervalTime >= 30
                                ? intervalTime
                                : intervalTime * 60),
                        initialDelay: const Duration(seconds: 20));
                  } else {
                    print("iptal");
                    Workmanager().cancelAll();
                  }
                }),
            isOn
                ? Text(
                    "ON",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp),
                  )
                : Text(
                    "OFF",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp),
                  )
          ],
        ),
      ),
    );
  }
}

void callbackDispatcher() {
  print(_MainPageState.vibValue);

  Workmanager().executeTask((taskName, inputData) async {
    try {
      var battery = await Battery().batteryLevel;
      print(battery);

      if (battery <= _MainPageState._batValue) {
        print(_MainPageState.vibValue);
        // NotificationHelper.showNotification(
        //     title: "Charge Notifier",
        //     body: "Charge is full!",
        //     payload: "deneme");


        Vibration.vibrate(duration: _MainPageState.vibValue);

        // Vibration.vibrate(
        //   pattern: [500, 4000, 500, 4000, 500, 4000, 500, 4000],
        //   intensities: [0, 128, 0, 255, 0, 64, 0, 255],
        // );

        print("müzik çalması lazım");
      } else {
        print("çalmaz");
      }
    } catch (e) {
      print(e);
    }

    return Future.value(true);
  });
}
