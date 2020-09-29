import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const String AppName = "shiori";
  static const String ApiIP = "http://192.168.1.110";
  static const Color orange = Color.fromARGB(255, 225, 119, 0);
  static const Color beige = Color.fromARGB(255, 255, 242, 204);
  static const Color white = Colors.white;
  static const Color blue = Color.fromARGB(255, 48, 175, 255);
  static const Color hint = Color(0xFFE1E1E1);
}
enum Answers{
  YES,
  NO
}