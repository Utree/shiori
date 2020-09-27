import 'package:flutter/material.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';

class AuthInputFormWidget extends StatelessWidget {
  /// 入力フォームウィジェット
  String label, hint;
  bool isPasswd;
  TextEditingController ctrlr;

  AuthInputFormWidget({
    @required this.label,
    @required this.isPasswd,
    @required this.hint,
    @required this.ctrlr
  });

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(  // ラベル
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(this.label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        new Material(  // 入力フィールド
          elevation: 2.0,  // 浮き上がり度
          color: Colors.white,  // 背景色
          shape: RoundedRectangleBorder( // 角の丸さ
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 15, top: 3, bottom: 3),  // 入力フォームのサイズ(padding)
            child: TextFormField(
              validator: (val) {  // パスワードの場合バリデーションを掛ける
                if(this.isPasswd && val.length < 6) {
                  return "password is too short";
                } else {
                  return null;
                }
              },
              obscureText: this.isPasswd,  // 入力を隠す
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: this.hint,
                  hintStyle: TextStyle(color: AppTheme.hint, fontSize: 14)),
              controller: ctrlr,
            ),
          ),
        ),
      ],
    );
  }
}