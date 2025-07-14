import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_status.dart';
import '../utils/theme/colors/color.dart';
import '../utils/theme/padding.dart';
import '../utils/text/text_style.dart';
import '../utils/theme/gaps.dart';
import '../utils/theme/borders.dart';
import '../animations/slide_up_widget.dart';
import '../animations/fade_in_widget.dart';
import '../animations/scale_tap_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  TaskStatus _selectedStatus = TaskStatus.working;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Create New Task',
                style: ThemeTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Icon(
                      Icons.task_alt,
                      size: 200,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: ThemePadding.p4,
              child: SlideUpWidget(
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: ThemeBorderRadius.r3,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                  child: Padding(
                    padding: ThemePadding.p4,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _titleController,
                            style: ThemeTextStyles.bodyMedium,
                            decoration: InputDecoration(
                              labelText: 'Task Title',
                              hintText: 'Enter task title',
                              prefixIcon: Icon(
                                Icons.title,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: ThemeBorderRadius.r2,
                              ),
                            ),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Please enter a title' : null,
                          ),
                          Gap.y2,
                          Row(
                            children: [
                              Text(
                                'Status:',
                                style: ThemeTextStyles.bodyMedium,
                              ),
                              Gap.x2,
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: TaskStatus.values
                                        .map((status) =>
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: Gap.value),
                                          child: ChoiceChip(
                                            label: Text(status.displayName),
                                            selected: _selectedStatus == status,
                                            backgroundColor: status.color
                                                .withOpacity(0.12),
                                            selectedColor: status.color
                                                .withOpacity(0.3),
                                            labelStyle: ThemeTextStyles
                                                .bodySmall.copyWith(
                                              color: status.color,
                                              fontWeight: _selectedStatus ==
                                                  status
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: ThemeBorderRadius
                                                  .r2,
                                              side: BorderSide(
                                                  color: status.color
                                                      .withOpacity(
                                                      _selectedStatus == status
                                                          ? 0.8
                                                          : 0.35)),
                                            ),
                                            onSelected: (selected) {
                                              setState(() {
                                                _selectedStatus = status;
                                              });
                                            },
                                          ),
                                        ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap.y4,
                          TextFormField(
                            controller: _descriptionController,
                            style: ThemeTextStyles.bodyMedium,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              hintText: 'Enter task description (optional)',
                              alignLabelWithHint: true,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.10),
                                child: Icon(
                                  Icons.description,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: ThemeBorderRadius.r2,
                              ),
                            ),
                          ),
                          Gap.y4,
                          ScaleTapWidget(
                            onTap: _isSubmitting ? null : _submitTask,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.primaryContainer,
                                  ],
                                ),
                                borderRadius: ThemeBorderRadius.r2,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _isSubmitting
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Create Task',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      try {
        final success = await context.read<TaskProvider>().createTask(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          status: _selectedStatus,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success ? 'Task created successfully' : 'Failed to create task',
                style: ThemeTextStyles.bodyMedium.copyWith(
                  color: ThemeColor.white,
                ),
              ),
              backgroundColor: success ? ThemeColor.primary : Colors.red,
            ),
          );

          if (success) {
            Navigator.pop(context);
          }
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }
}
