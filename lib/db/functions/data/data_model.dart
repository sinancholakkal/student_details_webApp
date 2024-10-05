import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';
part 'data_model.g.dart';

@HiveType(typeId: 0)
class StudentModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String age;
  @HiveField(3)
  final String gName;
  @HiveField(4)
  final String phone;
  @HiveField(5)
  final Uint8List profile;

  StudentModel({
    required this.name,
    required this.age,
    required this.gName,
    required this.phone,
    this.id,
    required this.profile,
  });
}

