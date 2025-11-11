import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today_task/db_today_task/data.dart';
import 'package:today_task/utils/index.dart';

class TodayTaskSettingsLogic extends GetxController {
  final _db = Get.find<TodayTaskDatabase>();

  void onBackTap() {
    Get.back();
  }

  void onDeleteRecordTap() async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete All Tasks'),
          content: const Text('Are you sure you want to delete all tasks? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _db.deleteAllTasks();
        successToast('All tasks deleted successfully');
      }
    } catch (e) {
      errorToast('Failed to delete tasks: $e');
    }
  }

  void onVersionsTap() {
    Get.dialog(
      AlertDialog(
        title: const Text('Version Info'),
        content: const Text('Version: 1.0.0'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
