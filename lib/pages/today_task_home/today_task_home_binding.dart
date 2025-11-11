import 'package:get/get.dart';
import 'today_task_home_logic.dart';

class TodayTaskHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodayTaskHomeLogic());
  }
}
