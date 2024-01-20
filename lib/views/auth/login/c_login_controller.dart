
import 'package:car_crash_list/views/auth/profile/profile_controller.dart';
import 'package:car_crash_list/views/auth/profile/profile_model.dart';
import 'package:car_crash_list/views/auth/register/v_register_page.dart';
import 'package:car_crash_list/views/home_main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/data_controller.dart';
import '../../../services/api_services.dart';
import '../../../utils/custom_dialog.dart';

class LoginController extends GetxController{
  TextEditingController txtPhone = TextEditingController(text: '');
  TextEditingController txtPassword = TextEditingController(text: '');


  String spPhoneKey = "spPhoneKey";
  String spPasswordKey = "spPasswordKey";

  @override
  void onInit() {
    super.onInit();
    initLoad();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> initLoad() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    txtPhone.text = sharedPreferences.getString(spPhoneKey)??'';
    txtPassword.text = sharedPreferences.getString(spPasswordKey)??'';
  }

  Future<void> onClickLogIn() async{
    if(txtPhone.text.isEmpty || txtPassword.text.isEmpty){
      MyDialog().showAlertDialog(message: 'Please fill all fields');
      return;
    }
    else{
      MyDialog().showLoadingDialog();
      Response? apiResponse;
      try{
        apiResponse = await ApiServices().apiPostCall(
            endPoint: ApiEndPoints.login,
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
            MyDialog().showLoadingDialog();;
            ProfileController profileController = Get.find();
            DataController dataController = Get.find();
            dataController.apiToken = apiResponse.body["body"]["token"].toString();
            profileController.currentProfile = ProfileModel.fromMap(data: apiResponse.body["body"]);
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            await sharedPreferences.setString(spPhoneKey, txtPhone.text);
            await sharedPreferences.setString(spPasswordKey, txtPassword.text);
            Get.offAll(()=> const HomeMainPage());
          }
          else{
            MyDialog().showAlertDialog(message: apiResponse.body["meta"]["message"].toString());
          }
        }
      }
      catch(e){
        MyDialog().showAlertDialog(message: 'Something went wrong!');
      }

    }
  }

  Future<void> onClickRegister() async{
    Get.to(()=> const RegisterPage());
  }

  Future<void> onClickEnterAsGuest() async{
    Get.offAll(()=> const HomeMainPage());
  }

}