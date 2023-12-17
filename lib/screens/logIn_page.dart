import 'package:business_manager/classes/api_handler.dart';
import 'package:business_manager/screens/home_page.dart';
import 'package:business_manager/styles.dart';
import 'package:business_manager/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  ApiHandler _apiHandler = ApiHandler();
  bool isLoading;
  String userName;
  String passWord;
  String fireBaseToken;
  final _form = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final passNode = FocusNode();

  void autoLogIn() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    int userId = _preferences.getInt('id');
    fireBaseToken = _preferences.getString('firebase_token');
    print(fireBaseToken);
    if (userId != null) {
      Navigator.of(context).pushNamed(
        MyHomePage.routeName,
        arguments: userId,
      );
    }
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(
      Duration(seconds: 0),
    ).then((_) {
      autoLogIn();
    }).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    nameNode.dispose();
    passNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  saveForm() {
    _form.currentState.validate();
    bool valid = _form.currentState.validate();
    if (valid) {
      setState(() {
        isLoading = true;
      });
      _form.currentState.save();
      _apiHandler.signIn(context, userName, passWord, fireBaseToken).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return isLoading == true
        ? Container(
            color: Colors.blueGrey[900],
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.blueGrey[900],
              body: orientation == Orientation.portrait
                  ? Form(
                      key: _form,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          Center(
                            child: Image.asset(
                              'images/mtech_w.png',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10,
                            ),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: nameNode,
                              decoration: InputDecoration(
                                enabledBorder: enabledBorder,
                                errorBorder: errorBorder,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '...أدخل اسم المستخدم',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'من فضلك ادخل اسم المستخدم';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  userName = value;
                                });
                              },
                              onFieldSubmitted: (value) {
                                userName = value;
                                FocusScope.of(context).requestFocus(passNode);
                              },
                              onSaved: (value) {
                                userName = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10,
                            ),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              focusNode: passNode,
                              obscureText: true,
                              decoration: InputDecoration(
                                enabledBorder: enabledBorder,
                                errorBorder: errorBorder,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '...أدخل كلمة المرور',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'من فضلك تدخل كلمة المرور';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  passWord = value;
                                });
                              },
                              onFieldSubmitted: (value) {
                                passWord = value;
                              },
                              onSaved: (value) {
                                passWord = value;
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              saveForm();
                            },
                            child: LogInButton(),
                          ),
                        ],
                      ),
                    )
                  : Form(
                      key: _form,
                      child: ListView(
                        children: [
                          Center(
                            child: Image.asset(
                              'images/mtech_logo.png',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10,
                            ),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: nameNode,
                              decoration: InputDecoration(
                                enabledBorder: enabledBorder,
                                errorBorder: errorBorder,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '...أدخل اسم المستخدم',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'من فضلك ادخل اسم المستخدم';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  userName = value;
                                });
                              },
                              onFieldSubmitted: (value) {
                                userName = value;
                                FocusScope.of(context).requestFocus(passNode);
                              },
                              onSaved: (value) {
                                userName = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10,
                            ),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              focusNode: passNode,
                              obscureText: true,
                              decoration: InputDecoration(
                                enabledBorder: enabledBorder,
                                errorBorder: errorBorder,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '...أدخل كلمة المرور',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'من فضلك تدخل كلمة المرور';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  passWord = value;
                                });
                              },
                              onFieldSubmitted: (value) {
                                passWord = value;
                              },
                              onSaved: (value) {
                                passWord = value;
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              saveForm();
                            },
                            child: LogInButton(),
                          ),
                        ],
                      ),
                    ),
            ),
          );
  }
}
