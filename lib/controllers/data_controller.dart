
import 'dart:convert';

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

  // Future<void> checkAppMode() async{
  //   GetConnect getConnect = GetConnect(
  //     timeout: const Duration(seconds: 90)
  //   );
  //   final response = await getConnect.get('https://raw.githubusercontent.com/ChawThida/ccl/main/x.json');
  //   try{
  //     Map<String,dynamic> data = jsonDecode(response.bodyString??'');
  //     superPrint(data);
  //     xFakeMode = data['body']['x'];
  //     update();
  //   }
  //   catch(e){
  //     superPrint(e);
  //     null;
  //   }
  // }

}