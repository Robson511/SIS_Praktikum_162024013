/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program Warung IS
*/

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';

import 'screens/splash_screen.dart';

void main() {
  DevicePreview.enable();
  runApp(const MyApp());

  DevicePreview.maybeController?.applyPreset(DevicePresets.iPhone16);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warung IS',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
