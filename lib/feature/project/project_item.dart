import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_app/feature/project/Firebase/firebase_service.dart'; // Import your Firebase service
import 'package:task_app/feature/project/project_model.dart';
import 'package:task_app/feature/task/model/task_model.dart';

class ProjectItem extends StatefulWidget {
  final String projectId;

  const ProjectItem({Key? key, required this.projectId}) : super(key: key);

  @override
  _ProjectItemState createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  late Future<Project> _projectFuture; // Future to hold the project data

  @override
  void initState() {
    super.initState();
    _projectFuture = _fetchProject(widget.projectId); // Fetch project data on initialization
  }

  Future<Project> _fetchProject(String projectId) async {
    return FirebaseService.fetchProject(projectId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Project>(
      future: _projectFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('Project not found');
        } else {
          Project project = snapshot.data!;
          return _buildProjectItem(project);
        }
      },
    );
  }

  Widget _buildProjectItem(Project project) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      width: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: project.teamMembers.take(3).map((member) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(member),
                      radius: 16,
                    ),
                  );
                }).toList()
                  ..addAll(project.teamMembers.length > 3
                      ? [
                          Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 16,
                              child: Text(
                                '+${project.teamMembers.length - 3}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: Colors.grey,
                            ),
                          )
                        ]
                      : []),
              ),
            ],
          ),
          const SizedBox(width: 8.0),
          FutureBuilder<double>(
            future: _getCompletionPercentage(project),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                double percentage = snapshot.data ?? 0.0;
                return CircularPercentIndicator(
                  radius: 40.0, // Adjusted radius
                  lineWidth: 8.0,
                  percent: percentage,
                  center: Text('${(percentage * 100).toStringAsFixed(0)}%'),
                  progressColor: Colors.blue,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<double> _getCompletionPercentage(Project project) async {
    List<TaskModel> tasks = await FirebaseService.fetchTasks(project.projectTasks);
    if (tasks.isEmpty) {
      return 0.0;
    }
    int completedTasks = tasks.where((task) => task.isDone).length;
    return completedTasks / tasks.length;
  }
}


class ProjectListView extends StatelessWidget {
  final List<Project> projects; // List of Project objects

  const ProjectListView({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return ProjectItem(projectId: projects[index].projectId);
        },
      ),
    );
  }
}

