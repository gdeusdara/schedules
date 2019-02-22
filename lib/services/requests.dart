import 'package:http/http.dart' as http;
import 'dart:convert';

final userid = 'ea548961dc404a8ebe54ec3af03106';

Future getTasks() async {
  await Future.delayed(Duration(milliseconds: 500));
  final tasks = 'http://prova.scytlbrasil.com:81/Api/tasks?userid=$userid';
  print(tasks);
  http.Response response = await http.get(tasks);
  print(json.decode(response.body));
  return json.decode(response.body);
}

postTask(Map task) async {
  final postTask =
      'http://prova.scytlbrasil.com:81/Api/tasks/PostTask?userid=$userid';
  http.Response response = await http.post(postTask, body: {
    "title": task["Title"],
    "description": task["Description"],
    "completed": task["Completed"] ? "true" : "false",
    "deadline": task["Deadline"],
  });
  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");
  return response;
}

Future<Map> getTask(int taskId) async {
  final task =
      'http://prova.scytlbrasil.com:81/Api/tasks/GetTask?id=$taskId&userid=$userid';
  http.Response response = await http.get(task);
  return json.decode(response.body);
}

editTask(Map task) async {
  final editTask =
      'http://prova.scytlbrasil.com:81/Api/tasks/EditTask?id=${task['Id']}&userid=$userid';
  http.Response response = await http.post(editTask, body: {
    "title": task["Title"],
    "description": task["Description"],
    "completed": task["Completed"] ? "true" : "false",
    "deadline": task["Deadline"],
  });
  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");
  return response;
}

removeTask(int taskId) async {
  final task =
      'http://prova.scytlbrasil.com:81/Api/tasks/RemoveTask?id=$taskId&userid=$userid';
  http.Response response = await http.post(task);

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");
  return response;
}
