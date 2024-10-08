
import 'dart:convert';
import 'dart:io';

import 'package:car_crash_list/models/car_detail.dart';
import 'package:car_crash_list/models/car_news.dart';
import 'package:car_crash_list/models/car_sales.dart';
import 'package:car_crash_list/models/car_sales.dart';
import 'package:car_crash_list/models/car_sales.dart';
import 'package:car_crash_list/models/sale_detail.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';

import '../models/car_ads.dart';
import '../services/api_services.dart';

class DataController extends GetxController{

  String apiToken = '';
  bool xFakeMode = true;
  int appIosVersion = 13;
  int appAndroidVersion = 13;
  String appStoreLink = "";
  String playStoreLink = "";

  Future<List<CarSales>> fetchSaleData({required int pageIndex}) async{
    List<CarSales> result = [];
    try{
      var response = await ApiServices().apiGetCall(
        endPoint: "${ApiEndPoints.saleList}?page=${pageIndex.toString()}",
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

  Future<CarDetail?> fetchCarDetail({required String id}) async{
    CarDetail? result;
    try{
      Response? response = await ApiServices().apiGetCall(
        endPoint: "${ApiEndPoints.carDetail}?id=$id",
      );
      if(response!.isOk){
        return CarDetail.fromMap(data: response.body['body']);
      }
    }
    catch(e){
      null;
    }
    return result;
  }

  Future<CarSales?> fetchSaleDetail({required String id}) async{
    CarSales? result;
    try{
      Response? response = await ApiServices().apiGetCall(
        endPoint: "${ApiEndPoints.saleDetail}?id=$id",
      );
      if(response!.isOk){
        return CarSales.fromMap(data: response.body['body']);
      }
    }
    catch(e){
      null;
    }
    return result;
  }

  Future<CarNews?> fetchNewsDetail({required String id}) async{
    CarNews? result;
    try{
      Response? response = await ApiServices().apiGetCall(
        endPoint: "${ApiEndPoints.newsDetail}?id=$id",
      );
      if(response!.isOk){
        return CarNews.fromMap(data: response.body['body']);
      }
    }
    catch(e){
      null;
    }
    return result;
  }

  Future<List<CarNews>> fetchNewsData({required int pageIndex}) async{
    List<CarNews> result = [];
    try{
      var response = await ApiServices().apiGetCall(
        endPoint: "${ApiEndPoints.newsList}?page=${pageIndex.toString()}",
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

  Future<List<CarDetail>> fetchCrashData({required int pageIndex}) async{
    List<CarDetail> result = [];
    try{
      var response = await ApiServices().apiGetCall(
        endPoint: "${ApiEndPoints.crashList}?page=${pageIndex.toString()}",
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

  Future<List<CarAds>> fetchAdsData() async{
    List<CarAds> result = [];
    try{
      var response = await ApiServices().apiGetCall(
        endPoint: ApiEndPoints.adsList,
      );
      if(response!.isOk){
        Iterable rawList = response.body['body'];
        for(final each in rawList){
          result.add(CarAds.fromMap(data: each));
        }
      }
    }
    catch(e){
      null;
    }
    return result;
  }

  Future<bool> xShouldGoToUpdatePage() async{
    bool xResult = false;
    try{
     var response = await ApiServices().apiGetCall(
       endPoint: ApiEndPoints.version,
     );
     superPrint(response);
     if(response!.isOk){
       superPrint(response.body);
       appStoreLink = response.body["appStoreLink"].toString();
       playStoreLink = response.body["playStoreLink"].toString();
       if(Platform.isIOS || Platform.isMacOS){
         int cloudIosVersion = int.tryParse(response.body["iosVersion"].toString())??-1;
         if(cloudIosVersion < 0){
           return false;
         }
         else if(cloudIosVersion > appIosVersion){
           return true;
         }
         else if(cloudIosVersion < appIosVersion){
           xFakeMode = true;
           return false;
         }
         else if(cloudIosVersion == appIosVersion){
           xFakeMode = false;
           return false;
         }
       }
       else if(Platform.isAndroid){
         int cloudAndroidVersion = int.tryParse(response.body["androidVersion"].toString())??-1;
         if(cloudAndroidVersion < 0){
           return false;
         }
         else if(cloudAndroidVersion > appAndroidVersion){
           return true;
         }
         else if(cloudAndroidVersion < appAndroidVersion){
           xFakeMode = true;
           return false;
         }
         else if(cloudAndroidVersion == appAndroidVersion){
           xFakeMode = false;
           return false;
         }
       }
       superPrint(response.body);
     }
   }
   catch(e){
      superPrint(e);
     null;
   }

    return xResult;

  }

}