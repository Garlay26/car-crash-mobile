
import 'package:car_crash_list/services/api_services.dart';
import 'package:car_crash_list/utils/custom_dialog.dart';
import 'package:car_crash_list/views/auth/login/v_login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{
  TextEditingController txtPhone = TextEditingController(text: '');
  TextEditingController txtPassword = TextEditingController(text: '');
  TextEditingController txtConfirmPassword = TextEditingController(text: '');


  Future<void> onClickRegister() async{
    if(txtPhone.text.isEmpty || txtPassword.text.isEmpty || txtConfirmPassword.text.isEmpty){
      MyDialog().showAlertDialog(message: 'Please fill all fields');
      return;
    }
    else if(txtPassword.text != txtConfirmPassword.text){
      MyDialog().showAlertDialog(message: 'Passwords must be the same');
      return;
    }
    else{
      MyDialog().showLoadingDialog();
      Response? apiResponse;
      try{
         apiResponse = await ApiServices().apiPostCall(
            endPoint: ApiEndPoints.register,
            data: {
              "phoneNumber" : txtPhone.text,
              "password" : txtPassword.text
            },
            xNeedToken: false
        );
      }
      catch(e){
        null;
      }
      Get.back(canPop: false);

      try{
        if(apiResponse==null){
          MyDialog().showAlertDialog(message: 'Something went wrong!');
        }
        else{
          if(apiResponse.body["meta"]["status"]){
            Get.back();
            MyDialog().showAlertDialog(message: 'Register Success');
          }
          else{
            MyDialog().showAlertDialog(message: apiResponse.body["meta"]["message"].toString());
          }
        }
      }
      catch(e){
        MyDialog().showAlertDialog(message: 'Something went wrong!');
        Get.offAll(()=> const LoginPage());
      }

    }
  }

}