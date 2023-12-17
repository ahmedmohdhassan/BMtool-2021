import 'package:business_manager/classes/order_provider.dart';
import 'package:business_manager/push_nofitications.dart';
import 'package:business_manager/screens/details_page.dart';
import 'package:business_manager/screens/home_page.dart';
import 'package:business_manager/screens/logIn_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(MyApp());
  pushNotification.init();
}

final PushNotificationManager pushNotification = PushNotificationManager();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: RefreshConfiguration(
        headerBuilder: () =>
            WaterDropHeader(), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
        headerTriggerDistance: 80.0, // header trigger refresh trigger distance
        springDescription: SpringDescription(
            stiffness: 170,
            damping: 16,
            mass:
                1.9), // custom spring back animate,the props meaning see the flutter api
        maxOverScrollExtent:
            100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
        maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(color: Colors.blueGrey[900]),
          ),
          home: LogInPage(),
          routes: {
            MyHomePage.routeName: (context) => MyHomePage(),
            DetailsPage.routeName: (context) => DetailsPage(),
          },
        ),
      ),
    );
  }
}
