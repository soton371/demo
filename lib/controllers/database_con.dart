import 'dart:io';
import 'package:demo/models/student_mod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DataBaseController{
  DataBaseController._private();
  static final DataBaseController instance = DataBaseController._private();

  Database? database;
  Future<Database> get getDatabase async => database ??= await initDatabase();

  Future<Database> initDatabase()async{
    Directory supportDirectory = await getApplicationSupportDirectory();
    String path = join(supportDirectory.path,'students.db');

    return await openDatabase(path,version: 1,onCreate: onCreate,);
  }

  Future onCreate(Database db, int version)async{
    await db.execute("""
    CREATE TABLE students(
    id INTEGER PRIMARY KEY,
    name TEXT,
    subject TEXT
    )
    """);
  }

  Future<int> addData(StudentModel studentModel)async{
    Database db = await instance.getDatabase;
    return await db.insert('students', studentModel.toJson());
  }

  Future<List<StudentModel>> getData()async{
    Database db = await instance.getDatabase;
    var std = await db.query('students',orderBy: 'id');

    List<StudentModel> getStudents = std.isNotEmpty? std.map((e) => StudentModel.fromJson(e)).toList():[];
    return getStudents;
  }

  Future deleteData(int id)async{
    Database db = await instance.getDatabase;
    return await db.delete('students',where: 'id=?',whereArgs: [id]);
  }

  Future updateData(StudentModel studentModel)async{
    Database db = await instance.getDatabase;
    return await db.update('students', studentModel.toJson(), where: 'id=?', whereArgs: [studentModel.id]);
  }

}