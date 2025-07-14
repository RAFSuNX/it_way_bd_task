import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/task_provider.dart';
import 'package:task_management_system/widgets/error_widget.dart';
import 'package:task_management_system/utils/theme/colors/color.dart';
import 'package:task_management_system/utils/theme/padding.dart';
import 'package:task_management_system/utils/text/text_style.dart';
import 'package:task_management_system/utils/theme/gaps.dart';
import '../models/task.dart';
import '../models/task_status.dart';
import '../utils/theme/borders.dart';
import '../animations/fade_in_widget.dart';
import '../animations/scale_tap_widget.dart';
import '../providers/theme_provider.dart';
import '../providers/background_provider.dart';
import 'add_task_screen.dart';
import 'background_selection_screen.dart';
import 'edit_task_screen.dart'; // new import for EditTaskScreen

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      provider.loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Consumer<BackgroundProvider>(
      builder: (context, bgProvider, _) {
        return Container(
          decoration: bgProvider.selectedBackground != null
              ? (() {
            print('Using background image: ${bgProvider.selectedBackground}');
            return BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgProvider.selectedBackground!),
                fit: BoxFit.cover,
              ),
            );
          })()
              : (() {
            print('Using background color');
            return BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .background,
            );
          })(),
          child: DefaultTabController(
            length: 5,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                title: Text(
                  'Task Manager',
                  style: ThemeTextStyles.h2.copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.wallpaper),
                    tooltip: 'Change Background',
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (
                              context) => const BackgroundSelectionScreen(),
                        ),
                      );
                      Provider
                          .of<BackgroundProvider>(context, listen: false)
                          .setBackground(result);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Background saved!')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onPrimary,
                    ),
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: Gap.value * 2),
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                  unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4, color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary),
                    insets: EdgeInsets.symmetric(horizontal: 24),
                  ),
                  indicatorColor: Theme
                      .of(context)
                      .colorScheme
                      .onPrimary,
                  labelColor: Theme
                      .of(context)
                      .colorScheme
                      .onPrimary,
                  unselectedLabelColor:
                  Theme
                      .of(context)
                      .colorScheme
                      .onPrimary
                      .withOpacity(0.5),
                  tabs: const [
                    Tab(text: "All"),
                    Tab(text: "Working"),
                    Tab(text: "Pending"),
                    Tab(text: "Due"),
                    Tab(text: "Completed"),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        Gap.value * 2, Gap.value * 1.75, Gap.value * 2,
                        Gap.value * 0.75),
                    child: Material(
                      elevation: 2,
                      borderRadius: ThemeBorderRadius.r6,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .surface,
                      child: TextField(
                        controller: _searchController,
                        style: ThemeTextStyles.bodyMedium,
                        cursorColor: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? ThemeColor.white
                            : ThemeColor.lightPrimary,
                        decoration: InputDecoration(
                          hintText: 'Search Tasks...',
                          prefixIcon: Icon(Icons.search, color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? ThemeColor.white
                              : ThemeColor.lightPrimary,),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: Gap.value * 2),
                        ),
                        onChanged: (query) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _StatusTasksList(
                            status: null, searchQuery: _searchQuery),
                        _StatusTasksList(status: TaskStatus.working,
                            searchQuery: _searchQuery),
                        _StatusTasksList(status: TaskStatus.pending,
                            searchQuery: _searchQuery),
                        _StatusTasksList(
                            status: TaskStatus.due, searchQuery: _searchQuery),
                        _StatusTasksList(status: TaskStatus.completed,
                            searchQuery: _searchQuery),
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: ScaleTapWidget(
                onTap: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddTaskScreen()),
                    ),
                child: FloatingActionButton(
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  onPressed: null,
                  child: const Icon(Icons.add, color: ThemeColor.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Task',
          style: ThemeTextStyles.h3,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Task Title',
                hintStyle: ThemeTextStyles.bodyMedium.copyWith(
                  color: ThemeColor.black54,
                ),
              ),
            ),
            Gap.y2,
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Task Description',
                hintStyle: ThemeTextStyles.bodyMedium.copyWith(
                  color: ThemeColor.black54,
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: ThemeTextStyles.bodyMedium.copyWith(
                color: ThemeColor.black54,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Add',
              style: ThemeTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();

      if (title.isNotEmpty) {
        final success = await context.read<TaskProvider>().createTask(
          title: title,
          description: description,
          status: TaskStatus.working,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success ? 'Task added successfully' : 'Failed to add task',
                style: ThemeTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              backgroundColor: success ? Theme.of(context).colorScheme.primary : Colors.red,
            ),
          );
        }
      }
    }

    titleController.dispose();
    descriptionController.dispose();
  }

  void _showTaskDetails(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeBorderRadius.r2,
      ),
      builder: (context) => Padding(
        padding: ThemePadding.p4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                StatusPill(
                  status: task.status,
                  onTap: (newStatus) async {
                    if (newStatus != null && newStatus != task.status) {
                      Navigator.pop(context); // Dismiss sheet
                      await Provider
                          .of<TaskProvider>(context, listen: false)
                          .updateTaskStatus(task, newStatus);
                    }
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.title,
                    style: ThemeTextStyles.h3,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Gap.y2,
            if (task.description.isNotEmpty)
              Text(
                task.description,
                style: ThemeTextStyles.bodyMedium.copyWith(
                  color: ThemeColor.black54,
                ),
              ),
            if (task.description.isEmpty)
              Text(
                'No description',
                style: ThemeTextStyles.bodyMedium.copyWith(
                  color: ThemeColor.black54,
                ),
              ),
            Gap.y4,
            Text('Change Status:', style: ThemeTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold)),
            Gap.y1,
            Wrap(
              spacing: 8,
              children: TaskStatus.values
                  .where((s) => s != task.status)
                  .map((s) =>
                  ChoiceChip(
                    label: Text(s.displayName),
                    selected: false,
                    backgroundColor: s.color.withOpacity(0.13),
                    labelStyle: ThemeTextStyles.bodySmall.copyWith(
                        color: s.color, fontWeight: FontWeight.w600),
                    avatar: CircleAvatar(backgroundColor: s.color, radius: 8),
                    shape: StadiumBorder(
                        side: BorderSide(color: s.color.withOpacity(0.35))),
                    onSelected: (_) async {
                      Navigator.pop(context);
                      await Provider
                          .of<TaskProvider>(context, listen: false)
                          .updateTaskStatus(task, s);
                    },
                  ))
                  .toList(),
            ),
            Gap.y4,
          ],
        ),
      ),
    );
  }
}

