import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/controller.dart';
import 'package:schedules/screens/schedule.dart';

class ListTasks extends StatefulWidget {
  @override
  _ListTasksState createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  List _list = [];

  void initState() {
    // TODO: implement initState
    super.initState();

    readData().then((data) {
      setState(() {
        _list = json.decode(data);
      });
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _list.sort((a, b) {
        // leaving the incomplete tasks below
        if (a["Completed"] && !b["Completed"]) {
          return 1;
        } else if (!a["Completed"] && b["Completed"]) {
          return -1;
        } else
          return 0;
      });
      saveData(_list);
    });
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showSchedulePage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        child: ListView.builder(
          padding: EdgeInsets.only(top: 10.0),
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) {
            // fixing date to MM/DD/YYYY
            String deadline;
            if (_list[index]['Deadline'] != null ||
                _list[index]['Deadline'] != '') {
              deadline = _list[index]['Deadline'];

              String today =
                  "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";

              if (deadline == today) {
                deadline = "Today!";
              }
            }

            // The _list
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Schedule(
                          list: _list,
                          index: index,
                        ),
                  ),
                );
              },
              child: Card(
                elevation: 5.0,
                margin: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: ListTile(
                    title: Text(
                      _list[index]["Title"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      _list[index]['Description'] == '' ||
                              _list[index]['Description'] == null
                          ? 'No Description'
                          : _list[index]['Description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      deadline ?? '',
                      style: TextStyle(color: Colors.grey),
                    ),
                    leading: IconButton(
                      icon: Icon(
                        _list[index]["Completed"]
                            ? Icons.check_circle
                            : Icons.error_outline,
                        color: _list[index]["Completed"]
                            ? Colors.green
                            : deadline == "Today!"
                                ? Colors.yellow
                                : Colors.redAccent,
                        size: 27.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _list[index]["Completed"] =
                              !_list[index]["Completed"];
                          saveData(_list);
                        });
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        onRefresh: _refresh,
      ),
    );
  }

  void _showSchedulePage({List list}) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Schedule(
                  list: _list,
                )));
  }
}
