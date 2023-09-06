import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:car_crash_list/services/api_services.dart';
import 'package:car_crash_list/utils/custom_dialog.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/app_images.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeMorePage extends StatelessWidget {
  const HomeMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white
        ),
        padding: EdgeInsets.all(AppConstants.pagePadding),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.logo,width: Get.width * 0.5,),
                    5.heightBox(),
                    const Text('Car Crash List',style: TextStyle(fontSize: 50,fontWeight: FontWeight.w600),),
                    Text('App Version : 1.0.1',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: AppColors.green1),),
                  ],
                ),
              ),
            ),
            FittedBox(
              child: Row(
                children: [
                  AnimatedTextKit(
                    key: GlobalKey(),
                    animatedTexts: [
                      WavyAnimatedText('Please send car crash data by email'),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {

                    },
                  ),
                  5.widthBox(),
                  TextButton(onPressed: () {
                    Clipboard.setData(ClipboardData(text: AppConstants.hostEmail)).then((value) {
                      Get.showSnackbar(
                        GetSnackBar(
                          title: 'Success',
                          message: '${AppConstants.hostEmail} has copied to your clipboard!',
                          duration: const Duration(milliseconds: 1600),
                        ),
                      );
                    });
                  }, child: Text(AppConstants.hostEmail,style: TextStyle(color: AppColors.green1,),))
                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(onPressed: () async{
                MyDialog().showLoadingDialog();
                Response? response;
                String appLink = '-';
                String message = 'Car Crash Mobile Application';
                try{
                  response = await ApiServices().publicGetCall(endPoint: ApiEndPoints.shareMessage);
                }
                catch(e){
                  null;
                }
                Get.back();
                if(response!=null){
                  Map<String,dynamic> body = jsonDecode(response.bodyString!);
                  appLink = body['appLink'].toString();
                  message = body['message'].toString();
                }
                Share.share(
                  "$message\nDownload Link : $appLink"
                );
              }, child: const Text('Share Now')),
            )
          ],
        ),
      ),
    );
  }
}