class _StatusTasksList extends StatefulWidget {
  final TaskStatus? status;
  final String searchQuery;

  const _StatusTasksList({required this.status, required this.searchQuery});

  @override
  State<_StatusTasksList> createState() => _StatusTasksListState();
}

class _StatusTasksListState extends State<_StatusTasksList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Task> _tasks = [];
  final Set<int> _transitioningTasks = {}; // Track tasks being completed

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimatedListWithTasks();
  }

  void _syncAnimatedListWithTasks() {
    // FIX: If a removal animation is in progress, skip syncing to avoid double-card issues!
    if (_transitioningTasks.isNotEmpty) {
      return;
    }
    final provider = Provider.of<TaskProvider>(context, listen: false);
    List<Task> newTasks = provider.getFilteredTasks(status: widget.status);

    if (widget.searchQuery
        .trim()
        .isNotEmpty) {
      final query = widget.searchQuery.trim().toLowerCase();
      newTasks = newTasks.where((task) =>
      task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query)
      ).toList();
    }

    final oldTasks = _tasks;
    // Determine removals
    for (int i = 0; i < oldTasks.length; i++) {
      if (!newTasks.any((t) => t.id == oldTasks[i].id)) {
        _listKey.currentState?.removeItem(
          i,
              (context, animation) =>
                  _buildAnimatedItem(oldTasks[i], animation),
          duration: const Duration(milliseconds: 600),
        );
      }
    }
    // Determine insertions
    for (int i = 0; i < newTasks.length; i++) {
      if (!oldTasks.any((t) => t.id == newTasks[i].id)) {
        _listKey.currentState?.insertItem(
            i, duration: const Duration(milliseconds: 600));
      }
    }
    // Final sync ONLY when no transition is happening
    _tasks = List.from(newTasks);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        List<Task> tasks = taskProvider.getFilteredTasks(status: widget.status);
        final isSearching = widget.searchQuery
            .trim()
            .isNotEmpty;
        if (isSearching) {
          final query = widget.searchQuery.trim().toLowerCase();
          tasks = tasks.where((task) =>
          task.title.toLowerCase().contains(query) ||
              task.description.toLowerCase().contains(query)
          ).toList();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !isSearching) _syncAnimatedListWithTasks();
        });

        if (taskProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (taskProvider.errorMessage != null) {
          return CustomErrorWidget(
            message: taskProvider.errorMessage ?? 'An error occurred',
            onRetry: () => taskProvider.loadTasks(),
          );
        }

        if (tasks.isEmpty) {
          return Center(
            child: FadeInWidget(
              child: Text(
                'No ${widget.status?.displayName.toLowerCase() ?? 'tasks'}',
                style: ThemeTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
            ),
          );
        }
        // If searching, just show a simple filtered list w/o animation
        if (isSearching) {
          return RefreshIndicator(
            onRefresh: () => taskProvider.refreshTasks(),
            child: ListView.builder(
              padding: ThemePadding.p2,
              itemCount: tasks.length,
              itemBuilder: (context, index) =>
                  TaskTile(
                    task: tasks[index],
                    forceChecked: false,
                    onStatusChanged: (TaskStatus? newStatus) async {
                      if (newStatus != null &&
                          newStatus != tasks[index].status) {
                        await Provider.of<TaskProvider>(context, listen: false)
                            .updateTaskStatus(tasks[index], newStatus);
                      }
                    },
                    onTap: () async {
                      final updatedTask = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTaskScreen(task: tasks[index]),
                        ),
                      );
                      if (updatedTask != null && updatedTask is Task) {
                        await Provider.of<TaskProvider>(context, listen: false)
                            .updateTaskStatus(tasks[index], updatedTask.status);
                      }
                    },
                    onCardTap: () =>
                        (context as Element).findAncestorStateOfType<
                            _TaskListScreenState>()?._showTaskDetails(
                            context, tasks[index]),
                  ),
            ),
          );
        }

        // Default: animated list (no search case)
        return RefreshIndicator(
          onRefresh: () => taskProvider.refreshTasks(),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _tasks.length,
            padding: ThemePadding.p2,
            itemBuilder: (context, index, animation) =>
                _buildAnimatedItem(_tasks[index], animation),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedItem(Task task, [Animation<double>? animation]) {
    final bool isTransitioning = _transitioningTasks.contains(task.id);
    return SlideTransition(
      position: animation != null ? Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut))
          : const AlwaysStoppedAnimation(Offset.zero),
      child: FadeTransition(
        opacity: animation != null ? animation : const AlwaysStoppedAnimation(
            1.0),
        child: TaskTile(
          task: task,
          forceChecked: isTransitioning,
          onStatusChanged: (TaskStatus? newStatus) async {
            if (newStatus != null && newStatus != task.status) {
              _transitioningTasks.add(task.id);
              setState(() {});
              await Future.delayed(const Duration(milliseconds: 500));
              if (newStatus == TaskStatus.completed &&
                  task.status != TaskStatus.completed) {
                _removeTaskInstantly(task);
                if (mounted) {
                  await Provider.of<TaskProvider>(context, listen: false)
                      .updateTaskStatus(task, newStatus);
                  _transitioningTasks.remove(task.id);
                  setState(() {});
                }
              } else {
                _removeWithAnimation(task);
                await Future.delayed(const Duration(milliseconds: 900));
                if (mounted) {
                  await Provider.of<TaskProvider>(context, listen: false)
                      .updateTaskStatus(task, newStatus);
                  _transitioningTasks.remove(task.id);
                  setState(() {});
                }
              }
            }
          },
          onTap: () async {
            final updatedTask = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditTaskScreen(task: task),
              ),
            );
            // If task was updated, update in provider
            if (updatedTask != null && updatedTask is Task) {
              await Provider.of<TaskProvider>(context, listen: false)
                  .updateTaskStatus(task, updatedTask.status);
              // If title or description are edited, you could add: refreshTasks();
            }
          },
          onCardTap: () =>
              (context as Element).findAncestorStateOfType<
                  _TaskListScreenState>()?._showTaskDetails(context, task),
        ),
      ),
    );
  }

  void _removeTaskInstantly(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks.removeAt(index);
      setState(() {});
    }
  }

  void _removeWithAnimation(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      // Remove from local list immediately to prevent double display
      _tasks.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
            (context, animation) =>
                _buildAnimatedItem(task, animation),
        duration: const Duration(milliseconds: 900),
      );
      setState(() {});
    }
  }
}

