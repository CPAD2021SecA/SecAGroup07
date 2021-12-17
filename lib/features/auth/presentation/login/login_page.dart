import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'auth.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/blocking_progress.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/scrollable_centered_sized_box.dart';
import '../../../../routing/app_pages.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BlockingProgress(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ScrollableCenteredSizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AppLogo(),
                  SizedBox(height: 30),
                  Text('LOGIN', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 30),
                  CustomTextField(
                    controller: controller.emailTextController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: controller.passwordTextController,
                    obscureText: true,
                    labelText: 'Password',
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _verifyLogin(),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.FORGOT_PASSWORD);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: MaterialButton(
                      color: Get.theme.accentColor,
                      onPressed: () => _verifyLogin(),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(color: Get.theme.backgroundColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buttonItem("assets/google.svg", "Continue with Google", 25,
                      () async {
                    await authClass.googleSignIn(context);
                  }),
                  SizedBox(height: 8),
                  Text('OR'),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: MaterialButton(
                        color: Colors.white,
                        onPressed: () {
                          Get.toNamed(Routes.SIGNUP);
                        },
                        child: Text(
                          'CREATE AN ACCOUNT',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonItem(
      String imagepath, String buttonName, double size, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyLogin() {
    controller.login();
  }
}
