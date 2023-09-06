
import 'package:car_crash_list/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';


enum DialogType{
  warning,
  error,
  success,
  message
}

class DialogMeta{

  DialogType dialogType;
  String title;
  Color titleColor;

  DialogMeta({
    required this.dialogType,
    required this.title,
    required this.titleColor,
  });

}

class MyDialog{

  Map<DialogType,DialogMeta> dialogMetas = {
    DialogType.message : DialogMeta(
        title: 'Message'.tr,
        dialogType: DialogType.message,
        titleColor: AppColors.black
    ),
    DialogType.warning : DialogMeta(
        title: 'Warning'.tr,
        dialogType: DialogType.warning,
        titleColor: Colors.red
    ),
    DialogType.success : DialogMeta(
        title: 'Success'.tr,
        dialogType: DialogType.success,
        titleColor: AppColors.green1
    ),
    DialogType.error : DialogMeta(
        title: 'Error'.tr,
        dialogType: DialogType.error,
        titleColor: AppColors.green3
    ),
  };

  void showAlertDialog({
    required String message,
    DialogType dialogType = DialogType.message,
    bool xDismissible = true,
  }){
    DialogMeta dialogMeta = dialogMetas[dialogType]!;
    Get.dialog(
        AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            content: DialogWidget(
              message: message.tr,
              title: dialogMeta.title,
              titleColor: dialogMeta.titleColor,
            )
        ),
        barrierDismissible: xDismissible
    );
  }

  void showLoadingDialog(){
    DialogMeta dialogMeta = dialogMetas[DialogType.message]!;
    Get.dialog(
        AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            content: DialogWidget(
              message: 'Please Wait'.tr,
              title: dialogMeta.title,
              titleColor: dialogMeta.titleColor,
            )
        ),
        barrierDismissible: false
    );
  }

  void showServerErrorDialog(){
    DialogMeta dialogMeta = dialogMetas[DialogType.error]!;
    Get.dialog(
        AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            content: DialogWidget(
              message: 'Unable to connect to the server'.tr,
              title: dialogMeta.title,
              titleColor: dialogMeta.titleColor,
            )
        ),
        barrierDismissible: true
    );
  }

  // void showConfirmDialog(
  // {
  //   required String message,
  //   DialogType dialogType = DialogType.message,
  //   required Function() onSuccess
  // }){
  //   DialogMeta dialogMeta = dialogMetas[dialogType]!;
  //   Get.dialog(
  //       AlertDialog(
  //           contentPadding: const EdgeInsets.all(0),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(15)
  //           ),
  //           content: ConfirmDialogWidget(
  //             message: message,
  //             title: dialogMeta.title,
  //             titleColor: dialogMeta.titleColor,
  //             onConfirm: () {
  //               onSuccess();
  //             },
  //           )
  //       ),
  //       barrierDismissible: false
  //   );
  // }


  void showSnack({required Widget child,int durationInSec = 20}) async{

  }

  void showCustomSnack({required String text,int durationInSec = 3}) async{
   ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(text),
        )
    );
  }
}

class DialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final Color titleColor;
  const DialogWidget({Key? key,required this.title,required this.message,required this.titleColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: titleColor),),
            10.0.heightBox(),
            Text(message,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
          ],
        )
    );
  }
}

// class ConfirmDialogWidget extends StatelessWidget {
//   final String title;
//   final String message;
//   final Color titleColor;
//   final Function() onConfirm;
//   const ConfirmDialogWidget({Key? key,required this.title,required this.message,required this.titleColor,required this.onConfirm}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15)
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: titleColor),),
//             10.0.heightBox(),
//             Text(message,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
//             10.heightBox(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: TextButton(onPressed: () {
//                     Get.back();
//                   }, child: Text('Back'.tr,style: const TextStyle(fontWeight: FontWeight.w600,color: AppColors.greyColor,fontSize: 16),)),
//                 ),
//                 Expanded(
//                   child: TextButton(onPressed: () {
//                     onConfirm();
//                   }, child: Text('Confirm'.tr,style: const TextStyle(fontWeight: FontWeight.w600,color: AppColors.primaryColor,fontSize: 16),)),
//                 )
//               ],
//             )
//           ],
//         )
//     );
//   }
//
// }