class TaskTile extends StatelessWidget {
  final Task task;
  final bool forceChecked;
  final void Function(TaskStatus?) onStatusChanged;
  final void Function() onTap;
  final void Function() onCardTap;

  const TaskTile({
    super.key,
    required this.task,
    this.forceChecked = false,
    required this.onStatusChanged,
    required this.onTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Gap.value * 0.5),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .surface,
          borderRadius: ThemeBorderRadius.r3,
          border: Border.all(color: Theme
              .of(context)
              .colorScheme
              .primary
              .withOpacity(0.2), width: 1),
        ),
        child: ListTile(
          leading: StatusPill(
            status: task.status,
            onTap: (newStatus) => onStatusChanged(newStatus),
          ),
          title: Text(
            task.title,
            style: (task.status == TaskStatus.completed)
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
          subtitle: Text(
            task.description.isEmpty ? 'No description' : task.description,
            style: ThemeTextStyles.bodyMedium.copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.6),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final TaskStatus status;
  final void Function(TaskStatus?) onTap;

  const StatusPill({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: ThemeBorderRadius.r5,
                ),
                title: Text('Change Status'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Pick the new status for this task",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                    Gap.y4,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TaskStatus.values
                          .where((s) => s != status)
                          .map((s) =>
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              onTap(s);
                            },
                            child: Chip(
                              label: Text(
                                s.displayName,
                                style: ThemeTextStyles.bodySmall.copyWith(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .onPrimary,
                                ),
                              ),
                              backgroundColor: s.color,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: ThemeBorderRadius.r4,
                              ),
                              elevation: 2,
                            ),
                          ))
                      .toList(),
                    ),
                  ],
                ),
              ),
        );
      },
      child: Chip(
        label: Text(
          status.displayName,
          style: ThemeTextStyles.bodySmall,
        ),
        backgroundColor: status.color,
      ),
    );
  }
}

