import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';
import 'package:shiori_client/ui/component/AuthInputFormWidget.dart';

class AddSpot extends StatefulWidget {
  @override
  _AddSpot createState() => _AddSpot();
}

class _AddSpot extends State<AddSpot> {
  // 時計
  TimeOfDay _time = new TimeOfDay.now();
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if(picked != null) setState(() => _time = picked);
  }
  // 地図
  GoogleMapController mapController;
  LatLng _lastTap;
  CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(34.6887367, 135.4384213),
    zoom: 8,
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _add(LatLng place) {
    /**
     * ピンを追加
     */
    final MarkerId markerId = MarkerId("tapped");

    final Marker marker = Marker(
      markerId: markerId,
      position: place,
      infoWindow: InfoWindow(title: "tapped"),
    );

    setState(() {
      // reset
      markers = {};
      // add
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.beige,
        appBar: AppBar(
          title: Text("スポットを追加"),backgroundColor: AppTheme.orange,
        ),
        body: Theme(
          data: ThemeData(
              accentColor: Colors.orange,
              primarySwatch: Colors.orange,
              colorScheme: ColorScheme.light(
                  primary: Colors.orange
              )
          ),
          child: SingleChildScrollView(
            child: new Center(
                child: new Column(
                  mainAxisSize: MainAxisSize.min, // 画面中央にセンタリング
                  children: <Widget>[
                    new Padding(
                        padding: const EdgeInsets.all(30), // 入力とボタンにパディング
                        child: new Form(
                            child: new Column(
                              children: [
                                new AuthInputFormWidget(
                                  label: "スポットの名前",
                                  isPasswd: false,
                                  hint: "〇〇空港",
                                  ctrlr: null,
                                ),
                                Row(  // ラベル
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text("場所をタップ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 300.0,
                                  height: 200.0,
                                  child: GoogleMap(
                                    markers: Set<Marker>.of(markers.values),
                                    onMapCreated: (GoogleMapController controller) {
                                      setState(() {
                                        _add(_kInitialPosition.target);
                                        mapController = controller;
                                      });
                                    },
                                    initialCameraPosition: _kInitialPosition,
                                    onTap: (LatLng pos) {
                                      setState(() {
                                        _lastTap = pos;
                                        _add(pos);
                                      });
                                    },
                                  ),
                                ),
                                Row(  // ラベル
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text("到着時刻", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: Text(_time.format(context), style: TextStyle(fontSize: 25),),),
                                      RaisedButton(
                                        color: AppTheme.blue,
                                        onPressed: () => _selectTime(context),
                                        child: new Text('変更', style: TextStyle(color: AppTheme.white),),
                                      )
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.all(10),
                                ), // レイアウト用空白
                                RaisedButton(
                                    onPressed: () => {
                                      Navigator.pop(context)
                                    },
                                    color: AppTheme.orange,
                                    child: new Padding(
                                      padding: EdgeInsets.only(
                                          top: 15, bottom: 15, left: 60, right: 60),
                                      child: Text(
                                        '追加',
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                    shape: StadiumBorder()),
                              ],
                            ))),
                  ],
                )),
          )
        )
    );
  }
}
