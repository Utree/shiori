import 'package:flutter/material.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';
import 'package:shiori_client/ui/component/AuthInputFormWidget.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppTheme.beige,
      body: SingleChildScrollView(
        child: new Center(
            child: new Column(
              mainAxisSize: MainAxisSize.min,  // 画面中央にセンタリング
              children: <Widget>[
                new Container(margin: EdgeInsets.all(80),), // レイアウト用空白
                new Container(  // アイコン
                  width: 100,
                  height: 100,
                  color: AppTheme.white,
                  child: Text("icon"),
                ),
                new Text(  // アプリ名
                  AppTheme.AppName,
                  style: TextStyle(
                      fontFamily: "Chewy",
                      fontSize: 50,
                      color: AppTheme.orange
                  ),
                ),
                new Padding(
                    padding: const EdgeInsets.all(30), // 入力とボタンにパディング
                    child: new Form(
                        child: new Column(
                          children: [
                            new AuthInputFormWidget(label: "Name", isPasswd: false, hint: "shiori_user1",),
                            new AuthInputFormWidget(label: "Email", isPasswd: false, hint: "shiori@example.com",),
                            new AuthInputFormWidget(label: "Password", isPasswd: true, hint: "6文字以上のパスワード",),
                            new Container(margin: EdgeInsets.all(10),), // レイアウト用空白
                            new RaisedButton( // サインアップボタン
                                onPressed:() => {
                                  // TODO: サインアップ処理
                                  Navigator.of(context).pushReplacementNamed("/home")
                                },
                                color: AppTheme.blue,
                                child: new Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 60, right: 60),
                                  child: Text(
                                    'signup',
                                    style: TextStyle(
                                      color: AppTheme.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                shape: StadiumBorder()
                            ),
                            new FlatButton(  // ログインに戻るボタン
                                child: new Text(
                                  "or login",
                                  style: TextStyle(color: AppTheme.blue),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }
                            ),
                          ],
                        )
                    )
                ),
              ],
            )
        ),
      ),
    );
  }
}