import 'package:flutter/material.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';
import 'package:shiori_client/ui/component/BookletMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Booklet extends StatefulWidget {
  @override
  _Booklet createState() => _Booklet();
}

class TravelSpot {
  String name;
  String thumbnailUrl;
  double lat, lng;

  TravelSpot(this.name, this.thumbnailUrl, this.lat, this.lng);

  TravelSpot.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    thumbnailUrl = json['thumbnail_url'];
    lat = json['lat'];
    lng = json['lng'];
  }
}

class RecommendedItem {
  String name;
  String thumbnailUrl;

  RecommendedItem(this.name, this.thumbnailUrl);

  RecommendedItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    thumbnailUrl = json['thumbnail_url'];
  }
}


class _Booklet extends State<Booklet> with TickerProviderStateMixin {
  Future<List<TravelSpot>> _travelSpot;
//  Future<List<RecommendedItem>> _recommendedItem;
  // フローティングボタン
  int _angle = 90;
  bool _isRotated = true;
  AnimationController _floatBtnCtrl;
  Animation<double> _animation;
  Animation<double> _animation2;

  Future<List<TravelSpot>> initBooklet() async {
    final prefs = await SharedPreferences.getInstance();
    final ac_tkn = prefs.getString('access_token') ?? "not found";
    print("access_token: " + ac_tkn);
    return [
      TravelSpot("abc空港", "https://www.dropbox.com/s/r06l6lmz23xpi97/airport.jpg?raw=1", 34.4320024,135.2281999),
      TravelSpot("def道の駅", "https://www.dropbox.com/s/pw8vjfaye3yu2a1/roadside.jpg?raw=1", 34.7024854,135.4937566),
      TravelSpot("ghiホテル", "https://www.dropbox.com/s/jb058wi4gesbz99/hotel.jpg?raw=1", 34.6475418,135.5011363),
    ];
  }

//  Future<List<RecommendedItem>> roadRecommendedItem() async {
//    return [
//      RecommendedItem("name", "https://www.dropbox.com/s/pa80zc8cz8g1f8g/rec0.jpg?raw=1"),
//      RecommendedItem("name", "https://www.dropbox.com/s/zmwb6gx7b56vr8k/rec1.jpg?raw=1"),
//      RecommendedItem("name", "https://www.dropbox.com/s/9if32q81q7gblgt/rec2.jpg?raw=1"),
//      RecommendedItem("name", "https://www.dropbox.com/s/bgq3hom20jyabls/rec5.jpg?raw=1"),
//      RecommendedItem("name", "https://www.dropbox.com/s/sxzi3j3506rc6on/rec3.jpg?raw=1"),
//      RecommendedItem("name", "https://www.dropbox.com/s/z80ar18b8gv05k1/rec4.jpg?raw=1"),
//      RecommendedItem("name", "https://www.dropbox.com/s/qpvzwjmhwa5tkpy/rec6.jpg?raw=1"),
//      RecommendedItem("name", "https://www.dropbox.com/s/cmxqmn01q2ei2cw/rec7.jpg?raw=1"),
//    ];
//  }

  // map表示用
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition posi = CameraPosition(
    target: LatLng(34.6887367, 135.4384213),
    zoom: 8,
  );

