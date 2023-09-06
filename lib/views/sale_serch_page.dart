import 'package:car_crash_list/controllers/sale_search_controller.dart';
import 'package:car_crash_list/models/car_sales.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/app_images.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:car_crash_list/utils/number_normalization.dart';
import 'package:car_crash_list/views/sale_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';

class SaleSearchPage extends StatelessWidget {
  const SaleSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SaleSearchController());
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: GetBuilder<SaleSearchController>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                Hero(
                  tag: 'saleSearch',
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Container(
                      width: Get.width * 0.8,
                      height: 35,
                      padding: const EdgeInsets.only(left: 20,top: 2,bottom: 2),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: controller.txtSearch,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Search',
                            icon: Icon(Icons.search_rounded)
                        ),
                        onEditingComplete: () {
                          controller.timer.cancel();
                          controller.updateData();
                        },
                        autofocus: true,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
              ),
              padding: EdgeInsets.only(
                left: AppConstants.pagePadding,
                right: AppConstants.pagePadding,
                top: AppConstants.pagePadding,
              ),
              child: dataPanel(),
            ),
          );
        }
      ),
    );
  }

  Widget dataPanel(){
    SaleSearchController controller = Get.find();
    superPrint(controller.xLoading);
    superPrint(controller.allData);
    if(controller.xLoading){
      return const Center(
        child: CupertinoActivityIndicator(color: Colors.black,),
      );
    }
    else{
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.allData.length,
        itemBuilder: (context, index) {
          CarSales data = controller.allData[index];
          return GestureDetector(
            onTap: () {
              Get.to(()=> SaleDetailPage(carSales: data));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.4)
                  )
                )
              ),
              child: Row(
                children: [
                  Text(data.title),
                  const Spacer(),
                  10.widthBox(),
                  Text(NumberNormalization.numberNormalizerEnglish(rawString: data.price.toString()))
                ],
              ),
            ),
          );
        },
      );
    }

  }

}
