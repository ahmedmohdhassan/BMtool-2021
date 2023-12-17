import 'package:flutter/material.dart';

const enabledBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white, width: 0.0),
  borderRadius: BorderRadius.all(
    Radius.circular(30),
  ),
);

const errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red, width: 1.0),
  borderRadius: BorderRadius.all(
    Radius.circular(30),
  ),
);

const TextStyle kTitleStyle = TextStyle(
  color: Color(0xFF1A2038),
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
const TextStyle kDescriptionStyle = TextStyle(
  color: Colors.blue,
  fontSize: 18,
  fontWeight: FontWeight.normal,
);
