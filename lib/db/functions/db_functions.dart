// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:student_detiails/db/functions/data/data_model.dart';

 import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_detiails/db/functions/data/data_model.dart';

ValueNotifier<List<StudentModel>> studentModelListNotifier = ValueNotifier([]);

Future<void> addStudent(StudentModel student)async{
  final db =await Hive.openBox<StudentModel>('student_db');
  final key = await  db.add(student);
  student.id =key;
  await db.put(key, student);
  studentModelListNotifier.value.add(student);
  studentModelListNotifier.notifyListeners();
}

Future<void> getAllStudent()async{
  final db = await Hive.openBox<StudentModel>("student_db");
  studentModelListNotifier.value.clear();
  studentModelListNotifier.value.addAll(db.values);
  studentModelListNotifier.notifyListeners();
}

Future<void> deleteStudent(id)async{
  final db = await Hive.openBox<StudentModel>("student_db");
  await db.delete(id);
  getAllStudent();
}
Future<void>deleteMultiItem(List<int> ids)async{
    final db = await Hive.openBox<StudentModel>("student_db");
  for(int i = 0;i<ids.length;i++){
    await db.delete(ids[i]);
  }
  getAllStudent();
}

Future<void>updateStudent(StudentModel updatedStudent)async{
  final db = await Hive.openBox<StudentModel>("student_db");
  await db.put(updatedStudent.id, updatedStudent);
  getAllStudent();
}