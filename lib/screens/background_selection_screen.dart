import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/utils/theme/colors/color.dart';
import '../providers/background_provider.dart';
import '../utils/theme/padding.dart';
import '../utils/text/text_style.dart';
import '../utils/theme/gaps.dart';

class BackgroundSelectionScreen extends StatefulWidget {
  const BackgroundSelectionScreen({Key? key}) : super(key: key);

  @override
  State<BackgroundSelectionScreen> createState() =>
      _BackgroundSelectionScreenState();
}

class _BackgroundSelectionScreenState extends State<BackgroundSelectionScreen> {
  String? tempSelection;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BackgroundProvider>(context, listen: false);
    tempSelection = provider.selectedBackground;
  }

  @override
  Widget build(BuildContext context) {
    final imageList = [
      'assets/images/1.jpg',
      'assets/images/2.jpg',
      'assets/images/3.jpg',
      'assets/images/4.jpg',
      'assets/images/5.jpg',
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Select Background',
          style: ThemeTextStyles.h3.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Container(
        padding: ThemePadding.p4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your preferred background',
              style: ThemeTextStyles.bodyMedium,
            ),
            Gap.y4,
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: imageList.length + 1, // 5 images + 1 default bg
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildDefaultOption(context);
                  }
                  return _buildImageOption(context, imageList[index - 1]);
                },
              ),
            ),
            Gap.y2,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: ThemeColor.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: tempSelection == Provider
                    .of<BackgroundProvider>(context)
                    .selectedBackground ? null : () {
                  Navigator.pop(context, tempSelection); // Pass bg directly
                },
                child: const Text('Confirm'),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultOption(BuildContext context) {
    final isSelected = tempSelection == null;
    return GestureDetector(
      onTap: () {
        setState(() {
          tempSelection = null;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme
                .of(context)
                .colorScheme
                .primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.format_color_reset,
              size: 32,
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
            ),
            Gap.y2,
            Text(
              'Default',
              style: ThemeTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(BuildContext context, String imagePath) {
    final isSelected = tempSelection == imagePath;
    return GestureDetector(
      onTap: () {
        setState(() {
          tempSelection = imagePath;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme
                .of(context)
                .colorScheme
                .primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
