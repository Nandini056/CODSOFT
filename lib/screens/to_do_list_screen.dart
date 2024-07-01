import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'task_form_screen.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskListJson = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks = taskListJson.map((taskJson) => Task.fromJson(jsonDecode(taskJson))).toList();
    });
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskListJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList('tasks', taskListJson);
  }

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
      saveTasks();
    });
  }

  void updateTask(int index, Task task) {
    setState(() {
      tasks[index] = task;
      saveTasks();
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      saveTasks();
    });
  }

  void confirmDeleteTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteTask(index);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Task deleted")));
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskTile(
            task: tasks[index],
            onTap: () async {
              Task? updatedTask = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskFormScreen(task: tasks[index])),
              );
              if (updatedTask != null) {
                updateTask(index, updatedTask);
              }
            },
            onCheckboxChanged: (value) {
              setState(() {
                tasks[index].isCompleted = value!;
                saveTasks();
              });
            },
            onDelete: () => confirmDeleteTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          );
          if (newTask != null) {
            addTask(newTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
