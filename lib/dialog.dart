import 'package:flutter/material.dart';

Dialog leadDialog = Dialog(
  child: Container(
    height: 300.0,
    width: 360.0,
    color: Colors.greenAccent.shade100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'connect to device first',
            style:
            TextStyle(color: Colors.black, fontSize: 22.0),
          ),
        ),
      ],
    ),
  ),
);