import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_detiails/db/functions/data/data_model.dart';

ValueNotifier<List<StudentModel>> studentModelListNotifier = ValueNotifier([]);

late Database db;


Future<void> initializeData() async {
  db = await openDatabase(
    'student.db',
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE student(id INTEGER PRIMARY KEY, name TEXT, age TEXT, gName TEXT, phone TEXT, profilePath TEXT)',
      );
    },
  );
}



Future<void> addStudent(StudentModel val) async {
  await db.rawInsert(
    'INSERT INTO student (name, age, gName, phone, profilePath) VALUES (?,?,?,?,?)',
    [val.name, val.age, val.gName, val.phone, val.profilePath],
  );
  await getAllStudent();
}

Future<void>deleteStudent(int id)async{
  await db.rawDelete('DELETE FROM student WHERE id = ?',[id]);
  await getAllStudent();
}

Future<void> getAllStudent() async {
  studentModelListNotifier.value.clear();
  final values = await db.rawQuery('SELECT * FROM student');
  for (var map in values) {
    final student = StudentModel.fromMap(map);
    studentModelListNotifier.value.add(student);
  }
  studentModelListNotifier.notifyListeners();
}

Future<void> update(int id, String newName,String newAge,String newgName,String newPhone, String newProfilePath) async {
  await db.rawUpdate(
    'UPDATE student SET name = ?, age = ?, gName = ?, phone = ?, profilePath = ? WHERE id = ?',
    [newName,newAge,newgName,newPhone, newProfilePath, id],
  );
  getAllStudent();
}
