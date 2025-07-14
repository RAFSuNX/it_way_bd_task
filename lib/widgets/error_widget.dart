// lib/widgets/error_widget.dart
import 'package:flutter/material.dart';
import 'package:task_management_system/utils/theme/colors/color.dart';
import 'package:task_management_system/utils/theme/padding.dart';
import 'package:task_management_system/utils/text/text_style.dart';
import 'package:task_management_system/utils/theme/gaps.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: ThemePadding.p4,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: ThemeColor.primary,
              ),
              Gap.y4,
              Text(
                message,
                style: ThemeTextStyles.bodyMedium.copyWith(
                  color: ThemeColor.black54,
                ),
                textAlign: TextAlign.center,
              ),
              Gap.y4,
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColor.primary,
                  padding: ThemePadding.px4,
                ),
                child: Text(
                  'Retry',
                  style: ThemeTextStyles.button.copyWith(
                    color: ThemeColor.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}