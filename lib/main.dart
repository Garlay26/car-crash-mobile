import 'dart:io';

import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:car_crash_list/gate_way_page.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/views/auth/login/v_login_page.dart';
import 'package:car_crash_list/views/auth/profile/profile_controller.dart';
import 'package:car_crash_list/views/home_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:screen_protector/screen_protector.dart';

void main() async{
  Get.put(DataController());
  Get.put(ProfileController());
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Future.delayed(const Duration(seconds: 1));
  if(Platform.isAndroid){
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  try{
    if(Platform.isIOS){
      await ScreenProtector.protectDataLeakageWithColor(Colors.white);
    }
  }
  catch(e){
    null;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextStyle defaultTextStyle = GoogleFonts.nunito(
      color: AppColors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600
    );
    return GetMaterialApp(
      title: 'Car Crash List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(AppColors.green1.value, const {
            050: Color.fromRGBO(29, 44, 77, .1),
            100: Color.fromRGBO(29, 44, 77, .2),
            200: Color.fromRGBO(29, 44, 77, .3),
            300: Color.fromRGBO(29, 44, 77, .4),
            400: Color.fromRGBO(29, 44, 77, .5),
            500: Color.fromRGBO(29, 44, 77, .6),
            600: Color.fromRGBO(29, 44, 77, .7),
            700: Color.fromRGBO(29, 44, 77, .8),
            800: Color.fromRGBO(29, 44, 77, .9),
            900: Color.fromRGBO(29, 44, 77, 1),
          }),
          useMaterial3: false,
          textTheme: TextTheme(
            bodyMedium: defaultTextStyle,
            titleMedium: defaultTextStyle,
            labelLarge: defaultTextStyle,
            bodyLarge: defaultTextStyle,
            bodySmall: defaultTextStyle,
            titleLarge: defaultTextStyle,
            titleSmall: defaultTextStyle,
          )
      ),
      home: const GateWayPage(),
    );
  }
}
