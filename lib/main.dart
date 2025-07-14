import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/background_provider.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/task_list_screen.dart';
import 'screens/splash_screen.dart';

import 'utils/theme/colors/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BackgroundProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
      ],
      child: const TaskManagementSystem(),
    ),
  );
}

class TaskManagementSystem extends StatelessWidget {
  const TaskManagementSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task Manager',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            colorScheme: ThemeColor.lightColorScheme,
            scaffoldBackgroundColor: ThemeColor.lightColorScheme.background,
            appBarTheme: AppBarTheme(
              backgroundColor: ThemeColor.primary,
              foregroundColor: ThemeColor.lightColorScheme.onPrimary,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ThemeColor.darkColorScheme,
            scaffoldBackgroundColor: ThemeColor.darkColorScheme.background,
            appBarTheme: AppBarTheme(
              backgroundColor: ThemeColor.primary,
              foregroundColor: ThemeColor.darkColorScheme.onPrimary,
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
