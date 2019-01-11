/*
Name: Akshath Jain
Date: 1/10/18
Purpose: settings
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDialog extends StatefulWidget{
  static const int LIGHT_VALUE = 0;
  static const int DARK_VALUIE = 1;

  SettingsDialog({Key key}) : super(key: key);
  
  @override
  _SettingsDialogState createState() => new _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>{
  int _themeChooserValue = 0;
  
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPrefs().then((var x){
      setState(() {
        var x = _prefs.getInt("theme-value");
        _themeChooserValue = (x == -1 || x == null) ? 0 : x;
      }); //refresh
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Select Theme"),
          SizedBox(height: 6.0,),
          Text(
            "Requires app restart",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
          ),
        ]
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: _createBody(),
        )
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("SAVE"),
          onPressed: () => _savePrefs().then((var x) => Navigator.pop(context)),
        ),
      ],
    );
  }

  List<Widget> _createBody(){
    if(_themeChooserValue == -1)
      return [Center(child: CircularProgressIndicator(),)];

    return [
      RadioListTile(
        title: Text("Light"),
        value: SettingsDialog.LIGHT_VALUE,
        groupValue: _themeChooserValue,
        onChanged: _handleThemeChange,
      ),
      RadioListTile(
        title: Text("Dark"),
        value: SettingsDialog.DARK_VALUIE,
        groupValue: _themeChooserValue,
        onChanged: _handleThemeChange,
      )
    ];
  }

  void _handleThemeChange(int newTheme){
    setState((){
      _themeChooserValue = newTheme;
    });
  }

  Future<void> _initSharedPrefs() async{
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _savePrefs() async{
    await _prefs.setInt("theme-value", _themeChooserValue);
  }

}