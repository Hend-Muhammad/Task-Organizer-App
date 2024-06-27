import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? docID;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String dueDate;
  final String dueTime;
  final bool isDone;
  final String status;
  final String priority;
  final String tag;
  final String? reminderDateTime; // New field for reminder

  TaskModel({
    this.docID,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.dueDate,
    required this.dueTime,
    required this.isDone,
    required this.status,
    required this.priority,
    required this.tag,
    this.reminderDateTime, // New field for reminder
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      docID: doc.id,
      userId: data['userId'] ?? '',
      title: data['titleTask'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      dueDate: data['dateTask'] ?? '',
      dueTime: data['timeTask'] ?? '',
      status: data['status'] ?? '',
      isDone: data['isDone'] ?? false,
      priority: data['priority'] ?? '',
      tag: data['tag'] ?? '',
      reminderDateTime: data['reminderDateTime'], // New field for reminder
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docID': docID,
      'userId': userId,
      'titleTask': title,
      'description': description,
      'category': category,
      'dateTask': dueDate,
      'timeTask': dueTime,
      'status': status,
      'isDone': isDone,
      'priority': priority,
      'tag': tag,
      'reminderDateTime': reminderDateTime, // New field for reminder
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      docID: map['docID'] != null ? map['docID'] as String : null,
      userId: map['userId'] as String,
      title: map['titleTask'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      dueDate: map['dateTask'] as String,
      dueTime: map['timeTask'] as String,
      isDone: map['isDone'] as bool,
      status: map['status'] as String,
      priority: map['priority'] as String,
      tag: map['tag'] as String,
      reminderDateTime: map['reminderDateTime'] as String?, // New field for reminder
    );
  }
}
