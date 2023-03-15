import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_demo/models/task_model.dart';
import 'data/local_storage.dart';
import 'home_page.dart';

final locator = GetIt.instance;
void setup() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskAdapter());
  }
  // Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>("tasks");
  for (var task in taskBox.values) {
    if (task.createdAt.day != DateTime.now().day) {
      taskBox.delete(task.id);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  await setupHive();
  setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final int = 2;
  // This widget is  the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black54)),
      ),
      home: const HomePage(),
    );
  }
}
