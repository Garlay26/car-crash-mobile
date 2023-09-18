import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_crash_list/models/car_sales.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:car_crash_list/utils/number_normalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
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
                  options: CarouselOptions(
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
            ],
          ),
        ),
      ),
    );
  }
}
