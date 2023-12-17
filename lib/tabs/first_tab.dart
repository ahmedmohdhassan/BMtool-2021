import 'package:business_manager/classes/order_provider.dart';
import 'package:business_manager/styles.dart';
import 'package:business_manager/widgets/list_item_1st.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class FirstTab extends StatefulWidget {
  @override
  _FirstTabState createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {
  bool isLoading;
  bool isInit = true;
  int userId;
  String formattedDate;

  getUserId() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      userId = _pref.getInt('id');
    });
    print(userId);
  }

  void getDateString() {
    var date = DateTime.now();
    String f = DateFormat('yyyy-MM-dd').format(date);
    setState(() {
      formattedDate = f;
    });
    print(formattedDate);
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      getDateString();
      getUserId().then((_) {
        Provider.of<OrderProvider>(context, listen: false)
            .getTodayOrders(userId, formattedDate)
            .then((_) {
          setState(() {
            isLoading = false;
          });
        }).catchError((error) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('خطأ'),
              content: Text('خطأ في الاتصال'),
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
        });
      });
    }
    isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context, listen: false).items;
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueGrey[900],
            ),
          )
        : SafeArea(
            child: orders.isEmpty
                ? Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'لا يوجد طلبات للعرض',
                        style: kTitleStyle,
                      ),
                    ),
                  )
                : ListItem1st(
                    orders: orders,
                    userId: userId,
                    date: formattedDate,
                  ),
          );
  }
}
