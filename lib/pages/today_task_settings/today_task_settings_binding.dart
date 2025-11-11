import 'package:get/get.dart';
import 'today_task_settings_logic.dart';

class TodayTaskSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodayTaskSettingsLogic());
  }
}
