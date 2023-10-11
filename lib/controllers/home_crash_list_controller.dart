
import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:car_crash_list/models/car_ads.dart';
import 'package:car_crash_list/models/car_detail.dart';
import 'package:car_crash_list/models/car_news.dart';
import 'package:car_crash_list/models/car_sales.dart';
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

import '../models/sale_detail.dart';

class HomeCrashListController extends GetxController{

  DataController dataController = Get.find();
  TextEditingController txtSearch = TextEditingController(text: '');
  bool xLoading = false;
  List<CarSales> saleData = [];
  List<CarNews> newsData = [];
  List<CarDetail> crashData = [];
  List<CarAds> adsData = [];

  @override
  void onInit() {
    initLoad();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> initLoad() async{
    xLoading = true;
    saleData.clear();
    newsData.clear();
    crashData.clear();
    adsData.clear();
    update();
    try{
      saleData.addAll(await fetchRecommendedSaleList());
      newsData.addAll(await fetchRecommendedNewsList());
      crashData.addAll(await fetchRecommendedCrashList());
      adsData.addAll(await dataController.fetchAdsData());
    }
    catch(e){
      superPrint(e);
      null;
    }
    xLoading = false;
    update();
  }

  Future<List<CarSales>> fetchRecommendedSaleList() async{
    List<CarSales> result = [];
    try{
      var response = await ApiServices().apiGetCall(
        endPoint: ApiEndPoints.recommendedSaleList,
      );
      if(response!.isOk){
        Iterable rawList = response.body['body']['data'];
        for(final each in rawList){
          result.add(CarSales.fromMap(data: each));
        }
      }
    }
    catch(e){
      null;
    }
    return result;
  }

  Future<List<CarDetail>> fetchRecommendedCrashList() async{
    List<CarDetail> result = [];
    try{
      var response = await ApiServices().apiGetCall(
        endPoint: ApiEndPoints.recommendedCrashList,
      );
      if(response!.isOk){
        Iterable rawList = response.body['body']['data'];
        for(final each in rawList){
          result.add(CarDetail.fromMap(data: each));
        }
      }
    }
    catch(e){
      null;
    }
    return result;
  }

  Future<List<CarNews>> fetchRecommendedNewsList() async{
    List<CarNews> result = [];
    try{
      var response = await ApiServices().apiGetCall(
        endPoint: ApiEndPoints.recommendedNewsList,
      );
      if(response!.isOk){
        Iterable rawList = response.body['body']['data'];
        for(final each in rawList){
          result.add(CarNews.fromMap(data: each));
        }
      }
    }
    catch(e){
      null;
    }
    return result;
  }



  Future<void> onClickSearch() async{
    MyDialog().showLoadingDialog();
    Response? response;
    try{
      response = await ApiServices().apiPostCall(
        endPoint: ApiEndPoints.crashCheck,
        data: {
          'car_number' : txtSearch.text.replaceAll('-', '/')
        },
      );
      Get.back();
    }
    catch(e){
      null;
    }

    ApiServices().validateResponse(
      response: response,
      onSuccess: (data) {
        Get.dialog(
          Dialog(
            backgroundColor: Colors.transparent,
            child: CarFoundDialog(id: data['body']['id'].toString()),
          )
        );
      },
      onFailure: (data) {
        Get.dialog(
            Dialog(
              backgroundColor: Colors.transparent,
              child: CarFoundDialog(id: ''),
            )
        );
      },
    );
  }

}

class CarFoundDialog extends StatelessWidget {
  final String id;
  const CarFoundDialog({super.key,required this.id});

  @override
  Widget build(BuildContext context) {
    bool xFound = id.isNotEmpty;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(xFound)const Text('Found Crashed Car',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.red),),
                if(!xFound)Text('No Record Found',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: AppColors.black),),
                10.heightBox(),
                if(xFound)Image.asset(
                  AppImages.carCrashIcon,
                  width: 150,
                ),
                if(!xFound)const Icon(Icons.warning_amber_rounded,color: Colors.redAccent,size: 150),
                if(xFound)10.heightBox(),
                if(xFound)TextButton(
                  onPressed: () {
                    Get.back();
                    Get.to(()=> CarDetailPage(id: id));
                  },
                  child: const Text('View Details',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.red),),
                )
              ],
            ),
          )
        )
      ],
    );
  }
}
