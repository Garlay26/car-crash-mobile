import 'package:car_crash_list/utils/extensions.dart';
import 'package:car_crash_list/views/auth/login/c_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 2,
        //   title: const Text("Car Crash List",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        // ),
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
                      Image.asset('assets/images/logo.png',width: Get.width * 0.3,),
                      10.heightBox(),
                      const Text('Please Log In To Continue'),
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
                      15.heightBox(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.onClickLogIn();
                          },
                          child: const Text("Log In"),
                        ),
                      ),
                      10.heightBox(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            controller.onClickRegister();
                          },
                          child: const Text("Register Now",style: TextStyle(fontSize: 18),),
                        ),
                      ),
                      10.heightBox(),
                      const Text("Or",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                      10.heightBox(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            controller.onClickEnterAsGuest();
                          },
                          child: const Text("Enter as guest",style: TextStyle(color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold,fontSize: 18),),
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
