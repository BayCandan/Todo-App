import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_demo/data/local_storage.dart';
import 'package:todo_app_demo/main.dart';
import 'package:todo_app_demo/models/task_model.dart';
import 'package:todo_app_demo/widgets.dart/custom_search_delegate.dart';
import 'package:todo_app_demo/widgets.dart/task_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage= locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: const Text(
            "Bugun Neler Yapacaksin",
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
_showSearchPage();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet();
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: _allTasks.length,
              itemBuilder: (context, index) {
                var _oankiListeElemani = _allTasks[index];
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
                  onDismissed: (direction){
                    _allTasks.removeAt(index);
                    _localStorage.deleteTask(task: _oankiListeElemani);
                    setState(() {});
                  },
                  child: TaskItem(task: _oankiListeElemani,)
                );
              },
            )
          : Center(
              child: Text(
                "Hadi Gorev Ekle",
              ),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              style: const TextStyle(fontSize: 24),
              keyboardType: TextInputType.multiline,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Gorev Nedir ?",
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(context, showSecondsColumn: false,
                      onConfirm: (time) async {
                    var yeniEklenecekGorev =
                        Task.create(name: value, createdAt: time);

                    _allTasks.insert(0,yeniEklenecekGorev);
                    await _localStorage.addTask(task: yeniEklenecekGorev);
                    setState(() {});
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }
  void _getAllTaskFromDb() async {
    _allTasks =  await _localStorage.getAllTask();
    setState(() {
      
    });
  }
  
  void _showSearchPage() async{
   await showSearch(context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
   _getAllTaskFromDb();
  }
}
