import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pristine_andaman_driver/Api/constant.dart';
import 'package:pristine_andaman_driver/Components/button_custom.dart';
import 'package:pristine_andaman_driver/Provider/UserProvider.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/colors.dart';
import 'package:pristine_andaman_driver/utils/common.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/new_utils/ui.dart';
import 'package:provider/provider.dart';

import '../../../Model/GetSignInModel.dart';
import '../../Registration/UI/SignInScreen.dart';
import '../../Verification/UI/verification_page.dart';
import 'login_interactor.dart';
import 'login_page.dart';

class LoginUI extends StatefulWidget {
  final LoginInteractor loginInteractor;

  LoginUI(this.loginInteractor);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  // final TextEditingController _numberController =
  //     TextEditingController(text: '+91 9854596545');
  final _numberController = TextEditingController();
  String isoCode = '';

  var snackBar = SnackBar(
    content: Text('Can not Empty!'),
  );

  _signIn() async {
    // print("click");
    var user = Provider.of<UserProvider>(context, listen: false);
    if (_numberController.text.toString().isNotEmpty &&
        _numberController.text.toString().length > 9 &&
        _numberController.text.toString().length < 11) {
      GetSignInModel? model =
          await getSingIn(_numberController.text.toString());
      if (model!.status == true) {
        user.userId = model.data.toString();
        user.otp = model.otp.toString();
        user.mobileno = model.phone.toString();
        user.message = model.message.toString();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPage(
                _numberController.text.trim().toString(),
                model.otp.toString(),
                ''),
          ),
        );
        // widget.loginInteractor.loginWithMobile(isoCode, _numberController.text);
      } else {
        // Toast.show("${model.message}", duration: Toast.lengthShort, gravity:  Toast.bottom);
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Toast.show("Toast plugin app", duration: Toast.lengthShort, gravity:  Toast.bottom);
        // Fluttertoast.showToast(
        //     msg: "This is Center Short Toast",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0
        // );
      }
    } else if (_numberController.text.toString().length > 9 &&
        _numberController.text.toString().length < 11) {
      Fluttertoast.showToast(
          msg: "Please Enter Valid Mobile Number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Valid Mobile Number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // Toast.show("Toast plugin app", duration: Toast.lengthShort, gravity:  Toast.bottom);
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) / 1.0, //past 1.5
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/login_image.png", scale: 2),
                      // SizedBox(width: 12),
                      // Text("Pristine\nAndaman", style: TextStyle(fontSize: 28, color: AppTheme.primaryColor),),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: (MediaQuery.of(context).size.width) - 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Login To Your Account',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTheme.fontFamily),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 20.0),
                        //   child: Text(
                        //     'We will send you a confirmation code',
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.w500,
                        //       fontFamily: AppTheme.fontFamily,
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _numberController,
                          maxLength: 10,
                          decoration: InputDecoration(
                            fillColor: MyColorName.colorBg1,
                            counterText: "",
                            hintText: "Enter Number",
                            hintStyle: TextStyle(
                                color: MyColorName.secondary,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTheme.fontFamily,),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        !loading
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_numberController.text == "" ||
                                        _numberController.text.length != 10) {
                                      UI.setSnackBar(
                                          "Please Enter Valid Mobile Number",
                                          context);
                                      return;
                                    }
                                    setState(() {
                                      loading = true;
                                    });
                                    loginUser();
                                  },
                                  child: ButtonCustom(
                                    title: 'SEND OTP',
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  width: 50,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account? ",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppTheme.fontFamily,
                          fontWeight:
                          FontWeight.w500),),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => RegistrationUI(''),
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignIn(),
                          ),
                        );
                      },
                      child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            color: MyColorName.primaryLite,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontFamily,)
                      ),
                    ),
                  ],
                ),
                SizedBox()
              ],
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    // body:  FadedSlideAnimation(
    //       child:
    //   SingleChildScrollView(
    //     child: Container(
    //       color: AppTheme.primaryColor,
    //       height: MediaQuery.of(context).size.height,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           Spacer(flex: 5),
    //           Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 24),
    //             child: Text(
    //               getTranslated(context, Strings.ENTER_YOUR)! +
    //                   '\n' +
    //                   getTranslated(context, Strings.PHONE_NUMBER)!,
    //               style: theme.textTheme.headline4!.copyWith(color: Colors.white),
    //             ),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    //             child: Text(
    //               getTranslated(context, Strings.WILL_SEND_CODE)!,
    //               style: theme.textTheme.bodyText2!
    //                   .copyWith(color: Colors.white),
    //             ),
    //           ),
    //           Spacer(),
    //           Container(
    //             height: MediaQuery.of(context).size.height * 0.7,
    //             color: theme.backgroundColor,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 Spacer(),
    //                 EntryField(
    //                   maxLength: 10,
    //                   keyboardType: TextInputType.phone,
    //                   controller: _numberController,
    //                   label: getTranslated(context, Strings.ENTER_PHONE),
    //                 ),
    //                 Spacer(flex: 5),
    //                 !loading
    //                     ? CustomButton(
    //                   textColor: Colors.white,
    //                         onTap: () {
    //                           if (_numberController.text == "" ||
    //                               _numberController.text.length != 10) {
    //                             UI.setSnackBar(
    //                                 "Please Enter Valid Mobile Number",
    //                                 context);
    //                             return;
    //                           }
    //                           setState(() {
    //                             loading = true;
    //                           });
    //                           loginUser();
    //                         },
    //                       )
    //                     : Container(
    //                         width: 50,
    //                         child:
    //                             Center(child: CircularProgressIndicator())),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   beginOffset: Offset(0, 0.3),
    //   endOffset: Offset(0, 0),
    //   slideCurve: Curves.linearToEaseOut,
    // ),
    // );
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = false;

  loginUser() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        Map data;
        data = {
          "mobile": _numberController.text.trim().toString(),
          "fcm_id": fcmToken.toString(),
          "device_id": androidInfo.id.toString(),
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl + "send_otp_driver"), data);
        print(response);
        bool status = true;
        String msg = response['message'];
        setState(() {
          loading = false;
        });

        if (response['status']) {
          UI.setSnackBar(msg, context, color: Colors.green);
          //navigateScreen(context, RegisterPage(_numberController.text.trim()));
          navigateScreen(
              context,
              VerificationPage(_numberController.text.trim().toString(),
                  response['otp'].toString(), 'login'));
          // navigateScreen(context, VerificationPage(_numberController.text.trim()));
        } else {
          UI.setSnackBar(msg, context);
          if (msg.contains("Approve")) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Alert"),
                    content: Text("Wait For Admin Approval"),
                    actions: <Widget>[
                      ElevatedButton(
                          child: Text('OK'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                MyColorName.primaryLite),
                          ),
                          /* shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.transparent)),
                                textColor: Theme.of(context).colorScheme.primary,*/
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false);
                          }),
                    ],
                  );
                });
            /* showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Container(
                      padding: EdgeInsets.all(getWidth(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          text("Wait For Admin Approval",
                            fontFamily: fontMedium,
                            textColor: Colors.black,
                            isCentered:   true,
                            fontSize: 10.sp,),
                          boxHeight(20),
                          ElevatedButton(onPressed: (){
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                                    (route) => false);
                          }, child: text("OK", fontFamily: fontMedium,
                            textColor: Colors.white,
                            isCentered:   true,
                            fontSize: 10.sp,))
                        ],
                      ),),
                  );
                });*/
          } else {
            // navigateScreen(
            //     context, RegisterPage(_numberController.text.trim()));
          }
        }
      } on TimeoutException catch (_) {
        UI.setSnackBar("Something Went Wrong", context);
        setState(() {
          loading = false;
        });
      }
    } else {
      UI.setSnackBar("No Internet Connection", context);
      setState(() {
        loading = false;
      });
    }
  }
}
