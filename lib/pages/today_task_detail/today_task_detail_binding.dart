import 'package:get/get.dart';
import 'today_task_detail_logic.dart';

class TodayTaskDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodayTaskDetailLogic());
  }
}
