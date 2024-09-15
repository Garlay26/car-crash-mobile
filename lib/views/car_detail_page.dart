import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_crash_list/utils/app_constants.dart';
import 'package:car_crash_list/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:car_crash_list/controllers/car_detail_controller.dart';
import 'package:car_crash_list/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CarDetailPage extends StatelessWidget {
  final String id;
  const CarDetailPage({super.key,required this.id});

  @override
  Widget build(BuildContext context) {
    Get.put(CarDetailController());
    CarDetailController controller = Get.find();
    controller.updateData(id: id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        centerTitle: false,
        leading: const BackButton(color: Colors.white,),
        title: GetBuilder<CarDetailController>(
          builder: (controller) {
            if(controller.carDetail!=null){
              return Text(
                '${controller.carDetail!.state} ${controller.carDetail!.carNumber}',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 25
                ),
              );
            }
            else{
              return Container();
            }
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(AppConstants.pagePadding),
        child: GetBuilder<CarDetailController>(
          builder: (controller) {
            if(controller.xLoading){
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            else{

              if(controller.carDetail!.images.isEmpty){
                return const Center(
                  child: Text('ဓာတ်ပုံမရှိပါ'),
                );
              }
              else{
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.carDetail!.description*20,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                      10.heightBox(),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.carDetail!.images.length,
                        itemBuilder: (context, index) {
                          String image = controller.carDetail!.images[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: AppConstants.pagePadding),
                            child: AspectRatio(
                              aspectRatio: 4/3,
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppConstants.pagePadding)
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppConstants.pagePadding),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            image,
                                          ),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
