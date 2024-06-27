import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String projectId;
  final String adminId;
  final String deadline;
  final String description;
  final String name;
  final List<String> projectTasks;
  final List<String> teamMembers;
  final DateTime timestamp;

  Project({
        required this.projectId,
    required this.adminId,
    required this.deadline,
    required this.description,
    required this.name,
    required this.projectTasks,
    required this.teamMembers,
    required this.timestamp,
  });

  factory Project.fromJson(Map<String, dynamic> data) {
    return Project(
            projectId: data['projectId'] ?? '',
      adminId: data['adminId'] ?? '',
      deadline: data['deadline'] ?? '',
      description: data['description'] ?? '',
      name: data['name'] ?? '',
      projectTasks: List<String>.from(data['projectTasks'] ?? []),
      teamMembers: List<String>.from(data['teamMembers'] ?? []),
      timestamp: (data['timestamp'] as Timestamp).toDate(), // Assuming timestamp is stored as Firestore Timestamp
    );
  }
}
