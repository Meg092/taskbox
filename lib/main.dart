import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:today_task/pages/today_task_detail/today_task_detail_binding.dart';
import 'package:today_task/pages/today_task_detail/today_task_detail_timer.dart';
import 'package:today_task/pages/today_task_detail/today_task_detail_view.dart';
import 'package:today_task/pages/today_task_entrance/today_task_entrance_binding.dart';
import 'package:today_task/pages/today_task_entrance/today_task_entrance_view.dart';
import 'package:today_task/pages/today_task_home/today_task_home_binding.dart';
import 'package:today_task/pages/today_task_home/today_task_home_view.dart';
import 'package:today_task/pages/today_task_new/today_task_new_binding.dart';
import 'package:today_task/pages/today_task_new/today_task_new_view.dart';
import 'package:today_task/pages/today_task_settings/today_task_settings_binding.dart';
import 'package:today_task/pages/today_task_settings/today_task_settings_view.dart';
import 'package:today_task/db_today_task/data.dart';

Color primaryColor = const Color(0xFFFF8C00);
Color bgColor = const Color(0xFFF5F5F5);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Get.putAsync(() => TodayTaskDatabase().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: TODOList,
          initialRoute: '/',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: bgColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              surface: const Color(0xFFFFFFFF),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0F0F0F),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(size: 22, color: Color(0xFF0F0F0F)),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            dividerTheme: DividerThemeData(
              thickness: 1,
              color: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }
}
List<GetPage<dynamic>> TODOList = [
  GetPage(
    name: '/',
    page: () => const TodayTaskEntranceView(),
    binding: TodayTaskEntranceBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/task_home',
    page: () => const TodayTaskHomeView(),
    binding: TodayTaskHomeBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/task_detail',
    page: () => const TodayTaskDetailView(),
    binding: TodayTaskDetailBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/detail_timer',
    page: () => TodayTaskDetailTimer(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/new_task',
    page: () => const TodayTaskNewView(),
    binding: TodayTaskNewBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/task_settings',
    page: () => const TodayTaskSettingsView(),
    binding: TodayTaskSettingsBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
];