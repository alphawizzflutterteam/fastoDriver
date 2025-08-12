import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:pristine_andaman_driver/DrawerPages/Settings/theme_cubit.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/colors.dart';
import 'package:pristine_andaman_driver/utils/common.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/new_utils/ui.dart';
import 'package:pristine_andaman_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';

class Address {
  String id, title, description;

  Address(this.id, this.title, this.description);
}

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late ThemeCubit _themeCubit;
  int? _themeValue;
  int? _languageValue;
  bool screenStatus = false;
  double lat = 0, lng = 0;
  @override
  void initState() {
    super.initState();
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  List<Address> ruleList = [];
  bool acceptStatus = false;
  addAddress() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "user_id": curUserId,
          "home_address": homeAddress,
          "longitude": lng.toString(),
          "latitude": lat.toString(),
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Authentication/home_address"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];
        UI.setSnackBar(msg, context);
        setState(() {
          acceptStatus = false;
        });
        if (response['status']) {
        } else {}
      } on TimeoutException catch (_) {
        UI.setSnackBar("Something Went Wrong", context);
      }
    } else {
      UI.setSnackBar("No Internet Connection", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          getTranslated(context, "Address")!,
          style: theme.textTheme.headlineSmall,
        ),
      ),
      body: FadedSlideAnimation(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: getWidth(25)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boxHeight(20),
              InkWell(
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PlacePicker(
                //         apiKey: Platform.isAndroid ? "" : "",
                //         onPlacePicked: (result) {
                //           print(result.formattedAddress);
                //           setState(() {
                //             homeAddress = result.formattedAddress.toString();
                //             lat = result.geometry!.location.lat;
                //             lng = result.geometry!.location.lng;
                //           });
                //           Navigator.of(context).pop();
                //         },
                //         initialPosition: LatLng(latitude, longitude),
                //         useCurrentLocation: true,
                //       ),
                //     ),
                //   );
                // },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      boxHeight(10),
                      text(getTranslated(context, "Address")!,
                          fontSize: 14.sp,
                          fontFamily: fontBold,
                          textColor: MyColorName.colorTextPrimary),
                      boxHeight(10),
                      text(
                          homeAddress == ""
                              ? getTranslated(context, "Taptoselectaddress")!
                              : getString1(homeAddress),
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: MyColorName.colorTextPrimary),
                    ],
                  ),
                ),
              ),
              boxHeight(20),
              InkWell(
                onTap: () {
                  if (homeAddress == "") {
                    UI.setSnackBar("Please Add Address", context);
                    return;
                  }
                  setState(() {
                    acceptStatus = true;
                  });
                  addAddress();
                },
                child: !acceptStatus
                    ? Container(
                        width: 80.w,
                        height: 5.h,
                        margin: EdgeInsets.all(getWidth(14)),
                        decoration: boxDecoration(
                            radius: 5, bgColor: Theme.of(context).primaryColor),
                        child: Center(
                            child: text(
                                getTranslated(context, "Update Address")!,
                                fontFamily: fontMedium,
                                fontSize: 10.sp,
                                isCentered: true,
                                textColor: Colors.white)),
                      )
                    : CircularProgressIndicator(),
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
