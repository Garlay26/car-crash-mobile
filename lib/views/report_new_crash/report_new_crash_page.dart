import 'dart:io';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/custom_dialog.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportNewCrashPage extends StatefulWidget {
  const ReportNewCrashPage({super.key});

  @override
  State<ReportNewCrashPage> createState() => _ReportNewCrashPageState();
}

class _ReportNewCrashPageState extends State<ReportNewCrashPage> {

  TextEditingController txtCarName = TextEditingController(text: '');
  TextEditingController txtLocation = TextEditingController(text: '');
  TextEditingController txtTitle = TextEditingController(text: '');
  TextEditingController txtDescription = TextEditingController(text: '');
  Rx<List<String>> photos = Rx<List<String>>([]);
  Rx<LatLng> location = const LatLng(16.8514323787434, 96.15704264504507).obs;
  AppleMapController? mapController;
  
  Future<void> onAddNewPhoto({required bool xCamera}) async{
    Get.back();
    ImagePicker imagePicker = ImagePicker();
    if(xCamera){
      //camera
      final result1 = await Permission.camera.request();
      final result2 = await Permission.microphone.request();
      if(!result1.isPermanentlyDenied || !result1.isDenied){
        imagePicker.pickMultiImage().then((value) {
          photos.value.addAll(
            value.map((e) => e.path).toList()
          );
          photos.refresh();
        });
      }
    }
    else{
      //photos
      final result = await Permission.photos.request();
      if(!result.isPermanentlyDenied || !result.isDenied){
        imagePicker.pickMultiImage().then((value) {
          photos.value.addAll(
              value.map((e) => e.path).toList()
          );
          photos.refresh();
        });
      }
    }
  }

  Future<void> onClickSubmit() async{
    // TextEditingController txtCarName = TextEditingController(text: '');
    // TextEditingController txtLocation = TextEditingController(text: '');
    // TextEditingController txtTitle = TextEditingController(text: '');
    // TextEditingController txtDescription = TextEditingController(text: '');
    // Rx<List<String>> photos = Rx<List<String>>([]);

    if(txtCarName.text.isEmpty){
      MyDialog().showAlertDialog(message: 'Please fill all field to continue');
    }
    else if(txtLocation.text.isEmpty){
      MyDialog().showAlertDialog(message: 'Please fill all field to continue');
    }
    else if(txtTitle.text.isEmpty){
      MyDialog().showAlertDialog(message: 'Please fill all field to continue');
    }
    else{
      MyDialog().showLoadingDialog();
      await Future.delayed(const Duration(seconds: 5));
      Get.back();
      Get.back();
      MyDialog().showAlertDialog(message: 'The crash has been reported successfully!. It will be on the list after we review them.Thank you!');
    }

  }

  void showMap(){
    Get.dialog(
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Choose location",
            ),
          ),
          body: Obx(
                ()=> AppleMap(
              initialCameraPosition: CameraPosition(
                target: location.value,
                zoom: 17.5,
              ),
              onTap: (argument) {
                location.value = argument;
                location.refresh();
                mapController!.animateCamera(CameraUpdate.newLatLng(location.value));
              },
              annotations: {
                Annotation(
                    annotationId: AnnotationId('current'),
                    icon: BitmapDescriptor.markerAnnotationWithHue(BitmapDescriptor.hueGreen),
                    position: location.value
                )
              },
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSuperScaffold(
      isTopSafe: false  ,
      isBotSafe: false,
      appBar: AppBar(
        title: const Text("Report new crash",style: TextStyle(fontSize: 20),),
        centerTitle: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(AppConstants.pagePadding),
        child: SingleChildScrollView(
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelTextWidget(label: 'Car Name', txtController: txtCarName),
                  labelTextWidget(label: 'Title', txtController: txtTitle),
                  labelTextWidget(label: 'Description', txtController: txtDescription),
                  labelTextWidget(label: 'Location In Text', txtController: txtLocation),
                  5.heightBox(),
                  Text('Location In Map (Tap To Set Location)',style: TextStyle(color: AppColors.black.withOpacity(0.7),fontSize: 14,),),
                  10.heightBox(),
                  GestureDetector(
                    onTap: () {
                      showMap();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: Get.height * 0.45,
                      child: AppleMap(
                        onMapCreated: (controller) {
                          mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: location.value,
                          zoom: 17.5,
                        ),
                        onTap: (argument) {
                          location.value = argument;
                          location.refresh();
                          showMap();
                        },
                        annotations: {
                          Annotation(
                            annotationId: AnnotationId('current'),
                            icon: BitmapDescriptor.markerAnnotationWithHue(BitmapDescriptor.hueGreen),
                            position: location.value
                          )
                        },
                      ),
                    ),
                  ),
                  10.heightBox(),
                  Text('Images',style: TextStyle(color: AppColors.black.withOpacity(0.7),fontSize: 14,),),
                  ...photos.value.map((e) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10
                      ),
                      child: AspectRatio(
                        aspectRatio: 16/9,
                        child: GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: Image.file(File(e)).image,
                                fit: BoxFit.cover
                              )
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10
                    ),
                    child: AspectRatio(
                      aspectRatio: 16/9,
                      child: GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 40
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Please choose where to pick photo from',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey
                                    ),
                                  ),
                                  10.heightBox(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {
                                            onAddNewPhoto(xCamera: true);
                                          },
                                          icon: const Icon(Icons.camera,color: Colors.black,),
                                          label: const Text("Camera",style: TextStyle(color: Colors.black),)
                                      ),
                                      TextButton.icon(
                                          onPressed: () {
                                            onAddNewPhoto(xCamera: false);
                                          },
                                          icon: const Icon(Icons.photo,color: Colors.black,),
                                          label: const Text("Photo",style: TextStyle(color: Colors.black),)
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image),
                              5.heightBox(),
                              const Text("Click to add an image")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10
                    ),
                    child: ElevatedButton(
                      onPressed: () async{
                        onClickSubmit();
                      },
                      child: const Text('Report Now'),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget labelTextWidget({
    required String label,
    required TextEditingController txtController,
    int? maxLine
  }){
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: txtController,
            decoration: InputDecoration(
              labelText: label
            ),
            maxLines: maxLine,
          )
        ],
      ),
    );
  }

}
