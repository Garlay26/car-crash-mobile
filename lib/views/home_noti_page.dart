import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:car_crash_list/controllers/home_news_controller.dart';
import 'package:car_crash_list/controllers/home_noti_controller.dart';
import 'package:car_crash_list/models/car_news.dart';
import 'package:car_crash_list/models/noti_model.dart';
import 'package:car_crash_list/services/ads_services.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/custom_dialog.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:car_crash_list/views/_widgets/timeline.dart';
import 'package:car_crash_list/views/car_detail_page.dart';
import 'package:car_crash_list/views/news_detail_page.dart';
import 'package:car_crash_list/views/sale_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class HomeNotiPage extends StatelessWidget {
  const HomeNotiPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeNotiController());
    return GetBuilder<HomeNotiController>(
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
                    const Text('Notifications',style: TextStyle(fontSize: 25),),
                    const Spacer(),
                    IconButton(onPressed: () async{
                      await controller.onRefresh();
                    }, icon: Icon(Icons.refresh_rounded,color: AppColors.black,))
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: RefreshIndicator(
                    onRefresh: () async{
                      await controller.onRefresh();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...controller.allData.map((each) {
                            return GestureDetector(
                              onTap: () async{
                                DataController dataController = Get.find();
                                AdsServices().showInterAds();
                                switch(each.notiType){
                                  case NotiType.news :
                                    MyDialog().showLoadingDialog();
                                    final result = await dataController.fetchNewsDetail(id: each.typeId);
                                    Get.back();
                                    if(result!=null){
                                      Get.to(()=> NewsDetailPage(carNews: result));
                                    }
                                    break;
                                  case NotiType.crash :
                                    Get.to(()=> CarDetailPage(id: each.typeId));
                                    break;
                                  case NotiType.sale :
                                    MyDialog().showLoadingDialog();
                                    final result = await dataController.fetchSaleDetail(id: each.typeId);
                                    Get.back();
                                    if(result!=null){
                                      Get.to(()=> SaleDetailPage(carSales: result));
                                    }
                                    break;
                                }
                                // Get.to(()=> NewsDetailPage(carNews: carNews));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(16)
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.12,
                                      child: Hero(
                                        tag: each.image,
                                        child: AspectRatio(
                                          aspectRatio: 1/1,
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                      each.image,
                                                    ),
                                                    fit: BoxFit.cover
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.widthBox(),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            each.title,
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            maxLines: 2,
                                          ),
                                          Text(
                                            each.dateTime.toString().substring(0,16),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                          (Get.height).heightBox()
                        ],
                      ),
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
