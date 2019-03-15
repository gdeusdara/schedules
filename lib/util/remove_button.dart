import 'package:schedules/services/controller.dart';
import 'package:schedules/util/rouded_button.dart';
import 'package:flutter/material.dart';

  Widget removeButton(BuildContext context, List list, int index) {
    if (index != null) {
      return RoundedButton(
        color: Colors.deepOrange,
        text: "Delete",
        onPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("Are you Sure?"),
                content: Text("You are about to delete this schedule!"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Delete"),
                    onPressed: () {
                      removeTodo(list, index).then((response) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else
      return Container();
  }
