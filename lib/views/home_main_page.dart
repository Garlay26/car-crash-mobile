import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:car_crash_list/services/ads_services.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/custom_dialog.dart';
import 'package:car_crash_list/views/home_crash_list_page.dart';
import 'package:car_crash_list/views/home_news_page.dart';
import 'package:car_crash_list/views/home_noti_page.dart';
import 'package:car_crash_list/views/home_sales_page.dart';
import 'package:car_crash_list/views/home_more_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/app_constants.dart';

enum HomeTabs{
  home,
  news,
  sale,
  notification,
  more
}

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {

  PageController pageController = PageController();
  Rx<HomeTabs> currentTab = HomeTabs.home.obs;

  BannerAd? _bannerAd;
  // AdmobInterstitial? admobInterstitial;
  // AdmobReward? admobReward;
  Rx<bool> xLoaded = false.obs;


  @override
  void initState() {
    initLoad();
    super.initState();
  }

  Future<void> initLoad() async{
    currentTab.listen((p0) {
      switch(p0){
        case HomeTabs.home : {
          pageController.animateToPage(0, duration: const Duration(milliseconds: 250), curve: Curves.linear);
        };break;
        case HomeTabs.news : {
          pageController.animateToPage(1, duration: const Duration(milliseconds: 250), curve: Curves.linear);
        };break;
        case HomeTabs.sale : {
          pageController.animateToPage(2, duration: const Duration(milliseconds: 250), curve: Curves.linear);
        };break;
        case HomeTabs.notification : {
          pageController.animateToPage(3, duration: const Duration(milliseconds: 250), curve: Curves.linear);
        };break;
        case HomeTabs.more : {
          pageController.animateToPage(4, duration: const Duration(milliseconds: 250), curve: Curves.linear);
        };break;
      }
    });
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    _bannerAd = BannerAd(
      adUnitId: AppConstants.adMobBannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          superPrint('banner loaded');
        },
        onAdFailedToLoad: (ad, err) {
          superPrint('banner error $err');
          ad.dispose();
        },
      ),
    )..load();
    xLoaded.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
          ()=> !xLoaded.value?Container():Column(
          children: [
            Expanded(child: shownPagePanel()),
            if(_bannerAd!=null)SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
          ()=> BottomNavigationBar(
            currentIndex: HomeTabs.values.indexOf(currentTab.value),
            onTap: (value) {
              currentTab.value = HomeTabs.values[value];
            },
            elevation: 10,
            selectedItemColor: AppColors.green1,
            unselectedItemColor: AppColors.black.withOpacity(0.5),
            items: HomeTabs.values.map((e) {
              IconData icon = Icons.home_rounded;
              String title = '';
              switch(e){
                case HomeTabs.home :
                  icon = Icons.home_rounded;
                  title = 'Home';
                  break;
                case HomeTabs.sale :
                  icon = Icons.attach_money_rounded;
                  title = 'Sale';
                  break;
                case HomeTabs.news :
                  icon = Icons.newspaper_rounded;
                  title = 'News';
                  break;
                case HomeTabs.notification :
                  icon = Icons.notifications_active_rounded;
                  title = 'Noti';
                  break;
                case HomeTabs.more :
                  icon = Icons.more_horiz_rounded;
                  title = 'More';
                  break;
              }

              bool xSelected = e == currentTab.value;

              return BottomNavigationBarItem(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(icon),
                    if(e == HomeTabs.notification)Transform.translate(
                      offset: const Offset(10,-10),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red
                        ),
                        alignment: Alignment.center,
                      ),
                    )
                  ],
                ),
                label: title,
              );
            }).toList(),
          ),
      ),
    );
  }

  Widget shownPagePanel(){
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        HomeCrashListPage(),
        HomeNewsPage(),
        HomeSalesPage(),
        HomeNotiPage(),
        HomeMorePage()
      ],
    );
  }

  // Widget naviPanel(){
  //   return Obx(
  //     () {
  //       return Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.only(
  //           left: 20,right: 20,bottom: 30,top: 5
  //         ),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           boxShadow: [
  //             BoxShadow(
  //               color: AppColors.green1.withOpacity(0.05),
  //               offset: const Offset(0,-1),
  //               spreadRadius: 4,
  //               blurRadius: 4
  //             )
  //           ]
  //         ),
  //         child: CupertinoSlidingSegmentedControl<HomeTabs>(
  //           onValueChanged: (value) {
  //             currentTab.value = value!;
  //           },
  //           padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 3),
  //           thumbColor: AppColors.green3,
  //           groupValue: currentTab.value,
  //           backgroundColor: AppColors.white,
  //           children: const {
  //             HomeTabs.home : Text('Crash'),
  //             HomeTabs.news : Text('News'),
  //             HomeTabs.sale : Text('Sales'),
  //             HomeTabs.notification : Text('Noti'),
  //             HomeTabs.more : Text('More'),
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

}
