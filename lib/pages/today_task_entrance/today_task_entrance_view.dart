import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'today_task_entrance_logic.dart';

class TodayTaskEntranceView extends GetView<TodayTaskEntranceLogic> {
  const TodayTaskEntranceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.jhkpc.value
              ? const CircularProgressIndicator(color: Colors.blueAccent)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.cyrb();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
