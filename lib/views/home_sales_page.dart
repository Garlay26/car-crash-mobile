import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_crash_list/controllers/home_news_controller.dart';
import 'package:car_crash_list/controllers/home_sales_controller.dart';
import 'package:car_crash_list/models/car_news.dart';
import 'package:car_crash_list/services/ads_services.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/app_images.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:car_crash_list/views/_widgets/timeline.dart';
import 'package:car_crash_list/views/news_detail_page.dart';
import 'package:car_crash_list/views/sale_detail_page.dart';
import 'package:car_crash_list/views/sale_serch_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

import '../utils/number_normalization.dart';

class HomeSalesPage extends StatelessWidget {
  const HomeSalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeSaleController());
    return GetBuilder<HomeSaleController>(
      builder: (controller) {
        return Container(
          color: AppColors.white,
          padding: EdgeInsets.only(
            top: Get.mediaQuery.padding.top,
            left: AppConstants.pagePadding,
            right: AppConstants.pagePadding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Text('Car Sales',style: TextStyle(fontSize: 25),),
                    10.widthBox(),
                    Expanded(
                      child: Hero(
                        tag: 'saleSearch',
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            padding: const EdgeInsets.only(left: 20,top: 2,bottom: 2),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              readOnly: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: 'Search',
                                icon: Icon(Icons.search_rounded)
                              ),
                              onTap: () {
                                Get.to(()=> const SaleSearchPage());
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: () async{
                      await controller.onRefresh();
                    }, icon: Icon(Icons.refresh_rounded,color: AppColors.black,))
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async{
                    AdsServices().showRewardAds(onUserEarnReward: () {
                      controller.onRefresh();
                    },);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...controller.allData.map((e) {
                          return GestureDetector(
                            onTap: () {
                              AdsServices().showInterAds();
                              Get.to(()=> SaleDetailPage(carSales: e));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              elevation: 2,
                              child: AspectRatio(
                                aspectRatio: 16/9,
                                child: Hero(
                                  tag: e.images.first,
                                  child: Material(
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              e.images.first,
                                            ),
                                            fit: BoxFit.cover
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          const Spacer(),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                            decoration: BoxDecoration(
                                                color: AppColors.black.withOpacity(0.8),
                                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12))
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.title,
                                                  style: TextStyle(
                                                      color: AppColors.green3,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                2.heightBox(),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${NumberNormalization.numberNormalizerEnglish(rawString: e.price.toString())} Ks',
                                                      style: TextStyle(
                                                          color: AppColors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    const Spacer(),
                                                    e.carNumber.length<4
                                                        ?Container()
                                                        :Text(
                                                      '${e.carNumber.substring(0,4)}***',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        if(controller.xLoading)Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: const CupertinoActivityIndicator(
                            color: Colors.grey,
                          ),
                        ),
                        if(!controller.xLoading && controller.toPageIndex!=null)TextButton(
                            onPressed: () {
                              controller.updateData();
                            },
                            child: const Text('Load More',style: TextStyle(color: Colors.grey),)
                        ),
                        if(controller.toPageIndex==null)TextButton(
                            onPressed: () {
                            },
                            child: const Text('That is all for now !',style: TextStyle(color: Colors.grey),)
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
          // child: Timeline(
          //   controller: controller.scrollController,
          //   indicators: [
          //     ...controller.allData.map((e) {
          //       return Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           RotatedBox(
          //               quarterTurns: 3,
          //               child: Text(
          //                 e.dateTime.toString().substring(0,16),
          //                 style: TextStyle(
          //                     fontSize: 14,
          //                     fontWeight: FontWeight.bold,
          //                     color: AppColors.green1
          //                 ),
          //               )
          //           ),
          //         ],
          //       );
          //     }).toList(),
          //     if(controller.xLoading)loadingWidget(),
          //     if(!controller.xLoading && controller.toPageIndex!=null)Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Container(
          //           width: 8,
          //           height: 8,
          //           decoration: BoxDecoration(
          //               shape: BoxShape.circle,
          //               color: AppColors.black
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          //   lineColor: Colors.transparent,
          //   lineGap: 0,
          //   children: [
          //     ...controller.allData.map((e) {
          //       return Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(e.title,style: const TextStyle(fontSize: 18),),
          //                 HtmlWidget(
          //                   e.content,
          //                   textStyle: const TextStyle(
          //                     fontSize: 12,
          //                     height: 1.5,
          //                     color: Colors.grey
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           10.widthBox(),
          //           Container(
          //             width: (Get.width * 0.25),
          //             height: (Get.width * 0.25) * 9/16,
          //             decoration: BoxDecoration(
          //               image: DecorationImage(
          //                   image: CachedNetworkImageProvider(
          //                       e.image
          //                   ),
          //                   fit: BoxFit.fill
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     }).toList(),
          //     if(controller.xLoading)loadingWidget(),
          //     if(!controller.xLoading && controller.toPageIndex!=null)
          //       TextButton(
          //           onPressed: () {
          //             controller.updateNews();
          //           },
          //           child: const Text('Load More')),
          //   ],
          // ),
        );
      },
    );
  }

  Widget loadingWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: CupertinoActivityIndicator(color: AppColors.green3),
    );
  }

}
