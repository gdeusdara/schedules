import 'package:flutter/material.dart';

Widget isCompleted(Function onChanged, bool value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text("Is this Schedule Completed?"),
      SizedBox(width: 12.0),
      Row(
        children: [true, false]
            .map((bool index) => Row(
                  children: <Widget>[
                    Radio<bool>(
                      value: index,
                      groupValue: value,
                      onChanged: onChanged,
                    ),
                    Text(index ? "Yes" : "No"),
                  ],
                ))
            .toList(),
      )
    ],
  );
}
