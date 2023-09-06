import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:car_crash_list/models/car_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';

import '../services/api_services.dart';

class CarDetailController extends GetxController{

  CarDetail? carDetail;
  bool xLoading = false;
  DataController dataController = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> updateData({required String id}) async{
    xLoading = true;
    update();
    try{
      carDetail = await dataController.fetchCarDetail(id: id);
    }
    catch(e){
      null;
    }
    xLoading = false;
    update();

  }

}