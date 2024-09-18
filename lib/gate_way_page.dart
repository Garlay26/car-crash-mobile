import 'dart:io';

import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:car_crash_list/views/auth/login/v_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GateWayPage extends StatefulWidget {
  const GateWayPage({super.key});

  @override
  State<GateWayPage> createState() => _GateWayPageState();
}

class _GateWayPageState extends State<GateWayPage> {

  ValueNotifier<bool> xNeedUpdate = ValueNotifier(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkVersion();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void checkVersion() async{
    DataController dataController = Get.find();
    xNeedUpdate.value = await dataController.xShouldGoToUpdatePage();
    superPrint(xNeedUpdate.value,title: "Go To Update Page");
    if(!xNeedUpdate.value){
      Get.offAll(()=> const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: xNeedUpdate,
        builder: (context, xnu, child) {
          if(!xnu){
            return const Center(
              child: Text("Initializing application... Please wait!"),
            );
          }
          else{
            return SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "New version is available! Please update to continue!"
                  ),
                  ElevatedButton(onPressed: () {
                    String link = "";
                    DataController dataController = Get.find();
                    if(Platform.isAndroid){
                      link = dataController.playStoreLink;
                    }
                    else{
                      link = dataController.appStoreLink;
                    }
                    launchUrl(Uri.parse(link));
                  }, child: const Text("Update Now"))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
