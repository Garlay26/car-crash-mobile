
import 'dart:math';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/custom_dialog.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';

enum MapDummyTypes{
  gasStation,
  egg,
  trafficLightOff,
  populated,
}


class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {

  Rx<LatLng> currentLatLng = const LatLng(16.81733643778101, 96.15592077737314).obs;
  Rx<DateTime> lastUpdatedAt = DateTime.now().obs;
  Rx<List<LatLng>> dummyPoints = Rx<List<LatLng>>([
    const LatLng(16.81733643778101, 96.15592077737314),
    const LatLng(16.81133643778101, 96.1253207737314),
    const LatLng(16.78230079615058, 96.1621419422612),
    const LatLng(16.792935389216716, 96.14299195120026),
    const LatLng(16.830399258372026, 96.12954049524836),
    const LatLng(16.830233789601124, 96.17535117748247),
    const LatLng(16.846862382902135, 96.1826117382106),
    const LatLng(16.85190858497779, 96.12383576909286),
    const LatLng(16.851081345849657, 96.15918778765666),
    const LatLng(16.77959446110062, 96.1964413763738),
    const LatLng(16.80367465085251, 96.19929373951697),
    const LatLng(16.786876767501063, 96.14293795994638),
    const LatLng(16.79060056500469, 96.1282439666777),
    const LatLng(16.836438659408927, 96.15840987043578),
    const LatLng(16.841154224475208, 96.19592276489323),
    const LatLng(16.850915900619324, 96.18122877558136),
    const LatLng(16.804253864305643, 96.17630196651584),
    const LatLng(16.790931564430714, 96.13446730444468),
  ]);
  Rx<MapDummyTypes> currentType = MapDummyTypes.trafficLightOff.obs;

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> initLoad() async{

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
                              case MapDummyTypes.egg:
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
                                      MyDialog().showLoadingDialog();
                                      await Future.delayed(const Duration(seconds: 3));
                                      Get.back();
                                      Get.back();
                                      MyDialog().showAlertDialog(message: 'Your report has been sent! After we review them, it will be on the list soon.Thanks!!!');
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
                circles: dummyPoints.value.map((eachLocation) {
                  int rnd = Random().nextInt(MapDummyTypes.values.length);
                  MapDummyTypes type = MapDummyTypes.values[rnd];
                  Color fillColor = Colors.redAccent.withOpacity(0.5);
                  switch(type){
                    case MapDummyTypes.egg:
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
                    circleId: CircleId(eachLocation.toString()),
                    center: eachLocation,
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
                      case MapDummyTypes.egg:
                        fillColor = Colors.white.withOpacity(0.5);
                        label = 'Egg';
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
