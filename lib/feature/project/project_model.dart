import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
   String? projectId;
   String? adminId;
   String? deadline;
   String? description;
   String? name;
   List<String>? projectTasks;
   List<String>? members;
  double? progress;

  Project({
         this.projectId,
     this.adminId,
     this.deadline,
     this.description,
     this.name,
     this.projectTasks,
     this.members,
     this.progress,
  });
}
//   factory Project.fromJson(Map<String, dynamic> data) {
//     return Project(
//             projectId: data['projectId'] ?? '',
//       adminId: data['adminId'] ?? '',
//       deadline: data['deadline'] ?? '',
//       description: data['description'] ?? '',
//       name: data['name'] ?? '',
//       projectTasks: List<String>.from(data['projectTasks'] ?? []),
//       teamMembers: List<String>.from(data['teamMembers'] ?? []),
//       timestamp: (data['timestamp'] as Timestamp).toDate(), // Assuming timestamp is stored as Firestore Timestamp
//     );
//   }
// }