  @override
  Future<void> initState() {
    super.initState();
    _travelSpot = initBooklet();
//    _recommendedItem = roadRecommendedItem();

    // フローティングボタン
    _floatBtnCtrl = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _animation = new CurvedAnimation(
      parent: _floatBtnCtrl,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = new CurvedAnimation(
      parent: _floatBtnCtrl,
      curve: new Interval(0.5, 1.0, curve: Curves.linear),
    );
    _floatBtnCtrl.reverse();
  }

  void _rotate(){
    setState((){
      if(_isRotated) {
        _angle = 45;
        _isRotated = false;
        _floatBtnCtrl.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _floatBtnCtrl.reverse();
      }
    });
  }

  void openDialog(BuildContext context) {
    showDialog<Answers>(
      context: context,
      builder: (BuildContext context) =>
      new SimpleDialog(
        title: new Text('シェアしますか？'),
        children: <Widget>[
          createDialogOption(context, Answers.YES, 'Yes'),
          createDialogOption(context, Answers.NO, 'No')
        ],
      ),
    ).then((value) {
      print("Dialog value: " + value.toString());
    });
  }

  createDialogOption(BuildContext context, Answers answer, String str) {
    return new SimpleDialogOption(
      child: new Text(str), // 文字
      onPressed: (){Navigator.pop(context, answer); // ダイアログを閉じる
      },);
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    var _usStates = ["シェア", "ロック", "アルバム"];

    return Scaffold(
        backgroundColor: AppTheme.beige,
        appBar: AppBar(
          title: Text(args, style: TextStyle(locale: Locale('ja')),),
          elevation: 0.0,
          backgroundColor: AppTheme.orange,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (val) {
                setState(() {
                  print("called: " + val.toString());
                  openDialog(context);
                });
              },
              itemBuilder: (BuildContext context) {
                return _usStates.map((String s) {
                  return PopupMenuItem(child: Text(s), value: s);
                }).toList();
              },
            )
          ],
        ),
        // Body
        body: FutureBuilder<List<TravelSpot>>(
          future: _travelSpot,
          builder: (context, snapshot) {
            // network check
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.data.isNotEmpty) {
                return CustomScrollView(
                  slivers: <Widget>[
                    RecomendedSpots(),
                    SliverFixedExtentList(
                      itemExtent: 200.0,
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            if(index == 0) {
                              return Container(
                                alignment: Alignment.center,
                                color: Colors.lightBlue[100 * (index % 9)],
                                child: BookletMap(posi: posi, controller: _controller, travelSpot: snapshot.data,),
                              );
                            } else {
                              var paddingTop;
                              if(index == 1) {
                                paddingTop = 20.0;
                              } else {
                                paddingTop = 0.0;
                              }
                              var itm;
                              if(index != snapshot.data.length) {
                                itm = MiddleItem(thumbnailUrl: snapshot.data[index-1].thumbnailUrl);
                              } else {
                                itm = LastItem(thumbnailUrl: snapshot.data[index-1].thumbnailUrl);
                              }
                              return GestureDetector(
                                onTap: () {
                                  print("called: " + snapshot.data[index-1].name.toString());
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 20, top: paddingTop),
                                          child: Row(
                                            children: [
                                              Icon(Icons.brightness_1, size: 30, color: AppTheme.blue,),
                                              Padding(
                                                padding: EdgeInsets.only(left: 10, ),
                                                child: Text(snapshot.data[index-1].name, style: TextStyle(locale: Locale('ja')),),
                                              )
                                            ],),
                                        ),
                                        Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.only(left: 34),
                                                child: itm
                                            )
                                        )
                                      ],
                                    )
                                ),
                              );
                            }
                          },
                          childCount: snapshot.data.length+1
                      ),
                    ),
                  ],
                );
              } else {
                return Text("failed");
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: new Stack(
            children: <Widget>[
              new Positioned(
                  bottom: 144.0,
                  right: 24.0,
                  child: new Container(
                    child: new Row(
                      children: <Widget>[
                        new ScaleTransition(  // 文字
                          scale: _animation2,
                          alignment: FractionalOffset.center,
                          child: new Container(
                              margin: new EdgeInsets.only(right: 16.0),
                              child: Text(
                                  "画像を追加",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.white,
                                    locale: Locale('ja'),
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 5,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      )],))
                          ),
                        ),

                        new ScaleTransition(  // アイコン
                          scale: _animation2,
                          alignment: FractionalOffset.center,
                          child: new Material(
                              color: AppTheme.orange,
                              type: MaterialType.circle,
                              elevation: 6.0,
                              child: new GestureDetector(
                                child: new Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: new InkWell(
                                      onTap: (){
                                        _rotate();  // トグル
                                        print("画像を追加");
                                      },
                                      child: new Center(
                                        child: new Icon(
                                          Icons.add,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    )
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              new Positioned(
                  bottom: 88.0,
                  right: 24.0,
                  child: new Container(
                    child: new Row(
                      children: <Widget>[
                        new ScaleTransition(
                          scale: _animation,
                          alignment: FractionalOffset.center,
                          child: new Container(
                              margin: new EdgeInsets.only(right: 16.0),
                              child: Text(
                                  "スポットを追加",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.white,
                                    locale: Locale('ja'),
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 5,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      )],))
                          ),
                        ),
                        new ScaleTransition(
                          scale: _animation,
                          alignment: FractionalOffset.center,
                          child: new Material(
                              color: AppTheme.orange,
                              type: MaterialType.circle,
                              elevation: 6.0,
                              child: new GestureDetector(
                                child: new Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: new InkWell(
                                      onTap: (){
                                        _rotate();
                                        print("スポットを追加");
                                      },
                                      child: new Center(
                                        child: new Icon(
                                          Icons.add,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    )
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              new Positioned(
                bottom: 16.0,
                right: 16.0,
                child: new Material(
                    color: AppTheme.orange,
                    type: MaterialType.circle,
                    elevation: 6.0,
                    child: new GestureDetector(
                      child: new Container(
                          width: 56.0,
                          height: 56.00,
                          child: new InkWell(
                            onTap: _rotate,
                            child: new Center(
                                child: new RotationTransition(
                                  turns: new AlwaysStoppedAnimation(_angle / 360),
                                  child: new Icon(
                                    Icons.add,
                                    color: AppTheme.white,
                                  ),
                                )
                            ),
                          )
                      ),
                    )
                ),
              ),
            ]
        )
    );
  }
}

class MiddleItem extends StatelessWidget {
  final String thumbnailUrl;
  const MiddleItem({
    @required this.thumbnailUrl
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.grey, width: 2)
            ),
          )
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Image.network(thumbnailUrl, fit: BoxFit.cover,),
          )
        )
      ],
    );
  }
}
class LastItem extends StatelessWidget {
  final String thumbnailUrl;
  const LastItem({
    @required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: AppTheme.beige, width: 2)
              ),
            )
        ),
        Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Image.network(thumbnailUrl, fit: BoxFit.cover,),
            )
        )
      ],
    );
  }
}

