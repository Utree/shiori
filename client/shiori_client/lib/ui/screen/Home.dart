import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';
import 'dart:math';

class Home extends StatefulWidget {
  _Home createState() => _Home();
}

class _Home extends State<Home> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  Future<void> initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _loadCounter();
  }

  _loadCounter() async {
    // read data
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final act_tkn = prefs.getString('access_token') ?? "not found";
      print("access_token: " + act_tkn);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = [];
    var rng = new Random();
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    return Scaffold(
      backgroundColor: AppTheme.beige,
      appBar: AppBar(
        toolbarHeight: 90,
        title: Text(
          AppTheme.AppName,
          style: TextStyle(
              fontFamily: "Chewy",
              fontSize: 40,
              color: AppTheme.orange
          ),
        ),
        backgroundColor: AppTheme.beige,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext _, int index) {
          // アイテムが追いつかなくなったらリストを追加
          if (index >= list.length) {
            list.addAll(generateWordPairs().take(10));
          }
          // アニメーションの設定
          final int count = list.length > 10 ? 10 : list.length;
          final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: controller,
                  curve: Interval((1 / count*1.5) * index, 1.0,
                      curve: Curves.fastOutSlowIn)
              )
          );
          controller.forward();
          // レイアウトを設定
          return HomeListView(
            controller: controller,
            animation: animation,
            title: list[index],
            imageNumber: rng.nextInt(100),
            index: index,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppTheme.orange,
      ),
    );
  }
}

class HomeListView extends StatelessWidget {
  // Home画面中listのアニメーション
  final AnimationController controller;
  final Animation<double> animation;
  final int imageNumber, index;
  final WordPair title;

  const HomeListView({
    Key key,
    @required this.controller,
    @required this.animation,
    @required this.imageNumber,
    @required this.title,
    @required this.index

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: HomeItemWidget(title: title.asPascalCase, imageNumber: imageNumber),
          ),
        );
      },
    );
  }
}

class HomeItemWidget extends StatelessWidget {
  // Home画面中list itemの画像と文字のレイアウト
  String title;
  int imageNumber;

  HomeItemWidget({
    @required this.title,
    @required this.imageNumber
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Container(
          decoration: BoxDecoration( // 影の修飾
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),  // itemの丸み
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                        aspectRatio: 2, // 画像のアスペクト比
                        child: Image.network(
                          'https://picsum.photos/250?image=' + this.imageNumber.toString(),
                          fit: BoxFit.cover,
                        )
                    ),
                    Container(  // テキストエリア
                      color: Colors.white, // 背景色
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                Text("2020/01/01")
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: (){
        print(title + "called");
        Navigator.of(context).pushNamed('/booklet', arguments: title+" called"); // ページ遷移
        },
    );
  }
}