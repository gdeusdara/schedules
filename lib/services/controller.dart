import 'dart:convert';
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';

Future<File> getData() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/data.json');
}

Future<File> saveData(list) async {
  String data = json.encode(list);
  final file = await getData();

  return file.writeAsString(data);
}

Future<String> readData() async {
  try {
    final file = await getData();
    return file.readAsString();
  } catch (e) {
    return null;
  }
}

Future<File> newTodo(List list, todo) async {
  list.add(todo);
  return saveData(list);
}

Future<File> editTodo(List list, int index, todo) async {
  list[index] = todo;
  return saveData(list);
}

Future<File> removeTodo(List list, int index) async {
  list.removeAt(index);
  return saveData(list);
}
