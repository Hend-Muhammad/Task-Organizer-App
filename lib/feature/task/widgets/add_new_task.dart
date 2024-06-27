import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/constants/app_style.dart';
import 'package:task_app/feature/task/widgets/category_selection.dart';
import 'package:task_app/feature/task/widgets/create_task_button.dart';
import 'package:task_app/feature/task/widgets/date_time_row.dart';
import 'package:task_app/feature/task/widgets/priority_selection_button.dart';
import 'package:task_app/feature/task/widgets/progress_selector.dart';
import 'package:task_app/feature/task/widgets/recurring_task.dart';
import 'package:task_app/feature/task/widgets/subtask_section.dart';
import 'package:task_app/feature/task/widgets/textfield_widget.dart';

class AddNewTaskSheet extends ConsumerStatefulWidget {
  final String userId;

  const AddNewTaskSheet({Key? key, required this.userId}) : super(key: key);

  @override
  AddNewTaskSheetState createState() => AddNewTaskSheetState();
}

class AddNewTaskSheetState extends ConsumerState<AddNewTaskSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedPriority = 'No Priority';
  String selectedProgress = 'TO DO';
  List<TextEditingController> subtaskControllers = [];
  late TaskProgressSelector taskProgressSelector;
  late String selectedRecurring = 'No Recurring';
  String tag = 'NO TAG';
  DateTime? reminderDateTime;

  @override
  void initState() {
    super.initState();
    taskProgressSelector = TaskProgressSelector(
      defaultProgress: selectedProgress,
      onProgressChanged: (progress) {
        setState(() {
          selectedProgress = progress;
          taskProgressSelector.updateProgressIndicator(context);
        });
      },
    );
    taskProgressSelector.updateProgressIndicator(context);
  }

  void _updateRecurring(String? value) {
    if (value != null) {
      setState(() {
        selectedRecurring = value;
      });
    }
  }

  Future<void> _selectReminderDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          reminderDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Task Todo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: const BoxDecoration(
            color: Color(0xff1C1C1C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 1.2, color: Colors.grey),
              const Gap(12),
              const Text(
                'Title Task',
                style: AppStyle.headingOne,
              ),
              const Gap(6),
              TextFieldWidget(
                hintText: 'Add Task Name',
                txtController: titleController,
              ),
              const Gap(12),
              const Text('Description', style: AppStyle.headingOne),
              const Gap(6),
              TextFieldWidget(
                hintText: 'Add Descriptions',
                txtController: descriptionController,
              ),
              const Gap(12),
              taskProgressSelector.progressIndicator,
              const Gap(12),
              CategorySelection(ref: ref),
              DateTimeRow(ref: ref),
              const Gap(12),
              PrioritySelectionButton(
                selectedPriority: selectedPriority,
                onPrioritySelected: (priority) {
                  setState(() {
                    selectedPriority = priority;
                  });
                },
              ),
              const Gap(12),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TaskOptionsDialog(
                        selectedRecurring: selectedRecurring,
                        skipWeekends: false,
                        daysAfter: 0,
                        onRecurringChanged: _updateRecurring,
                        onSkipWeekendsChanged: (value) {
                          // Handle skip weekends option change
                        },
                        onDaysAfterChanged: (value) {
                          // Handle days after option change
                        },
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.repeat, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      selectedRecurring,
                      style: AppStyle.headingOne,
                    ),
                  ],
                ),
              ),
              const Gap(12),
              SubtaskSection(subtaskControllers: subtaskControllers),
              const Gap(12),
              Row(
                children: [
                  const Icon(Icons.alarm, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    reminderDateTime != null
                        ? DateFormat('yyyy-MM-dd – kk:mm').format(reminderDateTime!)
                        : 'Set Reminder',
                    style: AppStyle.headingOne,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _selectReminderDateTime(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CreateTaskButton(
            ref: ref,
            userId: widget.userId,
            titleController: titleController,
            descriptionController: descriptionController,
            status: selectedProgress,
            priority: selectedPriority,
            tag: tag,
            reminderDateTime: reminderDateTime,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
