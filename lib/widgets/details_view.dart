import 'package:flutter/material.dart';

class DetailsView extends StatelessWidget {
  DetailsView({
    @required this.title,
    @required this.description,
    @required this.icon,
    @required this.titleStyle,
    @required this.describStyle,
  });

  final String title;
  final String description;
  final IconData icon;
  final TextStyle titleStyle;
  final TextStyle describStyle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: titleStyle,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                icon,
                color: Colors.grey,
              ),
            )
          ],
        ),
        Text(
          description,
          style: describStyle,
          textDirection: TextDirection.rtl,
          softWrap: true,
        ),
      ],
    );
  }
}
