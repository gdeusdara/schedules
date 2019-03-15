import 'package:schedules/util/remove_button.dart';
import 'package:flutter/material.dart';
import '../util/decoration.dart';
import '../util/is_completed.dart';
import '../services/controller.dart';
import 'package:schedules/util/deadline.dart';
import 'package:schedules/util/rouded_button.dart';

class Schedule extends StatefulWidget {
  final List list;
  final int index;

  Schedule({this.list, this.index});

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  // Key to make the form's validation
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  Map<String, dynamic> _task = {'Completed': false};

  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Constructor function
  void initState() {
    super.initState();

    if (widget.index != null) {
      _task = widget.list[widget.index];

      _titleController.text = _task['Title'];
      _descriptionController.text = _task['Description'];
      _dateController.text = _task['Deadline'];

    } else {
      _task['DeadLine'] = false;
    }
  }

  // Validator For Title (required):
  String _titleValidator(String value) {
    if (value.isEmpty) {
      return "Missing Title!";
    }
    // if it returns null, the field is valid
    return null;
  }

  _selectCompleted(bool value) {
    setState(() {
      _task['Completed'] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index == null ? 'New Schedule' : 'Edit Schedule'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: decoration('Title', 'Schedule\'s title'),
                    maxLength: 100,
                    controller: _titleController,
                    validator: _titleValidator,
                    onSaved: (value) {
                      _task['Title'] = value;
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration:
                        decoration('Description', 'Describe the Schedule'),
                    maxLines: 4,
                    maxLength: 400,
                    controller: _descriptionController,
                    onSaved: (value) {
                      _task['Description'] = value;
                    },
                  ),
                  SizedBox(height: 15.0),
                  Deadline(
                    controller: _dateController,
                    deadline: _task['Deadline'],
                    onSave: (value) {
                      _task['Deadline'] = value;
                    },
                  ),
                  SizedBox(height: 20.0),
                  isCompleted(_selectCompleted, _task['Completed']),
                  SizedBox(height: 48.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        removeButton(context, widget.list, widget.index),
                        RoundedButton(
                          color: Colors.green,
                          text: widget.index == null
                              ? "Save Schedule"
                              : "Edit Schedule",
                          onPress: () {
                            if (_globalKey.currentState.validate()) {
                              _globalKey.currentState.save();
                              if (widget.index == null) {
                                newTodo(widget.list,_task).then((data) {Navigator.of(context).pop();});
                              } else {
                                editTodo(widget.list, widget.index,_task).then((data) {Navigator.of(context).pop();});
                              }
                            }
                          },
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
