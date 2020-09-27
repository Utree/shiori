import 'package:flutter/material.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';
import 'package:shiori_client/ui/component/BookletMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Booklet extends StatefulWidget {
  @override
  _Booklet createState() => _Booklet();
}

class _Booklet extends State<Booklet> with TickerProviderStateMixin {
  // map表示用
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition posi = CameraPosition(
    target: LatLng(34.6887367, 135.4384213),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    var list = ["0","1","2","3"];

    return Scaffold(
        backgroundColor: AppTheme.beige,
        appBar: AppBar(
          title: Text(args),
          elevation: 0.0,
          backgroundColor: AppTheme.orange,
          actions: [
            IconButton(
              icon: Icon(Icons.dehaze),
              onPressed: () {
                Navigator.of(context).pushNamed("/album", arguments: args);
              },
            )
          ],
        ),
        // Body
        body: CustomScrollView(
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
                      child: BookletMap(posi: posi, controller: _controller),
                    );
                  } else {
                    var paddingTop;
                    if(index == 1) {
                      paddingTop = 20.0;
                    } else {
                      paddingTop = 0.0;
                    }
                    var itm;
                    if(index != list.length) {
                      itm = MiddleItem();
                    } else {
                      itm = LastItem();
                    }
                    return Container(
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
                                child: Text("観光スポット1"),
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
                    );
                  }
                },
                childCount: list.length+1
              ),
            ),
          ],
        )
    );
  }
}

class MiddleItem extends StatelessWidget {
  const MiddleItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(color: Colors.grey, width: 2)
        ),
      ),
    );
  }
}
class LastItem extends StatelessWidget {
  const LastItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      ),
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
        title: Container(
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
                      Container(width: 45, color: Colors.red,),
                      Container(width: 45, color: Colors.blue,),
                      Container(width: 45, color: Colors.green,),
                      Container(width: 45, color: Colors.red,),
                      Container(width: 45, color: Colors.blue,),
                      Container(width: 45, color: Colors.green,),
                    ],
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}