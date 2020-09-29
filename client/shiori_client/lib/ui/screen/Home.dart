import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  _Home createState() => _Home();
}

class TravelItem {
  int id;
  String name;
  String period;
  String thumbnailUrl;

  TravelItem(this.id, this.name, this.period, this.thumbnailUrl);

  TravelItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    period = json['period'];
    thumbnailUrl = json['thumbnail_url'];
  }
}

Future<List<TravelItem>> initHome() async {
  final prefs = await SharedPreferences.getInstance();
  final ac_tkn = prefs.getString('access_token') ?? "not found";
  print("access_token: " + ac_tkn);
  final List<TravelItem> response = await http.get(
    AppTheme.ApiIP + '/travels',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + ac_tkn,
    }
  ).then((value) {
    String responseBody = utf8.decode(value.bodyBytes);  // UTF-8に変換
    var tagObjsJson = json.decode(responseBody)['data'] as List;
//    return tagObjsJson.map((tagJson) => TravelItem.fromJson(tagJson)).toList();
    return [
      TravelItem(1, "箱根旅行", "2020/1/1", "https://www.dropbox.com/s/nb3e9fdxv80dx19/hakone.jpg?raw=1"),
      TravelItem(2, "沖縄旅行", "2020/1/2", "https://www.dropbox.com/s/r7qrgi3z4qqm973/okinawa.jpg?raw=1"),
      TravelItem(3, "北海道旅行", "2020/1/3", "https://www.dropbox.com/s/9ebliz8jakptqqi/hokkaido.jpg?raw=1"),
      TravelItem(4, "修学旅行", "2020/1/4", "https://www.dropbox.com/s/y0kyy2tp0wlqnem/school.jpg?raw=1"),
      TravelItem(5, "パリ", "2020/1/5", "https://www.dropbox.com/s/evfu6rhx136ej2u/paris.jpg?raw=1"),
    ];
  });
  return response;
}

class _Home extends State<Home> with TickerProviderStateMixin {
  AnimationController controller;
  Future<List<TravelItem>> _travelItem;

  @override
  Future<void> initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _travelItem = initHome();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<TravelItem>>(
        future: _travelItem,
          builder: (context, snapshot) {
          // network check
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.data.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext _, int index) {
                    // アニメーションの設定
                    final int count = snapshot.data.length > 10 ? 10 : snapshot.data.length;
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
                      travelData: snapshot.data[index]
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            } else {
              return CircularProgressIndicator();
            }
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
  final TravelItem travelData;

  const HomeListView({
    Key key,
    @required this.controller,
    @required this.animation,
    @required this.travelData,

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
            child: HomeItemWidget(travelData: travelData),
          ),
        );
      },
    );
  }
}

class HomeItemWidget extends StatelessWidget {
  final TravelItem travelData;

  HomeItemWidget({
    @required this.travelData,
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
                        child: Image.network(travelData.thumbnailUrl, fit: BoxFit.cover)
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
                                Text(travelData.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, locale: Locale('ja'))),
                                Text(travelData.period)
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
        print(travelData.name + "called");
        Navigator.of(context).pushNamed('/booklet', arguments: travelData.name); // ページ遷移
        },
    );
  }
}