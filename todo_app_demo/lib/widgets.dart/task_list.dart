import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_demo/data/local_storage.dart';
import 'package:todo_app_demo/main.dart';

import '../models/task_model.dart';

class TaskItem extends StatefulWidget {
  Task task;
  TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
  
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
    // _taskNameController.text = widget.task.name;

  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10)
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.green, width: 0.8),
                shape: BoxShape.circle),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                controller: _taskNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onSubmitted: (yeniDeger) {
                  if (yeniDeger.length > 3) {
                    widget.task.name = yeniDeger;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
                
              ),
              trailing: Text(
                DateFormat("hh:mm a").format(widget.task.createdAt),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              
      ),
    );
  }
}