import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/task_status.dart';
import '../providers/task_provider.dart';
import '../utils/theme/colors/color.dart';
import '../utils/text/text_style.dart';
import '../utils/theme/padding.dart';
import '../utils/theme/gaps.dart';
import '../utils/theme/borders.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskStatus _selectedStatus;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _selectedStatus = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: Padding(
        padding: ThemePadding.p4,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                style: ThemeTextStyles.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'Enter task title',
                  prefixIcon: Icon(
                    Icons.title,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
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
                  Text('Status:', style: ThemeTextStyles.bodyMedium),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: TaskStatus.values
                            .map((status) =>
                            Padding(
                              padding: EdgeInsets.only(right: Gap.value),
                              child: ChoiceChip(
                                label: Text(status.displayName),
                                selected: _selectedStatus == status,
                                backgroundColor: status.color.withOpacity(0.12),
                                selectedColor: status.color.withOpacity(0.3),
                                labelStyle: ThemeTextStyles.bodySmall.copyWith(
                                  color: status.color,
                                  fontWeight: _selectedStatus == status
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: ThemeBorderRadius.r2,
                                    side: BorderSide(
                                      color: status.color.withOpacity(
                                          _selectedStatus == status
                                              ? 0.8
                                              : 0.35),
                                    ),
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
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: ThemeBorderRadius.r2,
                  ),
                ),
              ),
              Gap.y4,
              ElevatedButton.icon(
                icon: _isSubmitting
                    ? SizedBox(
                    width: Gap.value * 2, height: Gap.value * 2,
                    child: const CircularProgressIndicator(strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white)))
                    : const Icon(Icons.save),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:Theme.of(context).colorScheme.primary,
                  foregroundColor: ThemeColor.white
                ),
                onPressed: _isSubmitting ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    final updatedTask = widget.task.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _selectedStatus,
    );
    final result = await Provider.of<TaskProvider>(context, listen: false)
        .updateTask(updatedTask);
    if (result && mounted) {
      Navigator.pop(context, updatedTask);
    }
    setState(() => _isSubmitting = false);
  }
}
