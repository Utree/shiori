import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';
import 'package:shiori_client/ui/component/AuthInputFormWidget.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  Future<bool> _futureLogin;

  @override
  void initState() {
    super.initState();
    _futureLogin = initLogin();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emlCtrlr =
        TextEditingController(); // email editing controller
    TextEditingController pwdCtrlr =
        TextEditingController(); // password editing controller

    return new Scaffold(
      backgroundColor: AppTheme.beige,
      body: SingleChildScrollView(
        child: new Center(
            child: new Column(
          mainAxisSize: MainAxisSize.min, // 画面中央にセンタリング
          children: <Widget>[
            new Container(
              margin: EdgeInsets.all(80),
            ), // レイアウト用空白
            new Container(
              // アイコン
              width: 100,
              height: 100,
              color: AppTheme.white,
              child: Text("icon"),
            ),
            new Text(
              // アプリ名
              AppTheme.AppName,
              style: TextStyle(
                  fontFamily: "Chewy", fontSize: 50, color: AppTheme.orange),
            ),
            new Padding(
                padding: const EdgeInsets.all(30), // 入力とボタンにパディング
                child: new Form(
                    child: new Column(
                  children: [
                    new AuthInputFormWidget(
                      label: "Email",
                      isPasswd: false,
                      hint: "shiori@example.com",
                      ctrlr: emlCtrlr,
                    ),
                    new AuthInputFormWidget(
                      label: "Password",
                      isPasswd: true,
                      hint: "6文字以上のパスワード",
                      ctrlr: pwdCtrlr,
                    ),
                    new Container(
                      margin: EdgeInsets.all(10),
                    ), // レイアウト用空白
                    FutureBuilder<bool>(
                      future: _futureLogin,
                      builder: (context, snapshot) {
                        // network check
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data) {
                            // ログイン成功時
                            return Text("Got data");
                          } else {
                            return RaisedButton(
                              // ログインボタン
                                onPressed: () => {
                                  setState(() {
                                    // TODO: ログイン処理
                                    _futureLogin = LoginRequest(emlCtrlr.text, pwdCtrlr.text, context);
                                  })
                                },
                                color: AppTheme.blue,
                                child: new Padding(
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 60, right: 60),
                                  child: Text(
                                    'login',
                                    style: TextStyle(
                                      color: AppTheme.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                shape: StadiumBorder());
                          }
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    new FlatButton(
                        // サインインボタン
                        child: new Text(
                          "or sign up",
                          style: TextStyle(color: AppTheme.blue),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed("/sighup");
                        }),
                  ],
                ))),
          ],
        )),
      ),
    );
  }
}

Future<bool> initLogin() async => false;

Future<bool> LoginRequest(String email, String password, BuildContext ctx) async {
  final prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.post(
    AppTheme.ApiIP + '/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(LoginInfo(email: email, password: password)),
  ).then((value) {
    // access_tokenを格納
    prefs.setString('access_token', json.decode(value.body)['access_token'].toString());
    return value;
  }).then((value) {
    // ページ遷移
    Navigator.of(ctx).pushReplacementNamed("/home");
    return value;
  });

  return true;
}

class LoginInfo {
  final String email;
  final String password;

  LoginInfo({this.email, this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
