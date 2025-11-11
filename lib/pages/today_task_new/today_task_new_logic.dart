import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:today_task/utils/index.dart';
import 'package:today_task/db_today_task/data.dart';
import 'package:today_task/db_today_task/db_today_task_entity.dart';
import 'package:today_task/utils/preferences.dart';

class TodayTaskNewLogic extends GetxController {
  final taskName = ''.obs;
  final taskDescription = ''.obs;
  final selectedColor = const Color(0xFF66CC99).obs;
  final selectedImagePath = ''.obs;
  final selectedDuration = 0.obs;
  final selectedDurationText = ''.obs;

  final _db = Get.find<TodayTaskDatabase>();

  @override
  void onInit() {
    super.onInit();
    _loadDefaultColor();
  }

  Future<void> _loadDefaultColor() async {
    final defaultColor = await UserPreferences.getDefaultColor();
    selectedColor.value = Color(defaultColor);
  }

  void onBackTap() {
    Get.back();
  }

  void onTimeSelectTap() async {
    try {
      final duration = await Get.bottomSheet<int>(
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select Task Duration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                SizedBox(
                  height: 300,
                  child: ListView(
                    children: [
                      _buildDurationOption(5),
                      _buildDurationOption(10),
                      _buildDurationOption(15),
                      _buildDurationOption(20),
                      _buildDurationOption(30),
                      _buildDurationOption(45),
                      _buildDurationOption(60),
                      _buildDurationOption(90),
                      _buildDurationOption(120),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        isScrollControlled: true,
      );

      if (duration != null) {
        selectedDuration.value = duration;
        if (duration < 60) {
          selectedDurationText.value = '$duration minutes';
        } else {
          final hours = (duration / 60).floor();
          final minutes = duration % 60;
          if (minutes == 0) {
            selectedDurationText.value =
                '$hours ${hours == 1 ? 'hour' : 'hours'}';
          } else {
            selectedDurationText.value =
                '$hours ${hours == 1 ? 'hour' : 'hours'} $minutes minutes';
          }
        }
      }
    } catch (e) {
      errorToast('Failed to select time: $e');
    }
  }

  Widget _buildDurationOption(int minutes) {
    String text;
    if (minutes < 60) {
      text = '$minutes minutes';
    } else {
      final hours = (minutes / 60).floor();
      final mins = minutes % 60;
      if (mins == 0) {
        text = '$hours ${hours == 1 ? 'hour' : 'hours'}';
      } else {
        text = '$hours ${hours == 1 ? 'hour' : 'hours'} $mins minutes';
      }
    }

    return ListTile(
      title: Text(text),
      onTap: () => Get.back(result: minutes),
    );
  }

  void onImageSelectTap() async {
    try {
      final ImagePicker picker = ImagePicker();

      final source = await Get.bottomSheet<ImageSource>(
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () => Get.back(result: ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                  onTap: () => Get.back(result: ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Cancel'),
                  onTap: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      );

      if (source != null) {
        final XFile? image = await picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );

        if (image != null) {
          final file = File(image.path);
          final fileSize = await file.length();
          if (fileSize > 10 * 1024 * 1024) {
            errorToast('Image size exceeds 10MB limit');
            return;
          }

          selectedImagePath.value = image.path;
        }
      }
    } catch (e) {
      errorToast('Failed to pick image: $e');
    }
  }

  void onRemoveImageTap() {
    selectedImagePath.value = '';
  }

  void onAddTaskTap() async {
    if (taskName.value.trim().isEmpty) {
      errorToast('Please enter task name');
      return;
    }

    if (selectedDuration.value <= 0) {
      errorToast('Please select task duration');
      return;
    }

    try {
      String? savedImagePath;
      if (selectedImagePath.value.isNotEmpty) {
        savedImagePath = await _saveImageToAppStorage(selectedImagePath.value);
      }

      final now = DateTime.now();
      final task = TaskEntity(
        name: taskName.value.trim(),
        duration: selectedDuration.value,
        description: taskDescription.value.trim().isEmpty
            ? null
            : taskDescription.value.trim(),
        imagePath: savedImagePath,
        color: selectedColor.value.value,
        createTime: now.toIso8601String(),
        status: TaskStatus.inProgress,
      );

      await _db.insertTask(task);

      await UserPreferences.setDefaultColor(selectedColor.value.value);

      successToast('Task created successfully');
      Get.back();
    } catch (e) {
      errorToast('Failed to create task: $e');
    }
  }

  Future<String> _saveImageToAppStorage(String imagePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final taskImagesDir = Directory('${appDir.path}/task_images');
      if (!await taskImagesDir.exists()) {
        await taskImagesDir.create(recursive: true);
      }

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}';
      final savedPath = '${taskImagesDir.path}/$fileName';

      final sourceFile = File(imagePath);
      await sourceFile.copy(savedPath);

      return savedPath;
    } catch (e) {
      rethrow;
    }
  }
}
