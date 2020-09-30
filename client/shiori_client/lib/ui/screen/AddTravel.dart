import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';
import 'package:shiori_client/ui/component/AuthInputFormWidget.dart';

class AddTravel extends StatefulWidget {
  @override
  _AddTravel createState() => _AddTravel();
}

class _AddTravel extends State<AddTravel> {
  // 日付選択
  DateTime _date = new DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360))
    );
    if(picked != null) setState(() => _date = picked);
  }
  String _fmtr(DateTime d) {
    return "${d.year}/${d.month}/${d.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.beige,
        appBar: AppBar(
          title: Text("shioriを追加"),backgroundColor: AppTheme.orange,
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
                                    label: "タイトル",
                                    isPasswd: false,
                                    hint: "大阪旅行",
                                    ctrlr: null,
                                  ),
                                  Row(  // ラベル
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text("日付", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(child: Text(_fmtr(_date), style: TextStyle(fontSize: 25),),),
                                        RaisedButton(
                                          color: AppTheme.blue,
                                          onPressed: () => _selectDate(context),
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
            ),
        )
    );
  }
}
