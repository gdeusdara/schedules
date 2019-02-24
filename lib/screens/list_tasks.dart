import 'package:schedules/util/build_list.dart';
import 'package:flutter/material.dart';
import 'package:schedules/util/loading.dart';
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
              return Loading();
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
