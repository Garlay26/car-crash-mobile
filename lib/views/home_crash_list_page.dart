
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_crash_list/controllers/data_controller.dart';
import 'package:car_crash_list/controllers/home_crash_list_controller.dart';
import 'package:car_crash_list/services/ads_services.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/app_images.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:car_crash_list/utils/number_normalization.dart';
import 'package:car_crash_list/views/car_detail_page.dart';
import 'package:car_crash_list/views/news_detail_page.dart';
import 'package:car_crash_list/views/sale_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeCrashListPage extends StatelessWidget {
  const HomeCrashListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeCrashListController());
    HomeCrashListController controller = Get.find();
    return GetBuilder<HomeCrashListController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.white,
          child: RefreshIndicator(
            onRefresh: () async{
              await controller.initLoad();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      bgPanel(),
                      topPanel(),
                    ],
                  ),
                  if(!controller.xLoading)Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: AppConstants.pagePadding,
                          right: AppConstants.pagePadding,
                          top: 20,
                        ),
                        child: const Text(
                          'Crashed Cars',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      crashListPanel(),
                      Container(
                        margin: EdgeInsets.only(
                          left: AppConstants.pagePadding,
                          right: AppConstants.pagePadding,
                          top: 20,
                        ),
                        child: Text(
                          'Recommended Car For Sales',
                          style: TextStyle(fontSize: 18,color: AppColors.black),
                        ),
                      ),
                      saleListPanel(),
                      Container(
                        margin: EdgeInsets.only(
                          left: AppConstants.pagePadding,
                          right: AppConstants.pagePadding,
                          top: 20,
                        ),
                        child: const Text(
                          'Advertising',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      adsPanel(),
                      Container(
                        margin: EdgeInsets.only(
                          left: AppConstants.pagePadding,
                          right: AppConstants.pagePadding,
                          top: 20,
                        ),
                        child: const Text(
                          'Recommended News',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      newsListPanel(),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bgPanel(){
    return AspectRatio(
      aspectRatio: 4/3,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset(AppImages.carCrash1).image
          )
        ),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 0,
          blur: 2.5,
          alignment: Alignment.bottomCenter,
          border: 0,
          linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.green3.withOpacity(0.75),
                AppColors.green3.withOpacity(0.75)
              ],
              stops: const [
                0.1,
                1,
              ]
          ),
          borderGradient: LinearGradient(
            colors: [
              const Color(0xFFffffff).withOpacity(0.1),
              const Color(0xFFFFFFFF).withOpacity(0.05),
            ],
          ),
          child: null,
        ),
      ),
    );
  }

  Widget topPanel(){
    return AspectRatio(
      aspectRatio: 4/3,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Get.mediaQuery.padding.top.heightBox(),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppConstants.pagePadding,
                vertical: 0
              ),
              child: FittedBox(
                child: Row(
                  children: [
                    AnimatedTextKit(
                      key: GlobalKey(),
                      animatedTexts: [
                        WavyAnimatedText('Please send car crash data by email'),
                      ],
                      isRepeatingAnimation: true,
                      onTap: () {

                      },
                    ),
                    5.widthBox(),
                    TextButton(onPressed: () {
                      Clipboard.setData(ClipboardData(text: AppConstants.hostEmail)).then((value) {
                        Get.showSnackbar(
                          GetSnackBar(
                            title: 'Success',
                            message: '${AppConstants.hostEmail} has copied to your clipboard!',
                            duration: const Duration(milliseconds: 1600),
                          ),
                        );
                      });
                    }, child: Text(AppConstants.hostEmail,style: const TextStyle(color: Colors.red,),))
                  ],
                ),
              ),
            ),
            Expanded(
              child: Image.asset(
                AppImages.logo,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.all(AppConstants.pagePadding),
              child: filterPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterPanel(){
    HomeCrashListController controller = Get.find();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      child: Container(
        width: double.infinity,
        height: 45,
        padding: const EdgeInsets.only(left: 20,top: 2,bottom: 2),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: controller.txtSearch,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Search By Car No ( eg. 1A-1234 )'
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  try{
                    controller.onClickSearch();
                  }
                  catch(e){
                    null;
                  }
                  AdsServices().showInterAds();
                  // try{
                  //   AdsServices().showRewardAds(
                  //     onUserEarnReward: () {
                  //       controller.onClickSearch();
                  //     },
                  //   );
                  // }
                  // catch(e){
                  //   controller.onClickSearch();
                  // }
                },
                icon: const Icon(Icons.search_rounded)
            )
          ],
        ),
      ),
    );
  }

  Widget crashListPanel(){
    HomeCrashListController controller = Get.find();
    return Container(
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
        items: controller.crashData.map((e) {
          return GestureDetector(
            onTap: () async{
              AdsServices().showInterAds();
              Get.to(()=> CarDetailPage(id: e.id));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
              ),
              elevation: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                                e.description,
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                e.carNumber,
                                style: TextStyle(
                                    color: AppColors.green3,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600
                                ),
                                maxLines: 1,
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
          );
        }).toList(),
      ),
    );
  }

  Widget saleListPanel(){
    HomeCrashListController controller = Get.find();
    return Container(
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
        items: controller.saleData.map((e) {
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                              Text(
                                '${NumberNormalization.numberNormalizerEnglish(rawString: e.price.toString())} Ks',
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600
                                ),
                                maxLines: 1,
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
          );
        }).toList(),
      ),
    );
  }

  Widget newsListPanel(){
    HomeCrashListController controller = Get.find();
    return Container(
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
        items: controller.newsData.map((e) {
          return GestureDetector(
            onTap: () {
              AdsServices().showInterAds();
              Get.to(()=> NewsDetailPage(carNews: e));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              elevation: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          e.image,
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
                                  color: AppColors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                                ),
                                maxLines: 1,
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
          );
        }).toList(),
      ),
    );
  }

  Widget adsPanel(){
    HomeCrashListController controller = Get.find();
    return Container(
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
        items: controller.adsData.map((e) {
          return GestureDetector(
            onTap: () {
              AdsServices().showInterAds();
              launchUrlString(e.link);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              elevation: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          e.image,
                        ),
                        fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


}
