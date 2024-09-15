import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:car_crash_list/models/car_sales.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:car_crash_list/utils/number_normalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_colors.dart';

class SaleDetailPage extends StatelessWidget {
  final CarSales carSales;
  const SaleDetailPage({super.key,required this.carSales});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        appBar: AppBar(
          title: Text(carSales.title),
        ),
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(carSales.images.isNotEmpty)AspectRatio(
                aspectRatio: 16/9,
                child: Hero(
                  tag: carSales.images.first,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            carSales.images.first,
                          ),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
              10.heightBox(),
              Container(
                margin: EdgeInsets.all(AppConstants.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Owner Name : ${carSales.ownerName}'),
                    carSales.carNumber.length<4
                        ?Container()
                        :Text(
                      '${carSales.carNumber.substring(0,4)}***',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    ),
                    Text(
                      'Price : ${NumberNormalization.numberNormalizerEnglish(rawString: carSales.price.toString())}',
                      style: const TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                  onPressed: () async{
                    await launchUrl(Uri.parse('tel:${carSales.ownerPhone}'));
                  },
                  icon: const Icon(Icons.call_rounded,color: Colors.blue,),
                  label: Text('Contact : ${carSales.ownerPhone}',style: TextStyle(color: Colors.blue),)
              ),
              if(carSales.images.isNotEmpty)Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: Get.width * 0.5,
                child: FlutterCarousel(
                  options: FlutterCarouselOptions(
                    autoPlay: true,
                    allowImplicitScrolling: true,
                    enlargeCenterPage: false,
                    showIndicator: false,
                    enableInfiniteScroll: true,
                  ),
                  items: carSales.images.map((e) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      elevation: 2,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                e,
                              ),
                              fit: BoxFit.cover
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.all(AppConstants.pagePadding),
                child: Text(carSales.description),
              ),
              fakeWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget fakeWidget(){
    return GetBuilder<DataController>(
      builder: (controller) {
        if(!controller.xFakeMode){
          return Container();
        }
        else{
          String locationAddress = "No.42, 19th Street,Upper Block,Latha Township,Yangon";
          LatLng locationPosition = const LatLng(16.776937008479575, 96.14946587189382);
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppConstants.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.pin_drop_rounded),
                    10.widthBox(),
                    const Text("Location"),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10
                  ),
                  width: double.infinity,
                  height: Get.height * 0.25,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        AppleMap(
                          initialCameraPosition: CameraPosition(
                            target: locationPosition,
                            zoom: 16
                          ),
                          onTap: (argument) {
                            Get.dialog(
                              Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Container(
                                  width: Get.width,
                                  height: Get.height * 0.7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.green2,
                                      width: 1.5
                                    )
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: AppleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: locationPosition,
                                          zoom: 16
                                      ),
                                      onTap: (argument) {
                                      },
                                      annotations: {
                                        Annotation(
                                          annotationId: AnnotationId('location'),
                                          icon: BitmapDescriptor.markerAnnotationWithHue(BitmapDescriptor.hueGreen),
                                          position: locationPosition,
                                        )
                                      },
                                    ),
                                  ),
                                ),
                              )
                            );
                          },
                          annotations: {
                            Annotation(
                              annotationId: AnnotationId('location'),
                              icon: BitmapDescriptor.markerAnnotationWithHue(BitmapDescriptor.hueGreen),
                              position: locationPosition,
                            )
                          },
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                            child: const Text(
                              'Tap to view',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Text(
                  locationAddress,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          );
        }
      },
    );
  }

}
