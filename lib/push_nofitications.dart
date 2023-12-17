import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationManager {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  void init() {
    if (Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions(
          IosNotificationSettings(sound: true, alert: true, badge: true));
      firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }
    firebaseMessaging.getToken().then((token) async {
      String firebaseToken = token.toString();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('firebase_token', firebaseToken);
    });
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('On Message : $message');
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('On Message : $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('On Message : $message');
      },
    );
  }
}

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   if (message.containsKey('data')) {
//     final dynamic data = message['data'];
//   }
//   if (message.containsKey('notification')) {
//     final dynamic notification = message['notification'];
//   }
// }
