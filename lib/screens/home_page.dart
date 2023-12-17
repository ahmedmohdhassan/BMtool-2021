import 'dart:io';

import 'package:business_manager/screens/logIn_page.dart';
import 'package:business_manager/tabs/first_tab.dart';
import 'package:business_manager/tabs/second_tab.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = 'home_page';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Tab> tabs = [
    Tab(
      text: 'طلبات اليوم',
    ),
    Tab(
      text: 'حدد تاريخ',
    ),
  ];

  List<String> choices = ['تسجيل خروج'];

  void onSelected(value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setInt('id', null);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LogInPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                PopupMenuButton(
                  onSelected: onSelected,
                  itemBuilder: (context) {
                    return choices.map((choice) {
                      return PopupMenuItem(
                        child: GestureDetector(
                          onTap: () async {
                            SharedPreferences _preferences =
                                await SharedPreferences.getInstance();
                            _preferences.setInt('id', null);
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LogInPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(choice),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        value: choice,
                      );
                    }).toList();
                  },
                ),
              ],
              title: Text(
                'إدارة الطلبات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              bottom: TabBar(
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: [
                FirstTab(),
                //////////////////////////////////////////////////////////////////////
                SecondTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
