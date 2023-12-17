import 'package:business_manager/classes/order_class.dart';
import 'package:business_manager/classes/order_provider.dart';
import 'package:business_manager/styles.dart';
import 'package:business_manager/widgets/list_item_2nd.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondTab extends StatefulWidget {
  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  List<Order> ordersByDate = [];
  String selectedDate;
  int userId;
  bool isLoading;
  void getUserId() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      userId = _pref.getInt('id');
    });
    print(userId);
  }

  void onDateSelected() {
    setState(() {
      isLoading = true;
    });
    Provider.of<OrderProvider>(context, listen: false)
        .getTodayOrders(userId, selectedDate)
        .then((_) {
      setState(() {
        ordersByDate = Provider.of<OrderProvider>(context, listen: false).items;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getUserId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: DateTimePicker(
                  decoration: InputDecoration(
                    hintText: '....اختر التاريخ',
                    prefixIcon: Icon(
                      Icons.calendar_today,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: enabledBorder,
                    errorBorder: errorBorder,
                  ),
                  type: DateTimePickerType.date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  dateMask: 'yyyy-MM-dd',
                  onChanged: (value) {
                    setState(() {
                      selectedDate = value;
                    });
                  },
                  onFieldSubmitted: (value) {
                    selectedDate = value;
                    onDateSelected();
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  onDateSelected();
                },
              ),
            ],
          ),
        ),
        isLoading == true
            ? Expanded(
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blueGrey[900],
                    ),
                  ),
                ),
              )
            : Expanded(
                child: ordersByDate.isEmpty
                    ? Center(
                        child: Text(
                          'لا يوجد طلبات للعرض',
                          style: kTitleStyle,
                        ),
                      )
                    : ListItem2nd(
                        ordersByDate: ordersByDate,
                        date: selectedDate,
                        userId: userId,
                      ),
              ),
      ],
    );
  }
}
