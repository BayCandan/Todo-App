import 'package:flutter/material.dart';
import 'package:todo_app_demo/data/local_storage.dart';
import 'package:todo_app_demo/main.dart';

import '../models/task_model.dart';
import 'task_list.dart';

class CustomSearchDelegate extends SearchDelegate {

  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.black54,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks.where((gorev) => gorev.name.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.length >0 ? ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                var _oankiListeElemani = filteredList[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const[
                      Icon( 
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8,),
                      Text("BU Gorev Silindi"),
                    ],
                  ),
                  key: Key(_oankiListeElemani.id),
                  onDismissed: (direction)async{
                    filteredList.removeAt(index);
                    await locator<LocalStorage>().deleteTask(task: _oankiListeElemani);
                    
                  },
                  child: TaskItem(task: _oankiListeElemani,)
                );
              },
            )
          : Center(
              child: Text(
                "Aradginizi Bulamadik",
              ),
            );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
