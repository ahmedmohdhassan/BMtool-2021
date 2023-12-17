import 'dart:convert';
import 'package:business_manager/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiHandler {
  // Sign in:
  Future signIn(BuildContext context, String userName, String password,
      String fireBaseToken) async {
    String url = 'http://bm.mahgoubtech.com/login.php';

    var response = await http.post(
      url,
      body: {
        'user': '$userName',
        'pass': '$password',
        'token':'$fireBaseToken',
      },
    );
    var jsonData = jsonDecode(response.body);
    if (jsonData != 0) {
      print('id=$jsonData');
      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.setInt('id', jsonData);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    } else {
      print('error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('خطأ في اسم المستخدم او كلمة المرور'),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
    print(response.statusCode);
    print(response.body);
  }
}
