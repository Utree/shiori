import 'package:flutter/material.dart';
import 'package:shiori_client/ui/screen/AddContent.dart';
import 'package:shiori_client/ui/screen/AddSpot.dart';
import 'package:shiori_client/ui/screen/AddTravel.dart';
import 'package:shiori_client/ui/screen/Booklet.dart';
import 'package:shiori_client/ui/screen/Splash.dart';
import 'package:shiori_client/ui/screen/Login.dart';
import 'package:shiori_client/ui/screen/Signup.dart';
import 'package:shiori_client/ui/screen/Home.dart';
import 'package:shiori_client/ui/screen/Album.dart';


void main() {
  runApp(new MaterialApp(
    title: 'Navigation with Routes',
    routes: <String, WidgetBuilder>{
      '/': (_) => new Splash(), // route"/"が最初のページ
      '/login': (_) => new Login(),
      '/sighup': (_) => new Signup(),
      '/home': (_) => new Home(),
      '/album': (_) => new Album(),
      '/booklet': (_) => new Booklet(),
      '/addSpot': (_) => new AddSpot(),
      '/addTravel': (_) => new AddTravel(),
      '/addContent': (_) => new AddContent()
    },
  ));
}