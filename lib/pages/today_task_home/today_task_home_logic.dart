import 'dart:async';
import 'package:get/get.dart';
import 'package:today_task/utils/preferences.dart';
import 'package:today_task/db_today_task/data.dart';
import 'package:today_task/db_today_task/db_today_task_entity.dart';
import 'package:today_task/utils/index.dart';

class TodayTaskHomeLogic extends GetxController {
  final viewMode = UserPreferences.viewModeBlock.obs;

  final tasks = <TaskEntity>[].obs;

  final isLoading = false.obs;

  Timer? _countdownTimer;

  final _db = Get.find<TodayTaskDatabase>();

  @override
  void onInit() {
    super.onInit();
    _loadViewMode();
    _loadTasks();
    _startCountdownTimer();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadViewMode() async {
    viewMode.value = await UserPreferences.getViewMode();
  }

  Future<void> _loadTasks() async {
    try {
      isLoading.value = true;
      final inProgressTasks = await _db.getTasksByStatus(TaskStatus.inProgress);
      final completedTasks = await _db.getTasksByStatus(TaskStatus.completed);
      tasks.value = [...inProgressTasks, ...completedTasks];
    } catch (e) {
      errorToast('Failed to load tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTasks() async {
    await _loadTasks();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      tasks.refresh();
    });
  }

  int getRemainingSeconds(TaskEntity task) {
    final now = DateTime.now();
    final createTime = DateTime.parse(task.createTime);
    final endTime = createTime.add(Duration(minutes: task.duration));
    final remaining = endTime.difference(now).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  String getRemainingTimeText(TaskEntity task) {
    final remainingSeconds = getRemainingSeconds(task);
    if (remainingSeconds <= 0) {
      return 'Time\'s up';
    }

    final minutes = (remainingSeconds / 60).floor();
    if (minutes == 0) {
      return '$remainingSeconds seconds left';
    } else if (minutes == 1) {
      return '1 minute left';
    } else {
      return '$minutes minutes left';
    }
  }

  double getProgress(TaskEntity task) {
    final now = DateTime.now();
    final createTime = DateTime.parse(task.createTime);
    final totalSeconds = task.duration * 60;
    final elapsedSeconds = now.difference(createTime).inSeconds;

    double progress;
    if (elapsedSeconds <= 0) {
      progress = 0.0;
    } else if (elapsedSeconds >= totalSeconds) {
      progress = 1.0;
    } else {
      progress = elapsedSeconds / totalSeconds;
    }

    if (viewMode.value == UserPreferences.viewModeBlock) {
      return 1.0 - progress;
    }

    return progress;
  }

  void onViewModeTap() async {
    if (viewMode.value == UserPreferences.viewModeBlock) {
      viewMode.value = UserPreferences.viewModeList;
    } else {
      viewMode.value = UserPreferences.viewModeBlock;
    }
    await UserPreferences.setViewMode(viewMode.value);
  }

  void onAddTaskTap() async {
    await Get.toNamed('/new_task');
    refreshTasks();
  }

  void onSettingsTap() async {
    await Get.toNamed('/task_settings');
    refreshTasks();
  }

  void onTaskTap(int taskId) async {
    await Get.toNamed('/task_detail', arguments: taskId);
    refreshTasks();
  }
}
