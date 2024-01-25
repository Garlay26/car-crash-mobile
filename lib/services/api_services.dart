import 'dart:convert';
import 'dart:io';
import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import '../utils/custom_dialog.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class ApiServices {
  String baseUrl = 'http://cclist4mm.xyz/api/';
  DataController dataController = Get.find();
  // String baseUrl = '${baseDomainUrl}api/v1/';

  void validateResponse({
    required Response? response,
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(Map<String, dynamic> data) onFailure
  }) async {
    if (response != null) {
      if (response.body != null) {
        Map<String, dynamic> responseBody = response.body;
        try {
          if (response.body['meta']['messageMm'] == 'Unauthorized') {
            return;
          } else if (response.statusCode == 200 || response.statusCode == 201) {
            if (responseBody['meta']['status']) {
              onSuccess(responseBody);
            } else {
              onFailure(responseBody);
            }
          } else {
            onFailure(responseBody);
          }
        } catch (e) {
          MyDialog().showAlertDialog(
              message: e.toString());
          null;
        }
      } else {
        MyDialog().showAlertDialog(
            message: 'Session is expired, please log in to continue');
        return;
      }
    } else {
      MyDialog().showServerErrorDialog();
    }
  }

  Future<bool> xHasInternet() async {
    bool xHasInternet = false;
    try {
      final result = await InternetAddress.lookup('farytaxi.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        xHasInternet = true;
      }
    } on SocketException catch (_) {
      xHasInternet = false;
    }
    return xHasInternet;
  }


  Response? responseConverter({required http.Response? response}) {
    if (response != null) {
      return Response(
        bodyString: response.body,
        body: jsonDecode(response.body),
        statusCode: response.statusCode,
      );
    } else {
      return null;
    }
  }

  Future<Response?> getEndPoints() async {
    http.Response? response;
    try {
      response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/walkmandede/xsphere_end_points/main/end_points.json'));
    } catch (e) {
      null;
    }
    return responseConverter(response: response);
  }


  // Future<FaryDirection?> getDirection(
  //     {required LatLng from, required LatLng to}) async {
  //   FaryDirection? faryDirection;
  //   try {
  //     Response response = await client.get(
  //         "https://api.tomtom.com/routing/1/calculateRoute/"
  //             "${from.latitude},${from.longitude}:"
  //             "${to.latitude},${to.longitude}"
  //             "/json?key=$tomTomApiKey"
  //             "&travelMode=car"
  //             "&routeType=shortest"
  //         // "&computeBestOrder=true"
  //             "&maxAlternatives=5"
  //     );
  //
  //     Map body = response.body;
  //     Iterable routes = body['routes'];
  //
  //     faryDirection = FaryDirection.fromTomTom(data: routes.first);
  //   } catch (e) {
  //     superPrint(e);
  //   }
  //   return faryDirection;
  // }


  Future<Response?> publicGetCall(
      {required String endPoint}) async {
    http.Response? response;
    try {
      response = await http.get(Uri.parse(endPoint), headers: {
        'Access-Control-Allow-Origin': '*',
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      });
    } catch (e) {
      superPrint(e);
    }

    return responseConverter(response: response);
  }

  Future<Response?> apiGetCall(
      {required String endPoint, bool xNeedToken = false}) async {
    http.Response? response;
    try {
      response = await http.get(Uri.parse('$baseUrl$endPoint'), headers: {
        'Access-Control-Allow-Origin': '*',
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
        if (xNeedToken) 'Authorization': 'Bearer ${dataController.apiToken}',
      });
    } catch (e) {
      superPrint(e);
    }

    return responseConverter(response: response);
  }

  Future<Response?> apiPostCall(
      {required String endPoint,
        bool xNeedToken = false,
        required var data}) async {
    http.Response? response;

    try {
      response = await http.post(Uri.parse('$baseUrl$endPoint'),
          body: jsonEncode(data),
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
            if (xNeedToken)
              'Authorization': 'Bearer ${dataController.apiToken}',
          });
    } catch (e) {
      superPrint(e);
    }

    return responseConverter(response: response);
  }


  Future<Response?> apiFormDataCall({
    required String endPoint,
    bool xNeedToken = false,
    required Map<String, dynamic> data,
    String type = 'application/json'
  }) async {
    Response? response;
    try {
      dio.FormData formData = dio.FormData.fromMap(data);
      var dioClient = dio.Dio();
      dioClient.options = dioClient.options.copyWith(followRedirects: false);
      var dioResponse = await dioClient.post('$baseUrl$endPoint',
          options:
              dio.Options(contentType: 'text/html; charset=utf-8', headers: {
            'Access-Control-Allow-Origin': '*',
            'Accept': '*/*',
            'Content-Type': '$type; charset=UTF-8',
            if (xNeedToken)
              'Authorization': 'Bearer ${dataController.apiToken}',
          }),
          data: formData
      );

      superPrint(dioResponse);

      response = Response(
        statusCode: dioResponse.statusCode,
        headers: {},
        body: dioResponse.data,
      );
    } catch (e) {
      superPrint(e);
      if(e is dio.DioException){
        superPrint(e.response!.data,title: e.response!.statusCode);
      }
    }
    return response;
  }
}

class ApiEndPoints {
  static const String crashCheck = "crash-check";
  static const String saleList = "sale-list";
  static const String saleDetail = "sale-detail";
  static const String newsDetail = "post-detail";
  static const String saleSearch = "search-sale";
  static const String carDetail = "crash-detail";
  static const String newsList = "post-list";
  static const String crashList = "crash-list";
  static const String adsList = "advertising-list";
  static const String notiList = "noti";

  static const String recommendedSaleList = "recommended-sale-list";
  static const String recommendedNewsList = "recommended-new-list";
  static const String recommendedCrashList = "recommended-crash-list";


  static const String shareMessage = "https://raw.githubusercontent.com/ChawThida/tolimotesa/main/carCrashListShare.json";

  static const String register = "register";
  static const String login = "login";
  static const String reportCrash = "report-crash";
  static const String mapDataList = "map-data/list";
  static const String reportMapData = "map-data/create";
  static const String accountDelete = "delete_user";


}
