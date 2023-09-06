
import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:car_crash_list/models/car_sales.dart';
import 'package:car_crash_list/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSaleController extends GetxController{

  DataController dataController = Get.find();
  bool xLoading = false;
  ScrollController scrollController = ScrollController();
  int? toPageIndex = 1;
  List<CarSales> allData = [];

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
          endPoint: '${ApiEndPoints.saleList}?page=$toPageIndex'
      );
      ApiServices().validateResponse(
          response: response,
          onSuccess: (data) {
            toPageIndex = data['body']['to'];
            Iterable rawData = data['body']['data']??[];
            for (var element in rawData) {
              allData.add(
                CarSales.fromMap(data: element)
              );
            }
            update();
          },
        onFailure: (data) {

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

