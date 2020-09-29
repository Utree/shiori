import 'package:flutter/material.dart';

class AddTravel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Material Design',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material Design Layout'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
