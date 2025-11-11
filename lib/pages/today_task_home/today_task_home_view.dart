import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:today_task/db_today_task/db_today_task_entity.dart';
import 'today_task_home_logic.dart';

class TodayTaskHomeView extends GetView<TodayTaskHomeLogic> {
  const TodayTaskHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: topPadding + 16.h,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'To-do list',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Obx(
                () => GestureDetector(
                  onTap: controller.onViewModeTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    width: 94.w,
                    height: 34.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: Row(
                      children: [
                        Center(
                          child: Icon(
                            controller.viewMode.value == 'block'
                                ? Icons.grid_view
                                : Icons.list,
                            size: controller.viewMode.value == 'block'
                                ? 24.w
                                : 26.w,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            controller.viewMode.value == 'block'
                                ? 'Block'
                                : 'List',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: controller.onAddTaskTap,
                child: Image.asset(
                  'assets/plus.png',
                  width: 30.w,
                  height: 30.w,
                ),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: controller.onSettingsTap,
                child: Image.asset(
                  'assets/setting.png',
                  width: 30.w,
                  height: 30.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_outlined, size: 64.w, color: Colors.grey[400]),
                SizedBox(height: 16.h),
                Text(
                  'No tasks yet',
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Tap + to create a new task',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        if (controller.viewMode.value == 'block') {
          return _buildBlockView();
        } else {
          return _buildListView();
        }
      }),
    );
  }

  Widget _buildBlockView() {
    final tasks = controller.tasks;
    final leftColumnTasks = <int>[];
    final rightColumnTasks = <int>[];

    for (int i = 0; i < tasks.length; i++) {
      if (i % 2 == 0) {
        leftColumnTasks.add(i);
      } else {
        rightColumnTasks.add(i);
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftColumnTasks.asMap().entries.map((entry) {
                final columnIndex = entry.key;
                final taskIndex = entry.value;
                final task = tasks[taskIndex];
                final size = columnIndex % 2 == 0 ? 160.0 : 140.0;
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: _buildTaskCard(
                    task.name,
                    controller.getRemainingTimeText(task),
                    Color(task.color),
                    controller.getProgress(task),
                    size,
                    task.id!,
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 72.h),
              child: Column(
                children: rightColumnTasks.asMap().entries.map((entry) {
                  final columnIndex = entry.key;
                  final taskIndex = entry.value;
                  final task = tasks[taskIndex];
                  final size = columnIndex % 2 == 1 ? 160.0 : 140.0;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: _buildTaskCard(
                      task.name,
                      controller.getRemainingTimeText(task),
                      Color(task.color),
                      controller.getProgress(task),
                      size,
                      task.id!,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final tasks = controller.tasks;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildListTaskCard(
          task.name,
          controller.getRemainingTimeText(task),
          task.description ?? '',
          Color(task.color),
          controller.getProgress(task),
          task.id!,
        );
      },
    );
  }

  Widget _buildTaskCard(
    String name,
    String time,
    Color color,
    double progress,
    double size,
    int taskId,
  ) {
    final task = controller.tasks.firstWhere((t) => t.id == taskId);
    final isCompleted =
        task.status == TaskStatus.completed ||
        controller.getRemainingSeconds(task) <= 0;

    return GestureDetector(
      onTap: () => controller.onTaskTap(taskId),
      child: Opacity(
        opacity: isCompleted ? 0.5 : 1.0,
        child: Container(
          width: size.w,
          height: size.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              _AnimatedWave(color: color, progress: progress, size: size),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 20.w),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedWave extends StatelessWidget {
  final Color color;
  final double progress;
  final double size;

  const _AnimatedWave({
    required this.color,
    required this.progress,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.w),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.w,
            height: size.h * progress,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color.withValues(alpha: 0.7), color],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on TodayTaskHomeView {
  Widget _buildListTaskCard(
    String name,
    String time,
    String description,
    Color color,
    double progress,
    int taskId,
  ) {
    final task = controller.tasks.firstWhere((t) => t.id == taskId);
    final isCompleted =
        task.status == TaskStatus.completed ||
        controller.getRemainingSeconds(task) <= 0;

    return GestureDetector(
      onTap: () => controller.onTaskTap(taskId),
      child: Opacity(
        opacity: isCompleted ? 0.5 : 1.0,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.only(right: 16.w, top: 12.h, bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14.w,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (description.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14.w,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2.w),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isCompleted ? Colors.green : color,
                              ),
                              minHeight: 4.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
