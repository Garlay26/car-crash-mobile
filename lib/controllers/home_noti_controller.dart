
import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:car_crash_list/models/noti_model.dart';
import 'package:car_crash_list/services/api_services.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_images.dart';
import 'package:car_crash_list/utils/custom_dialog.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:car_crash_list/views/car_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';

import '../models/car_news.dart';
import '../models/sale_detail.dart';

class HomeNotiController extends GetxController{

  DataController dataController = Get.find();
  bool xLoading = false;
  ScrollController scrollController = ScrollController();
  int? toPageIndex = 1;
  List<NotiModel> allData = [];

  @override
  void onInit() {
    updateData();
    super.onInit();
  }


  Future<void> updateData() async{
    xLoading = true;
    update();
    try{
      Response? response = await ApiServices().apiGetCall(
          endPoint: '${ApiEndPoints.notiList}?page=$toPageIndex'
      );
      ApiServices().validateResponse(
          response: response,
          onSuccess: (data) {
            toPageIndex = data['body']['to'];
            Iterable rawData = data['body']['data']??[];
            for (var element in rawData) {
              allData.add(
                NotiModel.fromMap(data: element)
              );
            }
            update();
          },
          onFailure: (data) {
            superPrint(data);
          },
      );
    }
    catch(e){
      null;
    }
    xLoading = false;
    update();
  }

  Future<void> onRefresh() async{
    allData.clear();
    toPageIndex = 1;
    await updateData();
  }

}

