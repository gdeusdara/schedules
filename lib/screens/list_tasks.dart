import 'package:schedules/util/build_list.dart';
import 'package:flutter/material.dart';
import '../services/requests.dart';
import 'package:schedules/screens/schedule.dart';

class ListTasks extends StatefulWidget {
  @override
  _ListTasksState createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showSchedulePage,
      ),
      body: FutureBuilder(
        future: getTasks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    strokeWidth: 5.0,
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Container();
              } else {
                return buildList(context, snapshot);
              }
          }
        },
      ),
    );
  }

  void _showSchedulePage({Map task}) async {
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => Schedule(task: task,))
    );
    getTasks();
  }
}
