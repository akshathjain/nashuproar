import 'package:flutter/material.dart';
import 'Colors.dart';

TextStyle getTitleLargeStyle(BuildContext context){
  return TextStyle(
    fontSize: 25.0,
    color: Theme.of(context).brightness == Brightness.dark ? TEXT_ON_DARK : TEXT_ON_LIGHT,
    fontWeight: FontWeight.bold,
  );
}

TextStyle getTitleNormalStyle(BuildContext context){
  return TextStyle(
    fontSize: 16.0,
    color: Theme.of(context).brightness == Brightness.dark ? TEXT_ON_DARK : TEXT_ON_LIGHT,
    fontWeight: FontWeight.bold,
  );
}

TextStyle getAuthorStyle(BuildContext context){
  return TextStyle(
    fontSize: 16.0,
    color: Theme.of(context).brightness == Brightness.dark ? TEXT_ON_DARK : TEXT_ON_LIGHT,
    fontWeight: FontWeight.w600
  );
}

TextStyle getDateStyle(BuildContext context){
  return TextStyle(
    fontSize: 15.5,
    color: Theme.of(context).brightness == Brightness.dark ? TEXT_ON_DARK_OFFSET : TEXT_ON_LIGHT_OFFSET,
    fontWeight: FontWeight.normal,
  );
}

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