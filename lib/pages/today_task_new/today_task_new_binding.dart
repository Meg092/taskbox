import 'package:get/get.dart';
import 'today_task_new_logic.dart';

class TodayTaskNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodayTaskNewLogic());
  }
}
