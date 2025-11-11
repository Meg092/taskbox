import 'package:get/get.dart';

import 'today_task_entrance_logic.dart';

class TodayTaskEntranceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      TodayTaskEntranceLogic(),
      permanent: true,
    );
  }
}
