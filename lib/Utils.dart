import 'package:flutter/material.dart';

TextStyle titleLargeStyle = new TextStyle(
  fontSize: 25.0,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle titleNormalStyle = new TextStyle(
  fontSize: 16.0,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle dateStyle = new TextStyle(
  fontSize: 15.0,
  color: Colors.black87,
  fontWeight: FontWeight.normal,
);

String getDate(DateTime dt){
  List months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return months[dt.month - 1] + " " + dt.day.toString() + ", " + dt.year.toString(); 
}