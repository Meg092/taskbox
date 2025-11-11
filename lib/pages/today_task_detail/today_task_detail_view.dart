import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'today_task_detail_logic.dart';

class TodayTaskDetailView extends GetView<TodayTaskDetailLogic> {
  const TodayTaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(child: _buildCountdownArea()),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: topPadding + 16.h,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.w),
          bottomRight: Radius.circular(16.w),
        ),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: controller.onBackTap,
              child: Image.asset('assets/back.png', width: 30.w, height: 30.w),
            ),
            Expanded(
              child: Center(
                child: Text(
                  controller.task.value?.name ?? 'Task',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.onCompleteTap,
              child: Image.asset('assets/check.png', width: 30.w, height: 30.w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownArea() {
    return Obx(() {
      final task = controller.task.value;
      if (task == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final progressValue = controller.progress.value;

      return Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: progressValue,
              child: Container(color: Color(task.color)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 40.h),
                _buildCountdownDisplay(),

                if (task.description != null &&
                    task.description!.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  _buildDescription(task.description!),
                ],

                Expanded(child: Container()),

                if (task.imagePath != null && task.imagePath!.isNotEmpty) ...[
                  _buildTaskImage(task.imagePath!),
                  SizedBox(height: 50.h),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTaskImage(String imagePath) {
    return Container(
      width: double.infinity,
      height: 220.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.w),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey[300]!, Colors.grey[400]!],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 56.w,
                  color: Colors.grey[600],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCountdownDisplay() {
    return Text(
      controller.getFormattedTime(),
      style: TextStyle(
        fontSize: 86.sp,
        fontWeight: FontWeight.w900,
        color: Colors.black87,
        letterSpacing: 8,
        height: 1,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black87,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
