import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:profind/app_widget.dart';
import 'package:profind/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences preferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferences();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: "ProFind");

  runApp(AppWidget(preferences: preferences));
}

Future<void> setPreferences() async {
  preferences = await SharedPreferences.getInstance();
}
