import 'package:car_crash_list/utils/extensions.dart';
import 'package:car_crash_list/views/auth/login/c_login_controller.dart';
import 'package:car_crash_list/views/auth/register/c_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text("Register",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.1,
            vertical: 15
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: controller.txtPhone,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Username'
                        ),
                      ),
                      5.heightBox(),
                      TextField(
                        controller: controller.txtPassword,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password'
                        ),
                      ),
                      5.heightBox(),
                      TextField(
                        controller: controller.txtConfirmPassword,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password'
                        ),
                      ),
                      15.heightBox(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.onClickRegister();
                          },
                          child: const Text("Register"),
                        ),
                      ),
                      10.heightBox(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Back"),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
