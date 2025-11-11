import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'today_task_settings_logic.dart';

class TodayTaskSettingsView extends GetView<TodayTaskSettingsLogic> {
  const TodayTaskSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(context),
            SizedBox(height: 20.h),
            _buildSettingsList(),
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
              'settings',
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

  Widget _buildSettingsList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
        children: [
          _buildSettingItem(
            'Delete All Tasks',
            controller.onDeleteRecordTap,
            showArrow: true,
          ),
          _buildDivider(),
          _buildSettingItem(
            'Versions',
            controller.onVersionsTap,
            showArrow: false,
            rightText: '1.0.0',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    VoidCallback onTap, {
    bool showArrow = false,
    String? rightText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey[400],
              )
            else if (rightText != null)
              Text(
                rightText,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      height: 1,
      color: Colors.grey[200],
    );
  }
}