class RecomendedSpots extends StatelessWidget {
  const RecomendedSpots({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
      floating: true,
      snap: true,
      expandedHeight: 100.0,
      automaticallyImplyLeading: false,  // 戻るボタンを消す
      backgroundColor: AppTheme.orange,  // 背景色
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(10.0),
        title: SingleChildScrollView(
          child: Container(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [Text("近くのおすすめスポット", style: TextStyle(color: AppTheme.white, fontSize: 8))],
                ),
                Container(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(width: 45, child: Padding(
                      padding: const EdgeInsets.all(.5), child: Image.network("https://www.dropbox.com/s/pa80zc8cz8g1f8g/rec0.jpg?raw=1", fit: BoxFit.cover))),
                      Container(width: 45, child: Padding(
                          padding: const EdgeInsets.all(.5), child: Image.network("https://www.dropbox.com/s/zmwb6gx7b56vr8k/rec1.jpg?raw=1", fit: BoxFit.cover))),
                      Container(width: 45, child: Padding(
                          padding: const EdgeInsets.all(.5), child: Image.network("https://www.dropbox.com/s/9if32q81q7gblgt/rec2.jpg?raw=1", fit: BoxFit.cover))),
                      Container(width: 45, child: Padding(
                          padding: const EdgeInsets.all(.5), child: Image.network("https://www.dropbox.com/s/bgq3hom20jyabls/rec5.jpg?raw=1", fit: BoxFit.cover))),
                      Container(width: 45, child: Padding(
                          padding: const EdgeInsets.all(.5), child: Image.network("https://www.dropbox.com/s/z80ar18b8gv05k1/rec4.jpg?raw=1", fit: BoxFit.cover))),
                      Container(width: 45, child: Padding(
                          padding: const EdgeInsets.all(.5), child: Image.network("https://www.dropbox.com/s/qpvzwjmhwa5tkpy/rec6.jpg?raw=1", fit: BoxFit.cover))),
                      Container(width: 45, child: Padding(
                          padding: const EdgeInsets.all(.5), child: Image.network("https://www.dropbox.com/s/sxzi3j3506rc6on/rec3.jpg?raw=1", fit: BoxFit.cover))),
                      Container(width: 45, child: Padding(
                          padding: const EdgeInsets.all(.5), child: Image.network("https://www.dropbox.com/s/cmxqmn01q2ei2cw/rec7.jpg?raw=1", fit: BoxFit.cover))),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}