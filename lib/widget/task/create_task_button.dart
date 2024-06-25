import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/model/task_model.dart';
import 'package:task_app/provider/date_time_provider.dart';
import 'package:task_app/provider/radio_provider.dart';
import 'package:task_app/provider/service_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class CreateTaskButton extends StatelessWidget {
  const CreateTaskButton({
    Key? key,
    required this.ref,
    required this.userId,
    required this.titleController,
    required this.descriptionController,
    required this.status,
    required this.priority,
    required this.tag,
    required this.reminderDateTime,
  }) : super(key: key);

  final WidgetRef ref;
  final String userId;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String status;
  final String priority;
  final String tag;
  final DateTime? reminderDateTime;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff8145E5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () async {
          final getRadioValue = ref.read(radioProvider);
          String category = '';

          switch (getRadioValue) {
            case 1:
              category = 'Learning';
              break;
            case 2:
              category = 'Working';
              break;
            case 3:
              category = 'General';
              break;
          }

          // Use userId parameter here
          TaskModel newTask = TaskModel(
            userId: userId,
            title: titleController.text,
            description: descriptionController.text,
            category: category,
            dueDate: ref.read(dateProvider),
            dueTime: ref.read(timeProvider),
            isDone: false,
            status: status,
            priority: priority,
            tag: tag,
          );

          await ref.read(serviceProvider).addNewTask(newTask);

          // Schedule reminder notification if reminderDateTime is set
          if (reminderDateTime != null) {
            await scheduleNotification(newTask);
          }

          titleController.clear();
          descriptionController.clear();
          ref.read(radioProvider.notifier).update((state) => 0);
          Navigator.pop(context);
        },
        child: const Text(
          'Create',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Future<void> scheduleNotification(TaskModel task) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Initialize timezone data
    tz.initializeTimeZones();

    // Convert reminderDateTime to the local timezone
    tz.TZDateTime scheduledTime = tz.TZDateTime.from(
      reminderDateTime!,
      tz.local,
    );

    // Example notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Change this to your channel id
      'your_channel_name', // Change this to your channel name
      channelDescription:
          'your_channel_description', // Change this to your channel description
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the notification within a time window
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.hashCode,
      'Reminder: ${task.title}',
      'Reminder for ${task.title}',
      scheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
