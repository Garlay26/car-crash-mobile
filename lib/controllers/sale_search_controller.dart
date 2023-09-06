import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';
import '../models/car_sales.dart';
import '../services/api_services.dart';

class SaleSearchController extends GetxController{

  TextEditingController txtSearch = TextEditingController(text: '');
  List<CarSales> allData = [];
  bool xLoading = false;
  Timer timer = Timer(const Duration(seconds: 2), () {

  });

  @override
  void onInit() {
    timer = Timer(const Duration(seconds: 2), () {
      updateData();
    });
    txtSearch.addListener(() {
      String query = txtSearch.text;
      timer.cancel();
      timer = Timer(const Duration(milliseconds: 800), () {
        if(txtSearch.text.isNotEmpty){
          updateData();
        }
      });
    });
    super.onInit();
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }


  Future<void> updateData() async{
    xLoading = true;
    update();
    allData.clear();
    try{
      Response? response = await ApiServices().apiGetCall(
          endPoint: '${ApiEndPoints.saleSearch}?search=${txtSearch.text}'
      );
      ApiServices().validateResponse(
        response: response,
        onSuccess: (data) {
          Iterable rawData = data['body']??[];
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


}