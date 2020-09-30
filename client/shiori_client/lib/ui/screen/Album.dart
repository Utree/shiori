import 'package:flutter/material.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';

class Album extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: AppTheme.beige,

        appBar: AppBar(
          title: Text("${args}のアルバム", style: TextStyle(locale: Locale('ja')),),
          elevation: 0.0,
          backgroundColor: AppTheme.orange,
        ),
        body: GridView.count(
          crossAxisCount: 3, // 1行に表示する数
          children: List.generate(100, (index) {
            return Container(
                alignment: Alignment.center,
                child: GridTile(
                  child: Container(
                    child: Image.network(
                      'https://picsum.photos/250?image=' + index.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ));
          }),
        ));
  }
}
