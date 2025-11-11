import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today_task/db_today_task/data.dart';
import 'package:today_task/db_today_task/db_today_task_entity.dart';
import 'package:today_task/utils/index.dart';

class TodayTaskDetailLogic extends GetxController {
  final task = Rxn<TaskEntity>();
  final remainingSeconds = 0.obs;
  final progress = 0.0.obs;

  Timer? _countdownTimer;
  final _db = Get.find<TodayTaskDatabase>();

  @override
  void onInit() {
    super.onInit();
    final taskId = Get.arguments as int?;
    if (taskId != null) {
      _loadTask(taskId);
    } else {
      errorToast('Task not found');
      Get.back();
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadTask(int taskId) async {
    try {
      final loadedTask = await _db.getTaskById(taskId);
      if (loadedTask == null) {
        errorToast('Task not found');
        Get.back();
        return;
      }

      task.value = loadedTask;
      _startCountdownTimer();
    } catch (e) {
      errorToast('Failed to load task: $e');
      Get.back();
    }
  }

  void _startCountdownTimer() {
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (task.value == null) return;

    if (task.value!.status == TaskStatus.completed) {
      remainingSeconds.value = 0;
      progress.value = 0.0;
      return;
    }

    final now = DateTime.now();
    final createTime = DateTime.parse(task.value!.createTime);
    final endTime = createTime.add(Duration(minutes: task.value!.duration));
    final remaining = endTime.difference(now).inSeconds;

    remainingSeconds.value = remaining > 0 ? remaining : 0;

    final totalSeconds = task.value!.duration * 60;
    final elapsedSeconds = now.difference(createTime).inSeconds;

    if (elapsedSeconds <= 0) {
      progress.value = 1.0;
    } else if (elapsedSeconds >= totalSeconds) {
      progress.value = 0.0;
    } else {
      progress.value = 1.0 - (elapsedSeconds / totalSeconds);
    }
  }

  String getFormattedTime() {
    if (task.value?.status == TaskStatus.completed) {
      return '00:00';
    }
    
    final minutes = (remainingSeconds.value / 60).floor();
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void onBackTap() {
    Get.back();
  }

  void onCompleteTap() async {
    if (task.value == null) return;

    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Complete Task'),
          content: const Text(
            'Are you sure you want to mark this task as completed?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _db.updateTaskStatus(task.value!.id!, TaskStatus.completed);
        await _loadTask(task.value!.id!);
        successToast('Task completed!');
      }
    } catch (e) {
      errorToast('Failed to complete task: $e');
    }
  }
}
