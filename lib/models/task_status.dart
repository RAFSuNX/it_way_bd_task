import 'dart:ui';

import '../utils/theme/colors/color.dart';

enum TaskStatus {
  working,
  completed,
  pending,
  due;

  String get displayName {
    switch (this) {
      case TaskStatus.working:
        return 'Working';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.due:
        return 'Due';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.working:
        return ThemeColor.statusWorking;
      case TaskStatus.completed:
        return ThemeColor.statusCompleted;
      case TaskStatus.pending:
        return ThemeColor.statusPending;
      case TaskStatus.due:
        return ThemeColor.statusDue;
    }
  }
}
