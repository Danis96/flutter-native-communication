import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const MethodChannel methodChannel = MethodChannel('com.abc.flutter/method');


  static const EventChannel pressureChannel =
      EventChannel('com.abc.flutter/pressure');

  StreamSubscription? _pressureSubscription;

  String _pressureSensorAvailable = 'Unknown';
  String _systemVersion = 'Unknown';
  String _pressureValue = '0';
  String _calculationValue = '-';

  Future<void> checkSensorAvailability() async {
    try {
      var _pressureSensor =
          await methodChannel.invokeMethod('isPressureSensorAvailable');
      setState(() {
        _pressureSensorAvailable = _pressureSensor.toString();
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> checkSystemVersion() async {
    try {
      var _systemV =
          await methodChannel.invokeMethod('getSystemInfo');
      setState(() {
        _systemVersion = _systemV.toString();
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> checkCalculation() async {
    try {
      var _result =
          await methodChannel.invokeMethod('getCalculation');
      setState(() {
        _calculationValue = _result.toString();
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> startPressureReading() async {
    try {
      _pressureSubscription =
          pressureChannel.receiveBroadcastStream().listen((event) {
        setState(() {
          _pressureValue = event.toString();
        });
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                      'Pressure sensor available: $_pressureSensorAvailable'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    child: Text('Check for pressure sensor'),
                    onPressed: () => checkSensorAvailability(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text('Pressure reading: $_pressureValue'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    child: Text('Start pressure reading'),
                    onPressed: () => startPressureReading(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text('Phone system and version: $_systemVersion'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    child: Text('Check device system and version'),
                    onPressed: () => checkSystemVersion(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text('10 + 5 = $_calculationValue'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    child: Text('Calculate on native side'),
                    onPressed: () => checkCalculation(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