class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (taskProvider.errorMessage != null) {
          return CustomErrorWidget(
            message: taskProvider.errorMessage ?? 'An error occurred',
            onRetry: () => taskProvider.loadTasks(),
          );
        }
        final completedTasks = taskProvider.getFilteredTasks(
            status: TaskStatus.completed);

        if (completedTasks.isEmpty) {
          return Center(
            child: FadeInWidget(
              child: Text(
                'No completed tasks',
                style: ThemeTextStyles.bodyMedium.copyWith(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6),
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: ThemePadding.p2,
          itemCount: completedTasks.length,
          itemBuilder: (context, index) {
            final task = completedTasks[index];
            return SlideTransition(
              position: TweenSequence<Offset>([
                TweenSequenceItem(
                  tween: Tween(
                    begin: const Offset(-1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ),
                  weight: 1.0,
                ),
              ]).animate(CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: Curves.easeOut,
              )),
              child: FadeTransition(
                opacity: ModalRoute.of(context)!.animation!,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: Gap.value * 0.5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: ThemeBorderRadius.r3,
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2), width: 1),
                  ),
                  child: ListTile(
                    leading: FadeInWidget(
                      duration: const Duration(milliseconds: 500),
                      child: Image.asset(
                        'assets/icons/check-mark.png',
                        key: ValueKey('tick_${task.id}'),
                        height: 36,
                        width: 36,
                      ),
                    ),
                    title: Text.rich(
                      TextSpan(
                        text: task.title,
                        style: ThemeTextStyles.bodyMedium.copyWith(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    subtitle: task.description.isNotEmpty
                        ? Text.rich(
                      TextSpan(
                        text: task.description,
                        style: ThemeTextStyles.bodySmall.copyWith(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.38),
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                        ),
                      ),
                    )
                        : null,
                    trailing: IconButton(
                      icon: Icon(Icons.undo, color: Theme.of(context).colorScheme.secondary),
                      tooltip: 'Mark as not completed',
                      onPressed: () => taskProvider.toggleTaskStatus(task),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
