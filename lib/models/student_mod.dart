// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

StudentModel studentModelFromJson(String str) => StudentModel.fromJson(json.decode(str));

String studentModelToJson(StudentModel data) => json.encode(data.toJson());

class StudentModel {
  StudentModel({
    this.id,
    this.name,
    this.subject,
  });

  int? id;
  String? name;
  String? subject;

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
    id: json["id"],
    name: json["name"],
    subject: json["subject"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "subject": subject,
  };
}
