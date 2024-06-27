import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/feature/project/project_model.dart';
import 'package:task_app/feature/task/model/task_model.dart';

class FirebaseService {
  //hend
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Fetch project details from Firestore based on projectId
  static Future<Project> fetchProject(String projectId) async {
    try {
      DocumentSnapshot projectDoc = await _firestore.collection('projects').doc(projectId).get();
      if (projectDoc.exists) {
        return Project.fromJson(projectDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Project not found');
      }
    } catch (e) {
      print('Error fetching project: $e');
      rethrow; // Throw the error to handle it further up the call stack
    }
  }
  
static Future<List<TaskModel>> fetchTasks(List<String> taskIds) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<TaskModel> tasks = [];

    for (String taskId in taskIds) {
      DocumentSnapshot taskDoc = await firestore.collection('tasks').doc(taskId).get();
      if (taskDoc.exists) {
        tasks.add(TaskModel.fromMap(taskDoc.data() as Map<String, dynamic>));
      }
    }
    return tasks;
  }
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getProjects() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('projects')
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  Future<void> addProject({
    required String name,
    required String description,
    required String deadline,
    required List<String> projectTasks,
    required List<String> teamMembers,
    required String adminId,
  }) async {
    try {
      String collectionPath = 'projects';
      Map<String, dynamic> projectData = {
        'name': name,
        'description': description,
        'deadline': deadline,
        'projectTasks': projectTasks,
        'teamMembers': teamMembers,
        'adminId': adminId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection(collectionPath).add(projectData);
    } catch (e) {
      print('Error adding project: $e');
      throw e;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getProjectById(String projectId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> projectSnapshot = await _firestore.collection('projects').doc(projectId).get();
      return projectSnapshot;
    } catch (e) {
      print('Error fetching project: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore.collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        return userSnapshot.docs.first.data();
      } else {
        print('User with email $email not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  Future<String> getAdminNameById(String adminId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> adminSnapshot = await _firestore.collection('users').doc(adminId).get();
      if (adminSnapshot.exists) {
        return adminSnapshot.data()?['username'] ?? 'ملقاش';
      } else {
        return 'لقي ';
      }
    } catch (e) {
      print('Error fetching admin name: $e');
      return 'نت';
    }
  }

  Future<void> addTaskToProject(String projectId, String title, String member) async {
    try {
      await _firestore.collection('projects').doc(projectId).collection('tasks').add({
        'title': title,
        'member': member,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding task to project: $e');
      throw e;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTasksByProjectId(String projectId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> taskSnapshot = await _firestore.collection('projects').doc(projectId).collection('tasks').get();
      return taskSnapshot;
    } catch (e) {
      print('Error fetching tasks: $e');
      rethrow;
    }
  }


}
