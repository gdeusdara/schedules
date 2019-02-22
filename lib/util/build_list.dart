import 'package:schedules/screens/schedule.dart';
import 'package:flutter/material.dart';
import '../services/requests.dart';

buildList(BuildContext context, AsyncSnapshot snapshot) {
  return RefreshIndicator(
    child: ListView.builder(
      padding: EdgeInsets.only(top: 10.0),
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        var date;
        String deadline;
        if (snapshot.data[index]['Deadline'] != null) {
          date = DateTime.parse(snapshot.data[index]['Deadline']);
          deadline = "${date.month}/${date.day}/${date.year}";
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Schedule(
                      task: snapshot.data[index],
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
                  snapshot.data[index]["Title"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  snapshot.data[index]['Description'] == '' ||
                          snapshot.data[index]['Description'] == null
                      ? 'No Description'
                      : snapshot.data[index]['Description'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  deadline ?? '',
                  style: TextStyle(color: Colors.grey),
                ),
                leading: Icon(
                  snapshot.data[index]["Completed"]
                      ? Icons.check_circle
                      : Icons.error_outline,
                  color: snapshot.data[index]["Completed"]
                      ? Colors.green
                      : Colors.redAccent,
                  size: 27.0,
                ),
              ),
            ),
          ),
        );
      },
    ),
    onRefresh: getTasks,
  );
}
