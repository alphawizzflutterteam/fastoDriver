import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pristine_andaman_driver/Auth/Login/UI/login_page.dart';
import 'package:pristine_andaman_driver/Auth/Registration/UI/registration_ui.dart';
import 'package:pristine_andaman_driver/Auth/Verification/UI/verification_interactor.dart';
import 'package:pristine_andaman_driver/Components/button_custom.dart';
import 'package:pristine_andaman_driver/DrawerPages/Profile/my_profile.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/colors.dart';
import 'package:pristine_andaman_driver/utils/common.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/new_utils/ui.dart';

class VerificationUI extends StatefulWidget {
  final VerificationInteractor verificationInteractor;
  String mobile, otp, comeFrom;

  VerificationUI(
      this.verificationInteractor, this.mobile, this.otp, this.comeFrom);

  @override
  _VerificationUIState createState() => _VerificationUIState();
}

class _VerificationUIState extends State<VerificationUI> {
  final TextEditingController _otpController = TextEditingController();

  // @override
  // void dispose() {
  //   _otpController.dispose();
  //   super.dispose();
  // }

  var snackBar = SnackBar(
    content: Text('Can not Empty!'),
  );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "OTP VERIFICATION",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/otp_verify.png",
                    scale: 4,
                  ),
                  // SizedBox(width: 12),
                  // Text(
                  //   "Pristine\nAndaman",
                  //   style: TextStyle(
                  //       fontSize: 28, color: AppTheme.primaryColor),
                  // ),
                ],
              ),
            ),

            SizedBox(
              height: 40,
            ),
            Text(
              'Enter OTP',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 10),
            Text(
              '4 digit OTP has been sent to',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 10),
            Text(
              '${widget.mobile} OTP: ${widget.otp}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // SizedBox(height: 10),
            // Text(
            //   '${widget.otp}',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            SizedBox(
              height: 20,
            ),
            // EntryField(
            //   keyboardType: TextInputType.phone,
            //   maxLength: 4,
            //   controller: _otpController,
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                keyboardType: TextInputType.number,
                controller: _otpController,
                validator: (value) {
                  if (value!.length < 4) {
                    return "OTP length must be 4";
                  } else {
                    return null;
                  }
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.black,
                  inactiveFillColor: Colors.black,
                  selectedFillColor: Colors.black,
                  activeColor: Colors.black,
                  inactiveColor: Colors.black,
                  selectedColor: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            !loading
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: GestureDetector(
                            onTap: () {
                              if (_otpController.text.isEmpty ||
                                  _otpController.text.length != 4) {
                                UI.setSnackBar(
                                    "Please Enter Valid Otp", context);
                                return;
                              }
                              if (widget.comeFrom == "signIn") {
                                if (_otpController.text == widget.otp) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegistrationUI(
                                        widget.mobile.toString(),
                                      ),
                                    ),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Wrong Otp",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                  );
                                }
                                return;
                              }
                              if (widget.comeFrom == "login") {
                                if (_otpController.text != widget.otp) {
                                  UI.setSnackBar("Wrong Otp", context);
                                  return;
                                }
                                setState(() {
                                  loading = true;
                                });
                                loginUser();
                              }
                            },
                            child: ButtonCustom(
                              title: 'VERIFY OTP',
                            )),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          resendOtp();
                        },
                        child: Center(
                            child: Text(
                          'Resend Otp',
                          style: TextStyle(color: AppTheme.secondaryColor),
                        )),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  )
                : Center(
                    child: Container(
                        width: 50,
                        child: Center(child: CircularProgressIndicator())),
                  ),

            // Text('Don’t have an account? Sign Up',style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),),
            SizedBox()
          ],
        ),
      ),
    );
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
          "user_phone": widget.mobile.trim().toString(),
          "otp": widget.otp.toString(),
          "device_id": androidInfo.id.toString(),
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl + "verify_otp_driver"), data);
        print(response);
        bool status = true;
        String msg = response['message'];
        setState(() {
          loading = false;
        });

        if (response['status']) {
          UI.setSnackBar(msg, context, color: Colors.green);
          if (response['data']['is_active'].toString() == "1" &&
              response['data']['reject'].toString() == "1") {
            App.localStorage
                .setString("userProfileId", response['data']['id'].toString());
            curUserId = response['data']['id'].toString();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyProfilePage()),
                (route) => false);
          } else if (response['data']['is_active'].toString() == "0") {
            UI.setSnackBar(msg, context);
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
          }
          // else if(response['data']['is_active'].toString() == "1" && response['data']['reject'].toString() == "1"){
          //   Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(builder: (context) => MyProfilePage(
          //         isActive: response['data']['is_active'].toString(),
          //       )),
          //           (route) => false);
          // }
          else {
            App.localStorage
                .setString("userId", response['data']['id'].toString());
            curUserId = response['data']['id'].toString();
            Navigator.popAndPushNamed(context, "/");
            /*Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OfflinePage("")),
                (route) => false);*/
          }
        } else {}
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

  resendOtp() async {
    loading = true;
    setState(() {});
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        Map data;
        data = {
          "user_phone": widget.mobile,
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
          UI.setSnackBar('Resend Opt Successfully', context,
              color: Colors.green);
          widget.otp = response['otp'].toString();
          setState(() {});
          //navigateScreen(context, RegisterPage(_numberController.text.trim()));
          // navigateScreen(
          //     context,
          //     VerificationPage(_numberController.text.trim().toString(),
          //         response['otp'].toString()));
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
