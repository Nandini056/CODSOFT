import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onDelete;

  TaskTile({
    required this.task,
    this.onTap,
    this.onCheckboxChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(task.description ?? ''),
      trailing: Wrap(
        spacing: 12, 
        children: <Widget>[
          Checkbox(
            value: task.isCompleted,
            onChanged: onCheckboxChanged,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
