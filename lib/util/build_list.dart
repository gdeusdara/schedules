import 'package:schedules/screens/schedule.dart';
import 'package:flutter/material.dart';
import '../services/requests.dart';

buildList(BuildContext context, AsyncSnapshot snapshot) {
  List list = snapshot.data;

  list.sort((a, b) {
    // leaving the incomplete tasks below
    if (a["Completed"] && !b["Completed"]) {
      return 1;
    } else if (!a["Completed"] && b["Completed"]) {
      return -1;

      // Sorting by Deadline
      // In dart, null != false
    } else if (a["Deadline"] != null && b["Deadline"] == null) {
      return -1;
    } else if (a["Deadline"] == null && b["Deadline"] != null) {
      return 1;
    } else if (a["Deadline"] != null && b["Deadline"] != null) {
      DateTime c = DateTime.parse(a["Deadline"]);
      DateTime d = DateTime.parse(b["Deadline"]);

      return c.compareTo(d);
    } else
      return 0;
  });

  return RefreshIndicator(
    child: ListView.builder(
      padding: EdgeInsets.only(top: 10.0),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        // fixing date to MM/DD/YYYY
        DateTime date;
        String deadline;
        if (list[index]['Deadline'] != null) {
          date = DateTime.parse(list[index]['Deadline']);
          if (date.day == DateTime.now().day &&
              date.month == DateTime.now().month &&
              date.year == DateTime.now().year) {
            deadline = "Today!";
          } else {
            deadline = "${date.month}/${date.day}/${date.year}";
          }
        }

        // The list
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Schedule(
                      task: list[index],
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
                  list[index]["Title"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  list[index]['Description'] == '' ||
                          list[index]['Description'] == null
                      ? 'No Description'
                      : list[index]['Description'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  deadline ?? '',
                  style: TextStyle(color: Colors.grey),
                ),
                leading: Icon(
                  list[index]["Completed"]
                      ? Icons.check_circle
                      : Icons.error_outline,
                  color: list[index]["Completed"]
                      ? Colors.green
                      : deadline == "Today!"
                          ? Colors.yellow
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
