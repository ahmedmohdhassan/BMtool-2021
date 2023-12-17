import 'dart:convert';

import 'package:business_manager/classes/order_class.dart';
import 'package:business_manager/classes/order_provider.dart';
import 'package:business_manager/styles.dart';
import 'package:business_manager/widgets/details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  static const routeName = 'details_page';

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isLoading;
  bool isPressed;
  bool isInit = true;
  Order selectedOrder;
  String selectedOrderID;
  String userComment = '0';
  showTextDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        elevation: 5,
        child: Container(
          height: 300,
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'هل تريد اضافة تعليق؟',
                style: kTitleStyle,
              ),
              Divider(
                thickness: 2,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'أضف تعليق',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(
                      Icons.comment_outlined,
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      userComment = value;
                    });
                  },
                ),
              ),
              FlatButton(
                child: Text(
                  'Ok',
                  style: kTitleStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop(userComment);
                  print(userComment);
                  setState(() {
                    isLoading = true;
                  });
                  onPressed(selectedOrderID, userComment, type).then((_) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future onPressed(String orderId, String comment, String type) async {
    String url =
        'http://bm.mahgoubtech.com/order_update.php/?result=$comment&type=$type&id=$orderId';

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    print(jsonData);
    if (response.statusCode == 200) {
      if (jsonData == 1) {
        setState(() {
          selectedOrder.orderType = '1';
        });
      } else if (jsonData == 2) {
        setState(() {
          selectedOrder.orderType = '2';
        });
      }
    } else {
      return;
    }
    return Future.value();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      selectedOrderID = ModalRoute.of(context).settings.arguments as String;
      selectedOrder = Provider.of<OrderProvider>(context)
          .items
          .firstWhere((order) => order.id == selectedOrderID);

      isInit = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget trailingContainer() {
      Widget trailingContainer;
      if (selectedOrder.orderType == '0') {
        trailingContainer = Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text('خروج'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red[900],
                  ),
                  onPressed: () {
                    showTextDialog('2');
                  },
                ),
                Text('الغاء التنفيذ'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    showTextDialog('1');
                  },
                ),
                Text('تأكيد التنفيذ'),
              ],
            ),
          ],
        );
      } else if (selectedOrder.orderType == '2') {
        trailingContainer = Text(
          'تم الغاء الطلب',
          style: kDescriptionStyle.copyWith(
            color: Colors.red[900],
          ),
        );
      } else if (selectedOrder.orderType == '1') {
        trailingContainer = Text(
          'تم تنفيذ الطلب',
          style: kDescriptionStyle.copyWith(
            color: Colors.green[900],
          ),
        );
      }
      return trailingContainer;
    }

    return isLoading == true
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueGrey[900],
              ),
            ),
          )
        : Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'التفاصيل',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0xFF1A2038),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.black54,
                        ),
                        DetailsView(
                          title: 'اسم العميل:',
                          titleStyle: kTitleStyle,
                          description: '${selectedOrder.customerName}',
                          describStyle: kDescriptionStyle,
                          icon: Icons.person_outline,
                        ),
                        DetailsView(
                          title: 'عنوان العميل:',
                          titleStyle: kTitleStyle,
                          description: '${selectedOrder.address}',
                          describStyle: kDescriptionStyle,
                          icon: Icons.place_outlined,
                        ),
                        DetailsView(
                          title: 'ت العميل:',
                          titleStyle: kTitleStyle,
                          description: '${selectedOrder.customerMob}',
                          describStyle: kDescriptionStyle,
                          icon: Icons.phone_iphone_outlined,
                        ),
                        DetailsView(
                          title: 'اسم الطلب:',
                          titleStyle: kTitleStyle,
                          description: '${selectedOrder.title}',
                          describStyle: kDescriptionStyle,
                          icon: Icons.description_outlined,
                        ),
                        DetailsView(
                          title: 'ملاحظات:',
                          titleStyle: kTitleStyle,
                          description: '${selectedOrder.orderNotice}',
                          describStyle: kDescriptionStyle,
                          icon: Icons.notes_outlined,
                        ),
                        DetailsView(
                          title: 'تاريخ التسليم:',
                          titleStyle: kTitleStyle,
                          description: '${selectedOrder.deliveryDate}',
                          describStyle: kDescriptionStyle,
                          icon: Icons.calendar_today_outlined,
                        ),
                        DetailsView(
                          title: 'موعد التسليم:',
                          titleStyle: kTitleStyle,
                          description: '${selectedOrder.deliveryTime}',
                          describStyle: kDescriptionStyle,
                          icon: Icons.access_time_outlined,
                        ),
                        DetailsView(
                          title: 'السعر:',
                          titleStyle: kTitleStyle,
                          description: '${selectedOrder.price}',
                          describStyle: kDescriptionStyle,
                          icon: Icons.attach_money_outlined,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Container(
                            child: Center(
                              child: trailingContainer(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
            ),
          );
  }
}
