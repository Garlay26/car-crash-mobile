import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

extension CustomBox on double{

  Widget widthBox(){
    return SizedBox(width: this,);
  }

  Widget heightBox({Color? bgColor}){
    if(bgColor==null){
      return SizedBox(height: this,);
    }
    else{
      return Container(
        width: double.infinity,
        height: this,
        decoration: BoxDecoration(
          color: bgColor
        ),
      );
    }
  }

  double screenWidth(){
    return Get.width * this;
}

}

extension CustomBox2 on int{

  Widget widthBox(){
    return SizedBox(width: toDouble(),);
  }

  Widget heightBox(){
    return SizedBox(height: toDouble(),);
  }

}


// extension MapExtensions on MapController{
//
//   Future<void> animateTo({required LatLng to,required AnimationController animationController}) async{
//     LatLng from = center;
//     Tween<double> latTween = Tween<double>(
//       begin: from.latitude,
//       end: to.latitude, // Destination longitude
//     );
//     Tween<double> lngTween = Tween<double>(
//       begin: from.longitude,
//       end: to.longitude, // Destination longitude
//     );
//     final Animation<double> animation = CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeInOut,
//     );
//
//     animation.addListener(() {
//       final double latitude = latTween.evaluate(animation);
//       final double longitude = lngTween.evaluate(animation);
//       move(LatLng(latitude, longitude), 17);
//     });
//
//     animationController.forward(from: 0.0);
//   }
//
// }