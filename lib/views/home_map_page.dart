
import 'dart:async';
import 'dart:math';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:car_crash_list/services/api_services.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/custom_dialog.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';

enum MapDummyTypes{
  gasStation,
  suddenCheck,
  trafficLightOff,
  populated,
}

class MapDataModel{

  String id;
  LatLng latLng;
  MapDummyTypes mapDummyTypes;

  MapDataModel({
    required this.id,
    required this.latLng,
    required this.mapDummyTypes
  });

  factory MapDataModel.fromMap({required Map<String,dynamic> data}){

    MapDummyTypes mapDummyTypes = MapDummyTypes.gasStation;

    try{
      mapDummyTypes = MapDummyTypes.values.where((element) => element.name == data['type'].toString()).first;
    }
    catch(e){
      null;
    }

    return MapDataModel(
      id: data['id'].toString(),
      latLng: LatLng(
        double.tryParse(data['lat'].toString())??0,
        double.tryParse(data['lng'].toString())??0,
      ),
      mapDummyTypes: mapDummyTypes
    );
  }

}


class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {

  Rx<LatLng> currentLatLng = const LatLng(16.81733643778101, 96.15592077737314).obs;
  Rx<DateTime> lastUpdatedAt = DateTime.now().obs;
  Rx<List<MapDataModel>> dummyPoints = Rx<List<MapDataModel>>([

  ]);
  Rx<MapDummyTypes> currentType = MapDummyTypes.trafficLightOff.obs;
  Timer? timer;

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    if(timer!=null){
      timer!.cancel();
    }
    super.dispose();
  }

  Future<void> initLoad() async{
    updateMapData();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async{
      updateMapData();
    });
  }

  Future<void> updateMapData() async{
    try{
      dummyPoints.value.clear();
      final response = await ApiServices().apiGetCall(endPoint: ApiEndPoints.mapDataList,xNeedToken: true);
      superPrint(response!.body);
      Iterable iterable = response!.body['body'];
      for (var value in iterable) {
        dummyPoints.value.add(MapDataModel.fromMap(data: value));
      }
      dummyPoints.refresh();
    }
    catch(e){
      superPrint(e);
      null;
    }
  }


  Future<void> reportNow({
    required String lat,
    required String lng,
    required MapDummyTypes mapDummyTypes
  }) async{

    MyDialog().showLoadingDialog();
    Response? apiResponse;
    try{
      apiResponse = await ApiServices().apiPostCall(
          endPoint: ApiEndPoints.reportMapData,
          data: {
            "lat" : lat,
            "lng" : lng,
            "type" : mapDummyTypes.name,
          },
          xNeedToken: true
      );
    }
    catch(e){
      superPrint(e);
      null;
    }
    superPrint({
      "lat" : lat,
      "lng" : lng,
      "type" : mapDummyTypes.name,
    });
    superPrint(apiResponse!.body);
    Get.back(canPop: false);

    try{
      if(apiResponse==null){
        MyDialog().showAlertDialog(message: 'Something went wrong!');
      }
      else{
        if(apiResponse.body["meta"]["status"]){
          Get.back(canPop: false);
          MyDialog().showAlertDialog(message: 'Your report has been sent! After we review them, it will be on the list soon.Thanks!!!');
        }
        else{
          MyDialog().showAlertDialog(message: apiResponse.body["meta"]["message"].toString());
        }
      }
    }
    catch(e){
      MyDialog().showAlertDialog(message: 'Something went wrong!');
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return Stack(
            alignment: Alignment.bottomLeft,
            children: [
              AppleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLatLng.value,
                  zoom: 16
                ),
                onTap: (argument) {
                  Get.dialog(
                    Dialog(
                      child: Container(
                        padding: EdgeInsets.all(AppConstants.pagePadding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Obx(
                          () {
                            Color fillColor = Colors.white.withOpacity(0.5);
                            switch(currentType.value){
                              case MapDummyTypes.suddenCheck:
                                fillColor = Colors.white.withOpacity(0.5);
                                break;
                              case MapDummyTypes.gasStation:
                                fillColor = Colors.greenAccent.withOpacity(0.5);
                                break;
                              case MapDummyTypes.populated:
                                fillColor = Colors.orange.withOpacity(0.5);
                                break;
                              case MapDummyTypes.trafficLightOff:
                                fillColor = Colors.black.withOpacity(0.7);
                                break;
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: Get.height * 0.25,
                                    child: AppleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: argument,
                                        zoom: 16,
                                      ),
                                      circles: {
                                        Circle(
                                          circleId: CircleId(argument.toString()),
                                          radius: 150,
                                          fillColor: fillColor,
                                          strokeWidth: 2,
                                          center: argument,
                                          strokeColor: Colors.black
                                        )
                                      },
                                    ),
                                  ),
                                ),
                                10.heightBox(),
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  alignment: Alignment.centerRight,
                                  child: DropdownButton<MapDummyTypes>(
                                    onChanged: (value) {
                                      currentType.value = value??currentType.value;
                                      currentType.refresh();
                                    },
                                    underline: Container(),
                                    value: currentType.value,
                                    items: MapDummyTypes.values.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                10.heightBox(),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10
                                  ),
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      reportNow(
                                          lat: argument.latitude.toString(),
                                          lng: argument.longitude.toString(),
                                          mapDummyTypes: currentType.value
                                      );
                                    },
                                    child: const Text('Report Now'),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  );
                },
                circles: dummyPoints.value.map((eachData) {
                  Color fillColor = Colors.redAccent.withOpacity(0.5);
                  switch(eachData.mapDummyTypes){
                    case MapDummyTypes.suddenCheck:
                      fillColor = Colors.white.withOpacity(0.5);
                      break;
                    case MapDummyTypes.gasStation:
                      fillColor = Colors.greenAccent.withOpacity(0.5);
                      break;
                    case MapDummyTypes.populated:
                      fillColor = Colors.orange.withOpacity(0.5);
                      break;
                    case MapDummyTypes.trafficLightOff:
                      fillColor = Colors.black.withOpacity(0.7);
                      break;
                  }
                  return Circle(
                    circleId: CircleId(eachData.id),
                    center: eachData.latLng,
                    radius: 150,
                    strokeWidth: 1,
                    fillColor: fillColor,
                  );
                }).toSet(),
              ),
              Container(
                margin: EdgeInsets.all(AppConstants.pagePadding),
                decoration: BoxDecoration(
                  color: AppColors.green1.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all()
                ),
                width: Get.width * 0.4,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: MapDummyTypes.values.map((type) {
                    String label = '';
                    Color fillColor = Colors.redAccent;
                    switch(type){
                      case MapDummyTypes.suddenCheck:
                        fillColor = Colors.white.withOpacity(0.5);
                        label = 'Sudden Check';
                        break;
                      case MapDummyTypes.gasStation:
                        fillColor = Colors.greenAccent.withOpacity(0.5);
                        label = 'Gas Station';
                        break;
                      case MapDummyTypes.populated:
                        fillColor = Colors.orange.withOpacity(0.5);
                        label = 'Populated Area';
                        break;
                      case MapDummyTypes.trafficLightOff:
                        fillColor = Colors.black.withOpacity(0.7);
                        label = 'Traffic Light Off';
                        break;
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 15,height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: fillColor,
                              border: Border.all()
                            ),
                          ),
                          10.widthBox(),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(label),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    top: (Get.mediaQuery.padding.top)
                  ),
                  child: Container(
                    margin: EdgeInsets.all(AppConstants.pagePadding),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.green1.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all()
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: const Text('Tap the map to report!'),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
