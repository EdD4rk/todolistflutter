import 'dart:io';
import 'package:flutter_codigo_taskdb/models/task_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBAdmin {
  Database? myDatabase;

  //Singleton
  static final DBAdmin db = DBAdmin._();
  DBAdmin._();
  //

  Future<Database?> checkDatabase() async {
    if (myDatabase != null) {
      return myDatabase;
    }
    myDatabase = await initDatabase();
    return myDatabase;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "TaskDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database dbx, int version) async {
      //CREAR LA TABLA CORRESPONDIENTE
      await dbx.execute(
          "CREATE TABLE TASK(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, status TEXT)");
    });
  }

  Future<int> insertRawTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.rawInsert(
        "INSERT INTO TASK(title, description, status) VALUES ('${model.title}','${model.description}','${model.status.toString()}')");
    return res;
  }

  Future<int> insertTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.insert(
      "TASK",
      {
        "title": model.title,
        "description": model.description,
        "status": model.status,
      },
    );
    return res;
  }



  getRawTasks() async {
    Database? db = await checkDatabase();
    List tasks = await db!.rawQuery("SELECT * FROM Task");
    print(tasks[0]);
  }

  Future<List<TaskModel>> getTasks() async {
    Database? db = await checkDatabase();
    List<Map<String, dynamic>> tasks = await db!.query("Task");
    List<TaskModel> taskModelList = tasks.map((e) => TaskModel.deMapAModel(e)).toList();

    // tasks.forEach((element) {
    //   TaskModel task = TaskModel.deMapAModel(element);
    //   taskModelList.add(task);
    // });
    return taskModelList;
  }



  updateRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawUpdate(
        "UPDATE TASK SET title = 'Ir de compras',  description = 'Comprar comida', status = 'true' WHERE id = 2");
    print(res);
  }

  Future<int> updateTask(TaskModel taskModel) async {
    Database? db = await checkDatabase();
    int res = await db!.update(
      "TASK",
      {
        "title": taskModel.title,
        "description": taskModel.description,
        "status" : taskModel.status
      },
      where: "id = ${taskModel.id}"
    );
    return res;
  }

  deleteRawTask() async{
    Database? db = await checkDatabase();
    int res = await db!.rawDelete("DELETE FROM TASK WHERE id = 2");
    print(res);
  }

  Future<int> deleteTask(int id) async{
    Database? db = await checkDatabase();
    int res = await db!.delete("TASK", where: "id = $id");
    return res;
  }



}
