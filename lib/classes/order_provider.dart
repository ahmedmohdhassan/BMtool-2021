import 'dart:convert';

import 'package:business_manager/classes/order_class.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  Future getTodayOrders(int userId, String date) async {
    String url =
        'http://bm.mahgoubtech.com/order.php/?user_id=$userId&date=$date';

    try {
      final response = await http.get(url);
      final jsonData = jsonDecode(response.body);
      final List<Order> fetchedOrders = [];
      if (response.statusCode == 200) {
        if (jsonData != null) {
          for (Map i in jsonData) {
            fetchedOrders.add(
              Order(
                id: i['order_id'],
                price: i['order_price'],
                title: i['order_title'],
                customerName: i['order_name'],
                customerMob: i['order_mobile'],
                address: i['order_address'],
                deliveryDate: i['order_date'],
                deliveryTime: i['order_time'],
                orderNotice: i['order_notice'],
                orderType: i['order_type'],
              ),
            );
          }
          _items = fetchedOrders;
          notifyListeners();
          return Future.value();
        } else {
          return;
        }
      } else {
        return;
      }
    } catch (error) {
      throw (error);
    }
  }
  //////////////////////////////////////////////////////////////////////////
}
