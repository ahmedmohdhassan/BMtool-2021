import 'package:business_manager/classes/order_class.dart';
import 'package:business_manager/classes/order_provider.dart';
import 'package:business_manager/screens/details_page.dart';
import 'package:business_manager/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListItem1st extends StatefulWidget {
  ListItem1st({
    Key key,
    @required this.orders,
    @required this.date,
    @required this.userId,
  }) : super(key: key);

  List<Order> orders;
  final String date;
  final int userId;

  @override
  _ListItem1stState createState() => _ListItem1stState();
}

class _ListItem1stState extends State<ListItem1st> {
  statusIcon(int index) {
    if (widget.orders[index].orderType == '0') {
      return Text(
        'قيد التنفيذ',
        style: kTitleStyle,
      );
    } else if (widget.orders[index].orderType == '1') {
      return Column(
        children: [
          Icon(
            Icons.check,
            color: Colors.green[900],
            size: 25,
          ),
          Text('تم التنفيذ'),
        ],
      );
    } else if (widget.orders[index].orderType == '2') {
      return Column(
        children: [
          Icon(
            Icons.close,
            color: Colors.red[900],
            size: 25,
          ),
          Text('تم الالغاء'),
        ],
      );
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _onRefresh() {
    Provider.of<OrderProvider>(
      context,
      listen: false,
    ).getTodayOrders(widget.userId, widget.date).then((_) {
      setState(() {
        widget.orders =
            Provider.of<OrderProvider>(context, listen: false).items;
      });
    });
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
// TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      physics: BouncingScrollPhysics(),
      enablePullDown: true,
      enablePullUp: false,
      header: ClassicHeader(
        refreshStyle: RefreshStyle.Follow,
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: widget.orders.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  DetailsPage.routeName,
                  arguments: widget.orders[i].id,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.orders[i].customerName}',
                            style: kDescriptionStyle,
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            '  :اسم العميل',
                            style: kTitleStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.orders[i].address}',
                            style: kDescriptionStyle,
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '  :العنوان',
                            style: kTitleStyle,
                          ),
                          Expanded(
                            child: Icon(
                              Icons.place_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.orders[i].deliveryTime}',
                            style: kDescriptionStyle,
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            '  :موعد التسليم',
                            style: kTitleStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: statusIcon(i),
                        ),
                      ),

                      ////////////////////////////////
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
