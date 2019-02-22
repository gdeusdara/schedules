import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final Function onPress;
  final String text;
  final color;

  const RoundedButton({this.onPress, this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: 125.0,
      margin: EdgeInsets.all(5.0),
      child: RaisedButton(
        onPressed: onPress,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Text(text),
        color: color,
      ),
    );
  }
}
