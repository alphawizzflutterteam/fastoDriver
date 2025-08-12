import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pristine_andaman_driver/Auth/Login/UI/login_page.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen();

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      backgroundColor: Colors.white,
      duration: Duration(seconds: 5),
      onInit: () {
        debugPrint("On Init");
      },
      onEnd: () {
        debugPrint("On End");
      },
      splashScreenBody: Center(
        child: SizedBox(
          height: 250,
          width: 250,
          child: Image.asset("assets/splashlogo.png"),
        ),
      ),
      nextScreen: LoginPage(),
    );

    //   Container(
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   color: AppTheme.primaryColor,
    //   child: Center(child: Image.asset('assets/splashlogo.png')),
    // );
  }
}
