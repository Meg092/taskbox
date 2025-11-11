import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:today_task/component/text_field.dart';
import 'today_task_new_logic.dart';

class TodayTaskNewView extends GetView<TodayTaskNewLogic> {
  const TodayTaskNewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(child: SingleChildScrollView(child: _buildForm())),
          ],
        ),
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
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: controller.onBackTap,
            child: Image.asset('assets/back.png', width: 30.w, height: 30.w),
          ),
          Center(
            child: Text(
              'New task',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
        padding: EdgeInsets.all(24.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTaskNameSection(),
            SizedBox(height: 24.h),
            _buildTaskTimeSection(),
            SizedBox(height: 24.h),
            _buildTaskDescriptionSection(),
            SizedBox(height: 24.h),
            _buildTaskImageSection(),
            SizedBox(height: 24.h),
            _buildColorSection(),
            SizedBox(height: 24.h),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '*',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'Task Name',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Obx(
          () => MyTextField(
            value: controller.taskName.value,
            onChange: (value) => controller.taskName.value = value,
            hintText: 'Enter task name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w),
              borderSide: const BorderSide(color: Color(0xFFFF8C00), width: 1),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '*',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'Task Duration',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: controller.onTimeSelectTap,
          child: Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.selectedDurationText.value.isEmpty
                        ? 'Select duration'
                        : controller.selectedDurationText.value,
                    style: TextStyle(
                      color: controller.selectedDurationText.value.isEmpty
                          ? Colors.grey[400]
                          : Colors.black87,
                      fontSize: 14.sp,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 20.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Description',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => MyTextField(
            value: controller.taskDescription.value,
            onChange: (value) => controller.taskDescription.value = value,
            hintText: 'Enter description (optional)',
            maxLines: 3,
            minLines: 3,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w),
              borderSide: const BorderSide(color: Color(0xFFFF8C00), width: 1),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Image',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() {
          if (controller.selectedImagePath.value.isEmpty) {
            return GestureDetector(
              onTap: controller.onImageSelectTap,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8.w),
                  color: Colors.grey[50],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40.w,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Add Image',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.w),
                  child: Image.file(
                    File(controller.selectedImagePath.value),
                    width: double.infinity,
                    height: 120.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8.w,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: controller.onRemoveImageTap,
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 20.w),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ],
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '*',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'Choose Color',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: _showColorPicker,
          child: Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: controller.selectedColor.value,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Select Color',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 20.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showColorPicker() {
    Get.dialog(
      AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: controller.selectedColor.value,
            onColorChanged: (Color color) {
              controller.selectedColor.value = color;
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Done')),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: controller.onAddTaskTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFF8C00),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Center(
          child: Text(
            'Add Task',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
