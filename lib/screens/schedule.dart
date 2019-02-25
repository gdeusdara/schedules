import 'package:schedules/util/error_message.dart';
import 'package:schedules/util/remove_button.dart';
import 'package:flutter/material.dart';
import '../util/decoration.dart';
import '../util/is_completed.dart';
import '../services/requests.dart';
import 'package:schedules/util/deadline.dart';
import 'package:schedules/util/rouded_button.dart';

class Schedule extends StatefulWidget {
  final Map<String, dynamic> task;

  Schedule({this.task});

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

    if (widget.task != null) {
      _titleController.text = widget.task['Title'];
      _descriptionController.text = widget.task['Description'];
      var date;
      String deadline;
      if (widget.task['Deadline'] != null) {
        date = DateTime.parse(widget.task['Deadline']);
        deadline = "${date.month}/${date.day}/${date.year}";
      }
      _dateController.text = deadline;

      _task = widget.task;
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

  _afterSubmit(response) {
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      errorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Schedule' : 'Edit Schedule'),
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
                    decoration: decoration('Title', 'Schedule\' title'),
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
                        removeButton(context, widget.task),
                        RoundedButton(
                          color: Colors.green,
                          text: widget.task == null
                              ? "Save Schedule"
                              : "Edit Schedule",
                          onPress: () {
                            if (_globalKey.currentState.validate()) {
                              _globalKey.currentState.save();
                              if (widget.task == null) {
                                postTask(_task).then(_afterSubmit);
                              } else {
                                editTask(_task).then(_afterSubmit);
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
