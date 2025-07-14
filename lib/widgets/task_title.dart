import 'package:flutter/material.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/models/task_status.dart';
import 'package:task_management_system/utils/theme/borders.dart';
import 'package:task_management_system/utils/theme/padding.dart';
import 'package:task_management_system/utils/text/text_style.dart';
import 'package:task_management_system/utils/theme/gaps.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final Function(TaskStatus?) onStatusChanged;
  final VoidCallback onTap;
  final VoidCallback? onCardTap;
  final bool forceChecked;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onStatusChanged,
    required this.onTap,
    this.onCardTap,
    this.forceChecked = false,
  }) : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> with SingleTickerProviderStateMixin {
  late AnimationController _checkController;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant TaskTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate the checkbox based on status
    if (widget.task.status == TaskStatus.completed) {
      _checkController.forward();
    } else {
      _checkController.reverse();
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: ThemeBorderRadius.r2,
      ),
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      margin: ThemePadding.p2,
      child: Row(
        children: [
          // Checkbox area
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: (widget.task.status == TaskStatus.completed) ||
                  widget.forceChecked,
              onChanged: (checked) async {
                if (checked == true &&
                    widget.task.status != TaskStatus.completed) {
                  widget.onStatusChanged(TaskStatus.completed);
                } else if (checked == false &&
                    widget.task.status == TaskStatus.completed) {
                  _handleUndoComplete(context);
                }
              },
              activeColor: Theme
                  .of(context)
                  .colorScheme
                  .primary,
            ),
          ),
          Gap.x2,
          // Body area (tappable for details)
          Expanded(
            child: InkWell(
              borderRadius: ThemeBorderRadius.r2,
              onTap: widget.onCardTap,
              child: Padding(
                padding: ThemePadding.p3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.task.title,
                            style: (widget.task.status == TaskStatus.completed)
                                ? ThemeTextStyles.bodyMedium.copyWith(
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.54),
                            )
                                : ThemeTextStyles.bodyMedium.copyWith(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        StatusPill(
                          widget.task.status,
                          onTap: (newStatus) {
                            if (newStatus != widget.task.status) {
                              widget.onStatusChanged(newStatus);
                            }
                          },
                        ),
                      ],
                    ),
                    if (widget.task.description.isNotEmpty) ...[
                      Gap.y1,
                      Text(
                        widget.task.description,
                        style: (widget.task.status == TaskStatus.completed)
                            ? ThemeTextStyles.bodySmall.copyWith(
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 2,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                              )
                            : ThemeTextStyles.bodySmall.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                              ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleUndoComplete(BuildContext context) async {
    final choices = TaskStatus.values
        .where((s) => s != TaskStatus.completed)
        .toList();
    TaskStatus picked = choices.first;
    TaskStatus? selectedStatus;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .surface,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose new status',
                  style: ThemeTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold)),
              Gap.y2,
              SizedBox(
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: choices.map((status) =>
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ChoiceChip(
                          label: Text(status.displayName),
                          selected: picked == status,
                          backgroundColor: status.color.withOpacity(0.13),
                          selectedColor: status.color.withOpacity(0.27),
                          labelStyle: ThemeTextStyles.bodySmall.copyWith(
                            color: status.color,
                            fontWeight: picked == status
                                ? FontWeight.bold
                                : FontWeight.w500,
                      ),
                      avatar: CircleAvatar(
                          backgroundColor: status.color, radius: 8),
                      shape: StadiumBorder(side: BorderSide(
                          color: status.color.withOpacity(0.42))),
                      onSelected: (selected) {
                        selectedStatus = status;
                        Navigator.of(context).pop();
                      },
                    ),
                  )).toList(),
                ),
              ),
              Gap.y4,
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
    if (selectedStatus != null) {
      widget.onStatusChanged(selectedStatus);
    }
  }

  void _showChangeStatusDialog(BuildContext context) async {
    final choices = TaskStatus.values
        .where((s) => s != widget.task.status)
        .toList();
    TaskStatus picked = choices.first;
    TaskStatus? selectedStatus;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .surface,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Task Status',
                style: ThemeTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              Gap.y2,
              SizedBox(
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: choices.map((status) =>
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(status.displayName),
                      selected: picked == status,
                      backgroundColor: status.color.withOpacity(0.13),
                      selectedColor: status.color.withOpacity(0.27),
                      labelStyle: ThemeTextStyles.bodySmall.copyWith(
                        color: status.color,
                        fontWeight: picked == status
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                      avatar: CircleAvatar(
                          backgroundColor: status.color, radius: 8),
                      shape: StadiumBorder(side: BorderSide(
                          color: status.color.withOpacity(0.42))),
                      onSelected: (selected) {
                        selectedStatus = status;
                        Navigator.of(context).pop();
                      },
                    ),
                  )).toList(),
                ),
              ),
              Gap.y4,
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
    if (selectedStatus != null && selectedStatus != widget.task.status) {
      widget.onStatusChanged(selectedStatus);
    }
  }
}

class StatusPill extends StatelessWidget {
  final TaskStatus status;
  final void Function(TaskStatus)? onTap;

  const StatusPill(this.status, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () async {
        final choices = TaskStatus.values
            .where((s) => s != status)
            .toList();
        TaskStatus? picked;
        await showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .surface,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Current Status: ${status.displayName}',
                            style: ThemeTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold)),
                        Gap.y2,
                        Text('Tap a status to change',
                            style: ThemeTextStyles.bodySmall),
                        Gap.y4,
                        SizedBox(
                          height: 46,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: choices.map((s) =>
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: ChoiceChip(
                                    label: Text(s.displayName),
                                    selected: false,
                                    backgroundColor: s.color.withOpacity(0.13),
                                    selectedColor: s.color.withOpacity(0.24),
                                    labelStyle: ThemeTextStyles.bodySmall
                                        .copyWith(
                                      color: s.color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    avatar: CircleAvatar(
                                        backgroundColor: s.color, radius: 8),
                                    shape: StadiumBorder(side: BorderSide(
                                        color: s.color.withOpacity(0.42))),
                                    onSelected: (selected) {
                                      picked = s;
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )).toList(),
                          ),
                        ),
                        Gap.y4,
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                  );
                },
              );
              if (picked != null && onTap != null) {
                onTap!(picked!);
              }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        margin: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          color: status.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: status.color, width: 1.1),
        ),
        child: Text(
          status.displayName,
          style: ThemeTextStyles.bodySmall.copyWith(
            color: status.color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
