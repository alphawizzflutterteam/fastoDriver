import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pristine_andaman_driver/DrawerPages/Rides/start_garage.dart';
import 'package:pristine_andaman_driver/Model/my_ride_model.dart';
import 'package:pristine_andaman_driver/Model/reason_model.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/PushNotificationService.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/colors.dart';
import 'package:pristine_andaman_driver/utils/common.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/new_utils/ui.dart';
import 'package:pristine_andaman_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

Timer? timer;

class RideInfoNew extends StatefulWidget {
  MyRideModel model;
  String? check;
  int updateIndex = 0;
  int? statusIndex;
  int complete;

  RideInfoNew(this.model,
      {this.check, this.statusIndex, required this.complete});

  @override
  State<RideInfoNew> createState() => _RideInfoNewState();
}

class _RideInfoNewState extends State<RideInfoNew> with WidgetsBindingObserver {
  DateTime? currentBackPressTime;
  bool condition = false;
  bool fromGarage = false;
  File? startMeterImg;
  File? endMeterImg;

  Future<bool> onWill() async {
    DateTime now = DateTime.now();
    print(widget.model.bookingType.toString());
    if (widget.model.acceptReject == "3" ||
        !(widget.model.bookingType).toString().contains("Point")) {
      Navigator.pop(context);
    } else {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Common().toast("Can't Exit");
        return Future.value(false);
      }
      exit(1);
    }
    return Future.value();
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool acceptStatus = false;
  TextEditingController otpController = TextEditingController();
  TextEditingController odoMeterController = TextEditingController();
  TextEditingController parkingController = TextEditingController();
  TextEditingController tolltaxController = TextEditingController();
  TextEditingController railwayController = TextEditingController();
  TextEditingController nightChargeController = TextEditingController();
  TextEditingController stateChargeController = TextEditingController();

  bookingStatus(String bookingId, status1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        // var request = http.MultipartRequest(
        //   'POST',
        //   Uri.parse(baseUrl1 + "payment/complete_ride_driver"),
        // );
        // Map<String, String> headers = {
        //   "token": App.localStorage.getString("token").toString(),
        //   "Content-type": "multipart/form-data"
        // };
        // if (startMeterImg != null)
        // request.files.add(
        //   http.MultipartFile(
        //     'end_meter',
        //     startMeterImg!.readAsBytes().asStream(),
        //     startMeterImg!.lengthSync(),
        //     filename: path.basename(startMeterImg!.path),
        //     contentType: MediaType('image', 'jpeg'),
        //   ),
        // );
        // request.headers.addAll(headers);
        // request.fields.addAll({
        //   "driver_id": curUserId.toString(),
        //   "accept_reject": status1.toString(),
        //   "booking_id": bookingId,
        //   "otp": otpController.text.toString(),
        // });
        // print("request: " + request.toString());
        // print("para: " + request.fields.toString());
        // var res = await request.send();
        // print("This is response:" + res.toString());
        // var response = jsonDecode(res.stream.bytesToString().toString());
        Map data;
        data = {
          "driver_id": curUserId,
          "accept_reject": status1.toString(),
          "booking_id": bookingId,
          "otp": otpController.text.toString(),
          "parking_charges":
              parkingController.text == "0" || parkingController.text == 0
                  ? "0"
                  : parkingController.text,
          "toll_tax_charges":
              tolltaxController.text == "0" || tolltaxController.text == 0
                  ? "0"
                  : tolltaxController.text,
          "airport_railway_entry_charges":
              railwayController.text == "0" || railwayController.text == 0
                  ? "0"
                  : railwayController.text,
          "night_charge": nightChargeController.text == "0" ||
                  nightChargeController.text == 0
              ? "0"
              : nightChargeController.text,
          "state_tax_charge": stateChargeController.text == "0" ||
                  stateChargeController.text == 0
              ? "0"
              : stateChargeController.text,
        };
        print("COMPLETE RIDE with charge para=== $data");
        // return;
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "payment/complete_ride_driver"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        UI.setSnackBar(msg, context);
        if (response['status']) {
          setState(() {
            saveStatus = true;
          });
          updatebookingStatus((widget.model.bookingId).toString(), '4');
          // Navigator.pop(context, true);
          // showDialog(
          //     context: context,
          //     builder: (context) => CompleteRideDialog(widget.model));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => MyRidesPage(selected: true)));
          // remainAmountPopup();
          getSingleBooking();
        } else {}
      } on TimeoutException catch (_) {
        setState(() {
          saveStatus = true;
        });
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setState(() {
        saveStatus = true;
      });
      setSnackbar("No Internet Connection", context);
    }
  }

  startRideOtp(String bookingId, status1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        // var request = http.MultipartRequest(
        //   'POST',
        //   Uri.parse(baseUrl1 + "Payment/start_ride"),
        // );
        // Map<String, String> headers = {
        //   "token": App.localStorage.getString("token").toString(),
        //   "Content-type": "multipart/form-data"
        // };
        // if (startMeterImg != null)
        //   request.files.add(
        //     http.MultipartFile(
        //       'start_meter',
        //       startMeterImg!.readAsBytes().asStream(),
        //       startMeterImg!.lengthSync(),
        //       filename: path.basename(startMeterImg!.path),
        //       contentType: MediaType('image', 'jpeg'),
        //     ),
        //   );
        // request.headers.addAll(headers);
        // request.fields.addAll({
        //   "driver_id": curUserId.toString(),
        //   "accept_reject": status1.toString(),
        //   "booking_id": bookingId,
        //   "otp": otpController.text.toString(),
        //   "odometer": odoMeterController.toString(),
        // });
        // print("request: " + request.toString());
        // print("para: " + request.fields.toString());
        // var res = await request.send();
        // print("This is response:" + res.toString());
        // var response = jsonDecode(res.stream.bytesToString().toString());
        Map data;
        data = {
          "driver_id": curUserId,
          "accept_reject": status1.toString(),
          "booking_id": bookingId,
          "otp": otpController.text.toString(),
        };
        print("Start Ride ==== $data");
        // return;
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Payment/start_ride"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        //Navigator.pop(context);
        if (response['status']) {
          setState(() {
            saveStatus = true;
            widget.model.acceptReject = "6";
            updatebookingStatus((widget.model.bookingId).toString(), '3');
          });
        } else {}
      } on TimeoutException catch (_) {
        setState(() {
          saveStatus = true;
        });
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setState(() {
        saveStatus = true;
      });
      setSnackbar("No Internet Connection", context);
    }
  }

  startRide(String bookingId, status1) async {
    otpController.text = "";
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                margin: EdgeInsets.all(16),
                height: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Start Ride",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? pickedFile = await _picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              startMeterImg = File(pickedFile.path);
                            });
                          }
                        },
                        child: startMeterImg == null
                            ? Icon(Icons.camera_alt_outlined,
                                size: 60, color: Colors.grey)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  startMeterImg!,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                  // width: double.infinity, // Ensure full width image display
                                ),
                              )),
                    const SizedBox(height: 12),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: "Odometer",
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      controller: odoMeterController,
                    ),
                    // const SizedBox(height: 12),
                    // Text("Enter OTP given by user", style: TextStyle(color: Colors.grey),),
                    const SizedBox(height: 12),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: "OTP here",
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      controller: otpController,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       primary: Theme.of(context)
                        //           .primaryColor),
                        //   child: Text("Back",
                        //     style: TextStyle(
                        //         color: Colors.black
                        //     ),),
                        //   onPressed: () async{
                        //     // setState((){
                        //     //   acceptStatus = false;
                        //     // });
                        //    Navigator.pop(context);
                        //   },
                        // ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppTheme.secondaryColor,
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (otpController.text.isNotEmpty &&
                                odoMeterController.text.isNotEmpty) {
                              Navigator.pop(context);
                              setState(() {
                                // acceptStatus = true;
                              });
                              _updateOdometer(startMeterImg, 'start_meter')
                                  .then((value) =>
                                      startRideOtp(bookingId, status1));
                            } else {
                              setState(() {
                                acceptStatus = false;
                              });
                              Fluttertoast.showToast(msg: "OTP is required");
                              // Fluttertoast.showToast(msg: "Valid detail is required");
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return Padding(
    //         padding: const EdgeInsets.only(top: 200.0),
    //         child: Dialog(
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(15)),
    //           // title: Text("Start Ride"),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 "Start Ride",
    //                 style: TextStyle(
    //                   fontSize: 24,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 15,
    //               ),
    //               Text("Enter OTP given by user"),
    //               Padding(
    //                 padding: const EdgeInsets.only(
    //                     top: 15, bottom: 15, left: 15.0, right: 15),
    //                 child: TextFormField(
    //                   keyboardType: TextInputType.number,
    //                   maxLength: 6,
    //                   decoration: InputDecoration(
    //                       counterText: "",
    //                       hintText: "OTP here",
    //                       border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(10))),
    //                   controller: otpController,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 15.0, right: 15),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     // ElevatedButton(
    //                     //   style: ElevatedButton.styleFrom(
    //                     //       primary: Theme.of(context)
    //                     //           .primaryColor),
    //                     //   child: Text("Back",
    //                     //     style: TextStyle(
    //                     //         color: Colors.black
    //                     //     ),),
    //                     //   onPressed: () async{
    //                     //     // setState((){
    //                     //     //   acceptStatus = false;
    //                     //     // });
    //                     //    Navigator.pop(context);
    //                     //   },
    //                     // ),
    //                     ElevatedButton(
    //                       style: ElevatedButton.styleFrom(
    //                           backgroundColor: Theme.of(context).primaryColor),
    //                       child: Text(
    //                         "Submit",
    //                         style: TextStyle(color: Colors.black),
    //                       ),
    //                       onPressed: () async {
    //                         if (otpController.text.isNotEmpty &&
    //                             otpController.text.length >= 4) {
    //                           Navigator.pop(context);
    //                           setState(() {
    //                             acceptStatus = true;
    //                           });
    //                           startRideOtp(bookingId, status1);
    //                         } else {
    //                           setState(() {
    //                             acceptStatus = false;
    //                           });
    //                           Fluttertoast.showToast(msg: "OTP is required");
    //                         }
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               )
    //             ],
    //           ),
    //           // actions: <Widget>[
    //           //   ElevatedButton(
    //           //     style: ElevatedButton.styleFrom(
    //           //         primary: Theme.of(context)
    //           //             .primaryColor
    //           //     ),
    //           //     child: Text("Submit"),
    //           //     onPressed: () async{
    //           //       startRideOtp(bookingId, status1);
    //           //     },
    //           //   ),
    //           //
    //           // ],
    //         ),
    //       );
    //     });
    //
  }

  final _formKey = GlobalKey<FormState>();

  completeRide(String bookingId, status1) async {
    otpController.text = "";
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 600,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Complete Ride",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.camera,
                            );
                            if (pickedFile != null) {
                              setState(() {
                                endMeterImg = File(pickedFile.path);
                              });
                            }
                          },
                          child: endMeterImg == null
                              ? Icon(Icons.camera_alt_outlined,
                                  size: 40, color: Colors.grey)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    endMeterImg!,
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    // width: double.infinity, // Ensure full width image display
                                  ),
                                )),
                      const SizedBox(height: 12),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter odometer';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "Odometer",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: odoMeterController,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter otp';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            counterText: "",
                            hintText: "OTP here",
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        controller: otpController,
                      ),
                      const SizedBox(height: 8),
                      widget.model.isParking == "1"
                          ? TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter parking charge';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Parking Charge",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: parkingController,
                            )
                          : SizedBox(),
                      const SizedBox(height: 8),
                      widget.model.tollTax == "1"
                          ? TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter toll tax';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Toll tax",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: tolltaxController,
                            )
                          : SizedBox(),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter railway/airport charge';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "Railway/Airport Entry Charge",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: railwayController,
                      ),
                      const SizedBox(height: 8),
                      widget.model.isNightCharge == "1"
                          ? TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Night charge';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Night Charge",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: nightChargeController,
                            )
                          : SizedBox(),
                      const SizedBox(height: 8),
                      widget.model.isStateTax == "1"
                          ? TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'State charge';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "State Charge",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: stateChargeController,
                            )
                          : SizedBox(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //       primary: Theme.of(context)
                          //           .primaryColor),
                          //   child: Text("Back",
                          //     style: TextStyle(
                          //         color: Colors.black
                          //     ),),
                          //   onPressed: () async{
                          //     // setState((){
                          //     //   acceptStatus = false;
                          //     // });
                          //    Navigator.pop(context);
                          //   },
                          // ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppTheme.secondaryColor,
                            ),
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (otpController.text.isNotEmpty &&
                                    odoMeterController.text.isNotEmpty) {
                                  Navigator.pop(context);
                                  setState(() {
                                    acceptStatus = true;
                                  });

                                  ///update odomeret api here
                                  _updateOdometer(endMeterImg, "end_meter")
                                      .then((value) =>
                                          bookingStatus(bookingId, status1));
                                } else {
                                  setState(() {
                                    acceptStatus = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "OTP is required");
                                  // Fluttertoast.showToast(msg: "Valid detail is required");
                                }
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    // showDialog(
    //     context: context,
    //     // barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         child: Container(
    //           margin: EdgeInsets.all(16),
    //           height: 240,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
    //           ),
    //           width: double.infinity,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 "Complete Ride",
    //                 style: TextStyle(
    //                   fontSize: 20,
    //                 ),
    //               ),
    //               const SizedBox(height: 4),
    //               Text("Enter OTP given by user", style: TextStyle(color: Colors.grey)),
    //               const SizedBox(height: 12),
    //               TextFormField(
    //                 keyboardType: TextInputType.number,
    //                 maxLength: 6,
    //                 decoration: InputDecoration(
    //                     counterText: "",
    //                     hintText: "OTP here",
    //                     isDense: true,
    //                     border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(10),),),
    //                 controller: otpController,
    //               ),
    //               const SizedBox(height: 20),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   // ElevatedButton(
    //                   //   style: ElevatedButton.styleFrom(
    //                   //       primary: Theme.of(context)
    //                   //           .primaryColor),
    //                   //   child: Text("Back",
    //                   //     style: TextStyle(
    //                   //         color: Colors.black
    //                   //     ),),
    //                   //   onPressed: () async{
    //                   //     // setState((){
    //                   //     //   acceptStatus = false;
    //                   //     // });
    //                   //    Navigator.pop(context);
    //                   //   },
    //                   // ),
    //
    //                   ElevatedButton(
    //                     style: ElevatedButton.styleFrom(
    //                       elevation: 0,
    //                       backgroundColor: AppTheme.secondaryColor),
    //                     child: Text(
    //                       "Submit",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     onPressed: () async {
    //                                             if (otpController.text.isNotEmpty &&
    //                                                   otpController.text.length >= 4) {
    //                                                 Navigator.pop(context);
    //                                                 setState(() {
    //                                                   acceptStatus = false;
    //                                                 });
    //                                                 bookingStatus(bookingId, status1);
    //                                               } else {
    //                                                 setState(() {
    //                                                   acceptStatus = false;
    //                                                 });
    //                                                 Fluttertoast.showToast(msg: "OTP is required");
    //                                                 Navigator.pop(context);
    //                                               }
    //                     },
    //                   ),
    //                 ],
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  cancelStatus(String bookingId, status1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "type": "schedule_booking",
          "driver_id": curUserId,
          "accept_reject": "5",
          "booking_id": bookingId,
          "reason": reasonList[indexReason].reason,
        };
        print("cancel_ride Ride ==== $data");
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "payment/cancel_ride_user_driver"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        if (response['status']) {
          Navigator.pop(context);
          Navigator.pop(context, true);
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  Future<void> _updateOdometer(File? Img, String imgType) async {
    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      setState(() {
        saveStatus = false;
      });
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "https://bikebooking.alphawizzserver.com/api/payment/update_booking_status_images"),
        );
        Map<String, String> headers = {
          "token": App.localStorage.getString("token").toString(),
          "Content-type": "multipart/form-data"
        };
        request.headers.addAll(headers);
        request.fields.addAll({
          // "user_id": curUserId.toString(),
          'booking_id': (widget.model.bookingId).toString(),
          'text': odoMeterController.text.toString(),
          'type': imgType.toString(),
        });
        if (Img != null)
          request.files.add(
            http.MultipartFile(
              'image',
              Img.readAsBytes().asStream(),
              Img.lengthSync(),
              filename: path.basename(Img.path),
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        // if (vehicleFront != null)
        //   request.files.add(
        //     http.MultipartFile(
        //       'vehicle_front',
        //       vehicleFront!.readAsBytes().asStream(),
        //       vehicleFront!.lengthSync(),
        //       filename: path.basename(vehicleFront!.path),
        //       contentType: MediaType('image', 'jpeg'),
        //     ),
        //   );
        // if (vehicleBack != null)
        //   request.files.add(
        //     http.MultipartFile(
        //       'vehicle_back',
        //       vehicleBack!.readAsBytes().asStream(),
        //       vehicleBack!.lengthSync(),
        //       filename: path.basename(vehicleBack!.path),
        //       contentType: MediaType('image', 'jpeg'),
        //     ),
        //   );
        // if (vehicleImg != null)
        //   request.files.add(
        //     http.MultipartFile(
        //       'vehicle',
        //       vehicleImg!.readAsBytes().asStream(),
        //       vehicleImg!.lengthSync(),
        //       filename: path.basename(vehicleImg!.path),
        //       contentType: MediaType('image', 'jpeg'),
        //     ),
        //   );
        print("odo meter: " + request.toString());
        http.StreamedResponse res = await request.send();
        print("This is response:" + res.toString());
        // setState(() {
        //   loading = false;
        // });
        print("${res.statusCode}");
        if (res.statusCode == 200) {
          final respStr = await res.stream.bytesToString();
          print("This is response:" + respStr.toString());
          Map data = jsonDecode(respStr.toString());

          if (data['status']) {
            //  Map info = data['data'];
            setSnackbar(data['message'].toString(), context);
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => LoginPage()),
            //         (route) => false);
          } else {
            setSnackbar(data['message'].toString(), context);
          }
        }
        odoMeterController.clear();
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
        // setState(() {
        //   loading = true;
        // });
      }
    } else {
      setSnackbar("No Internet Connection", context);
      // setState(() {
      //   loading = true;
      // });
    }
  }

  updatebookingStatus(String bookingId, String driverStatus) async {
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      setState(() {
        saveStatus = false;
      });
      try {
        Map data;
        data = {"booking_id": bookingId, "driver_status": driverStatus};

        print("COMPLETE RIDE === $data");
        // return;
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "payment/update_driver_booking_status"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        UI.setSnackBar(msg, context);
        if (response['status']) {
          setState(() {
            saveStatus = true;
          });
          getBookingDetail();
          // Navigator.pop(context, true);
          // showDialog(
          //     context: context,
          //     builder: (context) => CompleteRideDialog(widget.model));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => MyRidesPage(selected: true)));
        } else {}
      } on TimeoutException catch (_) {
        setState(() {
          saveStatus = true;
        });
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setState(() {
        saveStatus = true;
      });
      setSnackbar("No Internet Connection", context);
    }
  }

  remainAmountPopup() async {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                margin: EdgeInsets.all(16),
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Row(
                    //   mainAxisAlignment:
                    //   MainAxisAlignment.spaceAround,
                    //   children: [
                    //     text("Remaining Amount : ",
                    //         fontSize: 10.sp,
                    //         fontFamily: fontMedium,
                    //         textColor: Colors.black),
                    //     text("₹${(double.parse(widget.model.finalTotal.toString()) - double.parse(widget.model.paidAmount.toString())).toStringAsFixed(2)}",
                    //         fontSize: 10.sp,
                    //         fontFamily: fontMedium,
                    //         textColor: Colors.black),
                    //   ],
                    // ),

                    const SizedBox(height: 5),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (parkingController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Fill Parking Charge");
                            } else if (tolltaxController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Fill Toll Tax");
                            } else if (railwayController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Please Fill railway/Airport Entry Charge");
                            } else {
                              Navigator.pop(context);
                            }
                            // setState((){
                            //   acceptStatus = false;
                            // });

                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    // showDialog(
    //     context: context,
    //     // barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         child: Container(
    //           margin: EdgeInsets.all(16),
    //           height: 240,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
    //           ),
    //           width: double.infinity,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 "Complete Ride",
    //                 style: TextStyle(
    //                   fontSize: 20,
    //                 ),
    //               ),
    //               const SizedBox(height: 4),
    //               Text("Enter OTP given by user", style: TextStyle(color: Colors.grey)),
    //               const SizedBox(height: 12),
    //               TextFormField(
    //                 keyboardType: TextInputType.number,
    //                 maxLength: 6,
    //                 decoration: InputDecoration(
    //                     counterText: "",
    //                     hintText: "OTP here",
    //                     isDense: true,
    //                     border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(10),),),
    //                 controller: otpController,
    //               ),
    //               const SizedBox(height: 20),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   // ElevatedButton(
    //                   //   style: ElevatedButton.styleFrom(
    //                   //       primary: Theme.of(context)
    //                   //           .primaryColor),
    //                   //   child: Text("Back",
    //                   //     style: TextStyle(
    //                   //         color: Colors.black
    //                   //     ),),
    //                   //   onPressed: () async{
    //                   //     // setState((){
    //                   //     //   acceptStatus = false;
    //                   //     // });
    //                   //    Navigator.pop(context);
    //                   //   },
    //                   // ),
    //
    //                   ElevatedButton(
    //                     style: ElevatedButton.styleFrom(
    //                       elevation: 0,
    //                       backgroundColor: AppTheme.secondaryColor),
    //                     child: Text(
    //                       "Submit",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     onPressed: () async {
    //                                             if (otpController.text.isNotEmpty &&
    //                                                   otpController.text.length >= 4) {
    //                                                 Navigator.pop(context);
    //                                                 setState(() {
    //                                                   acceptStatus = false;
    //                                                 });
    //                                                 bookingStatus(bookingId, status1);
    //                                               } else {
    //                                                 setState(() {
    //                                                   acceptStatus = false;
    //                                                 });
    //                                                 Fluttertoast.showToast(msg: "OTP is required");
    //                                                 Navigator.pop(context);
    //                                               }
    //                     },
    //                   ),
    //                 ],
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  List<ReasonModel> reasonList = [];

  getReason() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "type": "Driver",
        };
        print("cancel_ride Reason ==== $data");
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "payment/cancel_ride_reason"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        if (response['status']) {
          for (var v in response['data']) {
            setState(() {
              reasonList.add(new ReasonModel.fromJson(v));
            });
          }
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("alsdfajklfjakfsd ${widget.complete}");
    getBookingDetail();
    WidgetsBinding.instance.addObserver(this);
    PushNotificationService pushNotificationService =
        new PushNotificationService(
            context: context,
            onResult: (result) {
              widget.updateIndex++;
              print("result" + result);
              if (result == "update") {
                setState(() {
                  saveStatus = false;
                });
                getCurrentInfo();
              } else if (result == "cancelled") {
                setState(() {
                  saveStatus = false;
                });
                getCurrentInfo();
              }
            });
    pushNotificationService.initialise();
    if (widget.check != null) {
      showMore = !showMore;
    } else {
      getReason();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RideInfoNew oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.updateIndex != widget.updateIndex) {
      getCurrentInfo();
    }
  }

  bool background = false;

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       if (background) {
  //         background = false;
  //         getCurrentInfo();
  //         print("app in resumed from background");
  //       }
  //       //you can add your codes here
  //       break;
  //     case AppLifecycleState.inactive:
  //       background = true;
  //       print("app is in inactive state");
  //       break;
  //     case AppLifecycleState.paused:
  //       background = true;
  //       print("app is in paused state");
  //       break;
  //     case AppLifecycleState.detached:
  //       background = true;
  //       print("app has been removed");
  //       break;
  //     case AppLifecycleState.hidden:
  //       background = true;
  //       print("app has been hidden");
  //       // TODO: Handle this case.
  //       break;
  //   }
  // }

  bool saveStatus = true;

  getCurrentInfo() async {
    try {
      Map params = {
        "driver_id": curUserId,
      };
      print("GET DRIVER BOOKING RIDE ====== $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/get_driver_booking_ride"), params);
      if (mounted)
        setState(() {
          saveStatus = true;
        });
      if (response['status']) {
        var v = response["data"][0];
        if (mounted)
          setState(() {
            widget.model = MyRideModel.fromJson(v);
          });
      } else {
        if (mounted) {
          setState(() {
            condition = true;
          });
          Navigator.pop(context, true);
        }
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  SingleRideModel? detailModel;
  getSingleBooking() async {
    setState(() {
      saveStatus = false;
    });
    try {
      var headers = {'Cookie': 'ci_session=o939pk13gr3sn6bipbs6bb6grm09jg8g'};
      var request = http.MultipartRequest(
          'POST', Uri.parse(baseUrl1 + "payment/get_single_booking"));
      request.fields.addAll({
        "booking_id": widget.model.bookingId.toString(),
      });

      request.headers.addAll(headers);

      print("GET SINGLE BOOKING DETAILS ====== $request");

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          saveStatus = true;
        });
        // print(await response.stream.bytesToString());
        final str = await response.stream.bytesToString();
        print("SINGLE BOOKING DETAILS RESPONSE ====== $str");
        setState(() {
          detailModel = SingleRideModel.fromJson(json.decode(str));
          print('$imagePath');
        });
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  getBookingDetail() async {
    setState(() {
      saveStatus = false;
    });
    try {
      Map params = {
        "driver_id": curUserId,
        "booking_id": widget.model.bookingId,
      };
      print("GET BOOKING DETAILS ====== $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/get_all_complete_single"), params);
      if (mounted)
        setState(() {
          saveStatus = true;
        });
      if (response['status']) {
        var v = response["data"][0];
        if (mounted)
          setState(() {
            widget.model = MyRideModel.fromJson(v);
          });
      } else {
        if (mounted) {
          setState(() {
            condition = true;
          });
          Navigator.pop(context, true);
        }
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  bool showMore = true;
  int indexReason = 0;
  PersistentBottomSheetController? persistentBottomSheetController1;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  showBottom1() async {
    persistentBottomSheetController1 =
        await scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        decoration:
            boxDecoration(radius: 0, showShadow: true, color: Colors.white),
        padding: EdgeInsets.all(getWidth(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            boxHeight(20),
            text("Select Reason",
                textColor: MyColorName.colorTextPrimary,
                fontSize: 12.sp,
                fontFamily: fontBold),
            boxHeight(20),
            reasonList.length > 0
                ? Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: reasonList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              persistentBottomSheetController1!.setState!(() {
                                indexReason = index;
                              });
                              // Navigator.pop(context);
                            },
                            child: Container(
                              color: indexReason == index
                                  ? MyColorName.primaryLite.withOpacity(0.2)
                                  : Colors.white,
                              padding: EdgeInsets.all(getWidth(10)),
                              child: text(reasonList[index].reason.toString(),
                                  textColor: MyColorName.colorTextPrimary,
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  isLongText: true),
                            ),
                          );
                        }),
                  )
                : SizedBox(),
            boxHeight(20),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: !acceptStatus
                      ? Container(
                          width: 35.w,
                          height: 5.h,
                          margin: EdgeInsets.all(getWidth(14)),
                          decoration: boxDecoration(
                              radius: 5,
                              bgColor: Theme.of(context).primaryColor),
                          child: Center(
                              child: text("Back",
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        )
                      : CircularProgressIndicator(),
                ),
                boxWidth(10),
                InkWell(
                  onTap: () {
                    persistentBottomSheetController1!.setState!(() {
                      acceptStatus = true;
                    });
                    cancelStatus(widget.model.bookingId!, "5");
                  },
                  child: !acceptStatus
                      ? Container(
                          width: 35.w,
                          height: 5.h,
                          margin: EdgeInsets.all(getWidth(14)),
                          decoration: boxDecoration(
                              radius: 5,
                              bgColor: Theme.of(context).primaryColor),
                          child: Center(
                              child: text("Continue",
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        )
                      : CircularProgressIndicator(),
                ),
              ],
            ),
            boxHeight(40),
          ],
        ),
      );
    });
  }

  File? _image;

  Future<void> _getImageFromCamera() async {
    // Using ImagePickerGalleryCamera to capture from camera
    // final pickedFile = await ImagePickerGC.pickImage(
    //   context: context,
    //   source: ImgSource.Camera, // Camera source
    //   cameraIcon: Icon(Icons.camera_alt), // Camera icon customization
    // );

    // if (pickedFile != null) {
    //   setState(() {
    //     _image = File(pickedFile.path);
    //   });
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (_) => selfieDialog()
    // );
    // }
    // showDialog(
    //   context: context,
    //   builder: (_) => SelfieDialog(), // To re-open the dialog with updated image
    // );
  }

  selfieDialog() {
    return AlertDialog(
      title: Text('Capture Selfie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Would you like to take a selfie?'),
          SizedBox(height: 20),
          _image != null
              ? Image.file(_image!, height: 120, width: 120, fit: BoxFit.cover)
              : Icon(Icons.camera_alt, size: 80, color: Colors.grey),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _getImageFromCamera();
          },
          child: Text('Take Selfie'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  bool isGarage = false;

  @override
  Widget build(BuildContext context) {
    print(
        "USER IMAGE====== $imagePath${widget.model.userImage.toString().split("/").last}");
    var theme = Theme.of(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWill,
        child: RefreshIndicator(
          onRefresh: () async {
            await getBookingDetail();
          },
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppTheme.primaryColor,
                centerTitle: true,
                title: Text(
                  "Ride Details",
                  style: theme.textTheme.headlineSmall!
                      .copyWith(color: Colors.white),
                ),
              ),
              body: saveStatus
                  ? Container(
                      color: Colors.white,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: widget.check != null
                                ? MainAxisSize.max
                                : MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Container(
                                // width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade300)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          ///image
                                          // Padding(
                                          //   padding: const EdgeInsets.all(10.0),
                                          //   child: ClipRRect(
                                          //     borderRadius:
                                          //     BorderRadius.circular(8),
                                          //     child: Container(
                                          //         height: getWidth(80),
                                          //         width: getWidth(80),
                                          //         decoration: boxDecoration(
                                          //             radius: 10,
                                          //             color: Colors.grey),
                                          //         child: Image.network(
                                          //           imagePath +
                                          //               rideList[index]
                                          //                   .userImage
                                          //                   .toString(),
                                          //           height: getWidth(80),
                                          //           width: getWidth(80),
                                          //         )),
                                          //   ),
                                          // ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getString1(widget
                                                          .model.username
                                                          .toString()),
                                                      style: theme.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 16),
                                                    ),
                                                    Text(
                                                      'Trip ID-${getString1(widget.model.uneaqueId.toString())}',
                                                      style: theme
                                                          .textTheme.titleSmall,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    Card(
                                                      margin: EdgeInsets.zero,
                                                      elevation: 0,
                                                      color:
                                                          Colors.grey.shade100,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Text(
                                                          '${widget.model.vehicleNo}',
                                                          // "Hatchback",
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .primaryColor,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      getString1(widget
                                                          .model.status
                                                          .toString()),
                                                      style: theme.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                widget.model.orderType ==
                                                            null ||
                                                        widget.model
                                                                .orderType ==
                                                            'null'
                                                    ? SizedBox()
                                                    : Text(
                                                        '${widget.model.orderType ?? ''}',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Pick Date - ${widget.model.pickupDate} ${widget.model.pickupTime}',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                ),

                                                widget.model.returnDate ==
                                                            null ||
                                                        widget.model
                                                                .returnDate ==
                                                            "" ||
                                                        widget.model
                                                                .returnDate ==
                                                            "false"
                                                    ? SizedBox()
                                                    : Text(
                                                        'Return Date - ${widget.model.returnDate}',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                widget.model.hours == null ||
                                                        widget.model.hours ==
                                                            "null"
                                                    ? SizedBox()
                                                    : Text(
                                                        'Hour - ${widget.model.hours}',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontSize: 14),
                                                      ),
                                                // SizedBox(
                                                //   height: 4,
                                                // ),
                                                // Text(
                                                //     '\u{20B9} ${widget.model.finalTotal}',
                                                //     style: theme
                                                //         .textTheme.titleLarge!
                                                //         .copyWith(
                                                //         fontWeight:
                                                //         FontWeight.bold,
                                                //         color: AppTheme
                                                //             .secondaryColor)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // widget.model.status == 'complete'
                                    //     ? SizedBox()
                                    //     :
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(
                                          height: 0,
                                          color: Colors.grey.shade300,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8.0),
                                          child: Text(
                                            "Pickup & Drop",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        ListTile(
                                          minLeadingWidth: 0,
                                          leading: Icon(
                                            Icons.location_on_rounded,
                                            color: AppTheme.secondaryColor,
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Pickup Location',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                  '${widget.model.pickupAddress}'),
                                            ],
                                          ),
                                        ),
                                        widget.model.dropAddress == null ||
                                                widget.model.dropAddress == ""
                                            ? SizedBox()
                                            : ListTile(
                                                minLeadingWidth: 0,
                                                leading: Icon(
                                                  Icons.location_on_rounded,
                                                  color: Colors.red,
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Drop Location',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                        '${widget.model.dropAddress}'),
                                                  ],
                                                ),
                                              ),
                                        SizedBox(height: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   height: 100,
                              //   padding: EdgeInsets.all(getWidth(10)),
                              //   decoration: BoxDecoration(
                              //     color: theme.backgroundColor,
                              //     borderRadius: BorderRadius.circular(16),
                              //   ),
                              //   child: Row(
                              //     children: [
                              //       ClipRRect(
                              //         borderRadius: BorderRadius.circular(12),
                              //         child: Container(
                              //           height: 50,
                              //           width: 50,
                              //           decoration: boxDecoration(
                              //               radius: 12, color: Colors.grey),
                              //           child: Image.network(
                              //             "$imagePath${widget.model.userImage1.toString().split("/").last}",
                              //             height: getWidth(72),
                              //             width: getWidth(72),
                              //           ),
                              //         ),
                              //       ),
                              //       SizedBox(width: 16),
                              //       Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //             widget.model.username.toString(),
                              //             style: theme.textTheme.headline6,
                              //           ),
                              //           Spacer(flex: 2),
                              //           Text(
                              //             getTranslated(context, "BOOKED_ON")!,
                              //             style: theme.textTheme.caption,
                              //           ),
                              //           Spacer(),
                              //           Text(
                              //             '${widget.model.dateAdded}',
                              //             style: theme.textTheme.bodySmall,
                              //           ),
                              //         ],
                              //       ),
                              //       Spacer(),
                              //       Column(
                              //         children: [
                              //           Text(
                              //             'Trip ID-${getString1(widget.model.bookingId.toString())}',
                              //             style: theme.textTheme.titleSmall,
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(height: 12),
                              widget.model.status != 'complete' &&
                                      widget.model.userName == "Post Booking"
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade300)),
                                      padding: EdgeInsets.all(getWidth(16)),
                                      margin: EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "User Detail",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "${widget.model.username}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text("${widget.model.mobile}"),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              launch(
                                                  "tel://${widget.model.mobile}");
                                            },
                                            child: Container(
                                              width: 28.w,
                                              height: 5.h,
                                              decoration: boxDecoration(
                                                  radius: 5,
                                                  bgColor:
                                                      AppTheme.secondaryColor),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.call,
                                                    color: Colors.white,
                                                  ),
                                                  boxWidth(5),
                                                  text("Call",
                                                      fontFamily: fontMedium,
                                                      fontSize: 10.sp,
                                                      isCentered: true,
                                                      textColor: Colors.white),
                                                ],
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              Column(
                                children: [
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       color: theme.backgroundColor,
                                  //       borderRadius: BorderRadius.circular(16)),
                                  //   child: Column(
                                  //     children: [
                                  //       // ListTile(
                                  //       //   title: Text(
                                  //       //     getTranslated(context, "RIDE_INFO")!,
                                  //       //     style: theme.textTheme.headline6!.copyWith(
                                  //       //         color: theme.hintColor, fontSize: 18),
                                  //       //   ),
                                  //       //   trailing: Text('${widget.model.km} km',
                                  //       //       style: theme.textTheme.headline6!
                                  //       //           .copyWith(fontSize: 18)),
                                  //       // ),
                                  //       ListTile(
                                  //         leading: Icon(
                                  //           Icons.location_on,
                                  //           color: theme.primaryColor,
                                  //         ),
                                  //         title: Text('${widget.model.pickupAddress}'),
                                  //       ),
                                  //       ListTile(
                                  //         leading: Icon(
                                  //           Icons.navigation,
                                  //           color: theme.primaryColor,
                                  //         ),
                                  //         title: Text('${widget.model.dropAddress}'),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SizedBox(height: 12),
                                  // Container(
                                  //   padding: EdgeInsets.all(16),
                                  //   decoration: BoxDecoration(
                                  //       color: theme.backgroundColor,
                                  //       borderRadius: BorderRadius.vertical(
                                  //           top: Radius.circular(16))),
                                  //   child: Row(
                                  //     children: [
                                  //       RowItem(
                                  //           getTranslated(context, "PAYMENT_VIA"),
                                  //           '${widget.model.transaction}',
                                  //           Icons.account_balance_wallet),
                                  //       // Spacer(),
                                  //       RowItem(
                                  //           getTranslated(context, "RIDE_FARE"),
                                  //           '\u{20B9} ${widget.model.amount}',
                                  //           Icons.account_balance_wallet),
                                  //       // Spacer(),
                                  //       RowItem(
                                  //           getTranslated(context, "RIDE_TYPE"),
                                  //           '${widget.model.bookingType}',
                                  //           Icons.drive_eta),
                                  //     ],
                                  //   ),
                                  // ),

                                  widget.model.status == 'complete'
                                      ? Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade300)),
                                          padding: EdgeInsets.all(getWidth(16)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Payment",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SizedBox(height: 12),
                                              // Row(
                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     const Text('Toll Tax',
                                              //         style: TextStyle(
                                              //             fontSize: 14,
                                              //             color: Colors.black,
                                              //             fontWeight: FontWeight.w400)),
                                              //     widget.model.tollTax == "1"
                                              //         ? text("₹ ${widget.model.tollTaxCharge} (Exclude)",
                                              //         fontSize: 14,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black)
                                              //         : text("Include",
                                              //         fontSize: 14,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black),
                                              //   ],
                                              // ),
                                              // const SizedBox(
                                              //   height: 3,
                                              // ),
                                              // Row(
                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     const Text('Parking',
                                              //         style: TextStyle(
                                              //             fontSize: 14,
                                              //             color: Colors.black,
                                              //             fontWeight: FontWeight.w400)),
                                              //     widget.model.isParking == "1"
                                              //         ?
                                              //     text("₹ ${widget.model.parkingCharge} (Exclude)",
                                              //         fontSize: 14,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black):
                                              //     text("Include",
                                              //         fontSize: 14,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black),
                                              //   ],
                                              // ),
                                              // const SizedBox(
                                              //   height: 2,
                                              // ),
                                              // Row(
                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     const Text('State Tax',
                                              //         style: TextStyle(
                                              //             fontSize: 14,
                                              //             color: Colors.black,
                                              //             fontWeight: FontWeight.w400)),
                                              //     widget.model.isStateTax == "1"
                                              //         ?
                                              //     text("₹ ${widget.model.stateTax} (Exclude)",
                                              //         fontSize: 14,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black):
                                              //     text("Include",
                                              //         fontSize: 14,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black),
                                              //   ],
                                              // ),
                                              // const SizedBox(
                                              //   height: 2,
                                              // ),
                                              // Row(
                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     const Text('Night Charge',
                                              //         style: TextStyle(
                                              //             fontSize: 14,
                                              //             color: Colors.black,
                                              //             fontWeight: FontWeight.w400)),
                                              //     widget.model.isNightCharge == "1"
                                              //         ?
                                              //     text("₹ ${widget.model.nightCharge} (Exclude)",
                                              //         fontSize: 14,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black):
                                              //     text("Include",
                                              //         fontSize: 14,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black),
                                              //   ],
                                              // ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              widget.model.railwayAirportEntryCharge ==
                                                          null ||
                                                      widget.model
                                                              .railwayAirportEntryCharge ==
                                                          "" ||
                                                      widget.model
                                                              .railwayAirportEntryCharge ==
                                                          "0.00"
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                            'Railway/Airport',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        text(
                                                            "${widget.model.railwayAirportEntryCharge.toString()}",
                                                            fontSize: 15,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              widget.model.nightCharge ==
                                                          null ||
                                                      widget.model
                                                              .nightCharge ==
                                                          "" ||
                                                      widget.model
                                                              .nightCharge ==
                                                          "0.00"
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                            'Night Charge',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        text(
                                                            "${widget.model.nightCharge.toString()}",
                                                            fontSize: 15,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              widget.model.parkingCharge ==
                                                          null ||
                                                      widget.model
                                                              .parkingCharge ==
                                                          "" ||
                                                      widget.model
                                                              .parkingCharge ==
                                                          "0.00"
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Parking Charge',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        text(
                                                            "${widget.model.parkingCharge.toString()}",
                                                            fontSize: 15,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              widget.model.tollTaxCharge ==
                                                          null ||
                                                      widget.model
                                                              .tollTaxCharge ==
                                                          "" ||
                                                      widget.model
                                                              .tollTaxCharge ==
                                                          "0.00"
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                            'TollTax Charge',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        text(
                                                            "${widget.model.tollTaxCharge.toString()}",
                                                            fontSize: 15,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              widget.model.orderType != "Hourly"
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Total Time',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        text(
                                                            "${widget.model.totalTime.toString()}Hr.",
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontRegular,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    ),

                                              double.parse((widget.model
                                                                  .distance ??
                                                              '0')
                                                          .toString()) >
                                                      0
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        text("Distance  : ",
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontRegular,
                                                            textColor:
                                                                Colors.black),
                                                        text(
                                                            widget.model
                                                                    .distance
                                                                    .toString() +
                                                                ' km',
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontRegular,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              // double.parse((widget.model.baseFare ?? '0').toString()) >
                                              //     0
                                              // ? Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment.spaceBetween,
                                              //     children: [
                                              //       text("Base fare : ",
                                              //           fontSize: 10.sp,
                                              //           fontFamily: fontRegular,
                                              //           textColor: Colors.black),
                                              //       text(
                                              //           "₹" +
                                              //               widget.model.baseFare
                                              //                   .toString(),
                                              //           fontSize: 10.sp,
                                              //           fontFamily: fontRegular,
                                              //           textColor: Colors.black),
                                              //     ],
                                              //   )
                                              // : SizedBox(),
                                              double.parse((widget.model
                                                                  .extraKm ??
                                                              '0')
                                                          .toString()) >
                                                      0
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        text(
                                                            "Extra Kilometers : ",
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontRegular,
                                                            textColor:
                                                                Colors.black),
                                                        text(
                                                            widget.model.extraKm
                                                                    .toString() +
                                                                ' km',
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontRegular,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              double.parse((widget.model
                                                                  .extraKm ??
                                                              '0')
                                                          .toString()) >
                                                      0
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        text(
                                                            "Extra Kilometer Price : ",
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontRegular,
                                                            textColor:
                                                                Colors.black),
                                                        text(
                                                            "₹" +
                                                                widget.model
                                                                    .extraKmPrice
                                                                    .toString(),
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontRegular,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              // double.parse((widget.model.timeAmount ?? '0').toString()) > 0
                                              // ? Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment.spaceBetween,
                                              //     children: [
                                              //       text(
                                              //           "${widget.model.totalTime.toString()} Minutes : ",
                                              //           fontSize: 10.sp,
                                              //           fontFamily: fontRegular,
                                              //           textColor: Colors.black),
                                              //       text(
                                              //           "₹" +
                                              //               widget.model.timeAmount
                                              //                   .toString(),
                                              //           fontSize: 10.sp,
                                              //           fontFamily: fontRegular,
                                              //           textColor: Colors.black),
                                              //     ],
                                              //   )
                                              // : SizedBox(),

                                              double.parse(widget
                                                          .model.cancelChargeNew
                                                          .toString()) >
                                                      0
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        text(
                                                            "User last ride cancellation charge : ",
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                        text(
                                                            "₹" +
                                                                widget.model
                                                                    .cancelChargeNew
                                                                    .toString(),
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              double.parse((widget.model
                                                                  .surgeAmount ??
                                                              '0')
                                                          .toString()) >
                                                      0
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        text("Surge Amount : ",
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                        text(
                                                            "₹" +
                                                                widget.model
                                                                    .surgeAmount
                                                                    .toString(),
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              double.parse((widget.model
                                                                  .subTotal ??
                                                              '0')
                                                          .toString()) >
                                                      0
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        text("Base Fare : ",
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                        text(
                                                            "₹" +
                                                                (double.parse((widget.model.subTotal ??
                                                                            '0')
                                                                        .toString()))
                                                                    .toStringAsFixed(
                                                                        2),
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              double.parse(widget
                                                          .model.gstAmount
                                                          .toString()) >
                                                      0
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        text("Taxes : ",
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                        text(
                                                            "₹" +
                                                                widget.model
                                                                    .gstAmount
                                                                    .toString(),
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    )
                                                  : SizedBox(),

                                              double.parse(widget
                                                          .model.pointUsed
                                                          .toString()) >
                                                      0
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        text("Coin Used : ",
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                        text(
                                                            "₹" +
                                                                widget.model
                                                                    .pointUsed
                                                                    .toString(),
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                fontMedium,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    )
                                                  : SizedBox(),

                                              // double.parse((widget.model.amount ?? '0').toString()) > 0
                                              //     ? Row(
                                              //         mainAxisAlignment:
                                              //             MainAxisAlignment.spaceBetween,
                                              //         children: [
                                              //           text("Sub Total : ",
                                              //               fontSize: 10.sp,
                                              //               fontFamily: fontMedium,
                                              //               textColor: Colors.black),
                                              //           text(
                                              //               "₹" +
                                              //                   (double.parse((widget.model.amount ?? '0')
                                              //                               .toString()) +
                                              //                           double.parse((widget.model.promoDiscount ?? '0')
                                              //                               .toString()))
                                              //                       .toStringAsFixed(2),
                                              //               fontSize: 10.sp,
                                              //               fontFamily: fontMedium,
                                              //               textColor: Colors.black),
                                              //         ],
                                              //       )
                                              //     : SizedBox(),
                                              //
                                              widget.model.promoDiscount
                                                              .toString() ==
                                                          null ||
                                                      widget.model.promoDiscount
                                                              .toString() ==
                                                          ''
                                                  ? SizedBox.shrink()
                                                  : double.parse((widget.model
                                                                      .promoDiscount ??
                                                                  '0')
                                                              .toString()) >
                                                          0
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            text(
                                                                "Promo Discount : ",
                                                                fontSize: 10.sp,
                                                                fontFamily:
                                                                    fontRegular,
                                                                textColor:
                                                                    Colors
                                                                        .black),
                                                            text(
                                                                "- ₹" +
                                                                    widget.model
                                                                        .promoDiscount
                                                                        .toString(),
                                                                fontSize: 10.sp,
                                                                fontFamily:
                                                                    fontRegular,
                                                                textColor:
                                                                    Colors
                                                                        .black),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                              Divider(),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     text("Total : ",
                                              //         fontSize: 10.sp,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black),
                                              //     text("₹" + "${widget.model.amount}",
                                              //         fontSize: 10.sp,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black),
                                              //   ],
                                              // ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  text("Total : ",
                                                      fontSize: 10.sp,
                                                      fontFamily: fontMedium,
                                                      textColor: Colors.black),
                                                  text(
                                                      "₹" +
                                                          "${widget.model.finalTotal}",
                                                      fontSize: 10.sp,
                                                      fontFamily: fontMedium,
                                                      textColor: Colors.black),
                                                ],
                                              ),

                                              ///remaining amount
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     text("Remaining Amount : ",
                                              //         fontSize: 10.sp,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black),
                                              //     text("₹" + "${double.parse(widget.model.finalTotal.toString()) - double.parse(widget.model.paidAmount.toString())}",
                                              //         fontSize: 10.sp,
                                              //         fontFamily: fontMedium,
                                              //         textColor: Colors.black),
                                              //   ],
                                              // ),
                                              /*widget.model.admin_commision != null
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          text(
                                                              "${getTranslated(context, "Admincommission")} : ",
                                                              fontSize: 10.sp,
                                                              fontFamily: fontMedium,
                                                              textColor:
                                                                  Colors.black),
                                                          text(
                                                              "₹" +
                                                                  "${widget.model.admin_commision}",
                                                              fontSize: 10.sp,
                                                              fontFamily: fontMedium,
                                                              textColor:
                                                                  Colors.black),
                                                        ],
                                                      )
                                                    : SizedBox(),*/

                                              // widget.model.acceptReject == "1" ||
                                              //         widget.model.acceptReject == "6"
                                              //     ? Row(
                                              //         mainAxisSize: MainAxisSize.min,
                                              //         children: [
                                              //           InkWell(
                                              //             onTap: () {
                                              //               launch(
                                              //                   "tel://${widget.model.mobile}");
                                              //             },
                                              //             child: Container(
                                              //               width: 28.w,
                                              //               height: 5.h,
                                              //               decoration: boxDecoration(
                                              //                   radius: 5,
                                              //                   bgColor: Theme.of(context)
                                              //                       .primaryColor),
                                              //               child: Center(
                                              //                   child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment.center,
                                              //                 children: [
                                              //                   Icon(
                                              //                     Icons.call,
                                              //                     color: Colors.white,
                                              //                   ),
                                              //                   boxWidth(5),
                                              //                   text("Call",
                                              //                       fontFamily: fontMedium,
                                              //                       fontSize: 10.sp,
                                              //                       isCentered: true,
                                              //                       textColor: Colors.white),
                                              //                 ],
                                              //               )),
                                              //             ),
                                              //           ),
                                              //           boxWidth(10),
                                              //           // widget.model.acceptReject == "1"
                                              //           //     ? InkWell(
                                              //           //         onTap: () {
                                              //           //           setState(() {
                                              //           //             // showMore = false;
                                              //           //           });
                                              //           //           showBottom1();
                                              //           //         },
                                              //           //         child: Container(
                                              //           //           width: 28.w,
                                              //           //           height: 5.h,
                                              //           //           decoration: boxDecoration(
                                              //           //               radius: 5,
                                              //           //               bgColor:
                                              //           //                   Theme.of(context)
                                              //           //                       .primaryColor),
                                              //           //           child: Center(
                                              //           //               child: Row(
                                              //           //             mainAxisAlignment:
                                              //           //                 MainAxisAlignment
                                              //           //                     .center,
                                              //           //             children: [
                                              //           //               Icon(
                                              //           //                 Icons.close,
                                              //           //                 color: Colors.white,
                                              //           //               ),
                                              //           //               boxWidth(5),
                                              //           //               text("Cancel",
                                              //           //                   fontFamily:
                                              //           //                       fontMedium,
                                              //           //                   fontSize: 10.sp,
                                              //           //                   isCentered: true,
                                              //           //                   textColor:
                                              //           //                       Colors.white),
                                              //           //             ],
                                              //           //           )),
                                              //           //         ),
                                              //           //       )
                                              //           //     : SizedBox(),
                                              //           // boxWidth(10),
                                              //           !widget.model.bookingType!
                                              //                   .contains("Point")
                                              //               ? getDifference()
                                              //                   ? InkWell(
                                              //                       onTap: () {
                                              //                         // setState(() {
                                              //                         //   acceptStatus = true;
                                              //                         // });
                                              //                         if (widget.model
                                              //                                 .acceptReject ==
                                              //                             "1") {
                                              //                           startRide(
                                              //                               widget.model
                                              //                                   .bookingId!,
                                              //                               "6");
                                              //                         } else {
                                              //                           print("complete");
                                              //                           completeRide(
                                              //                               widget.model
                                              //                                   .bookingId!,
                                              //                               "3");
                                              //                         }
                                              //                       },
                                              //                       child:
                                              //                           // !acceptStatus?
                                              //                           Container(
                                              //                         width: 28.w,
                                              //                         height: 5.h,
                                              //                         decoration: boxDecoration(
                                              //                             radius: 5,
                                              //                             bgColor: Theme.of(
                                              //                                     context)
                                              //                                 .primaryColor),
                                              //                         child: Center(
                                              //                             child: Row(
                                              //                           mainAxisAlignment:
                                              //                               MainAxisAlignment
                                              //                                   .center,
                                              //                           children: [
                                              //                             Icon(
                                              //                               Icons.check,
                                              //                               color:
                                              //                                   Colors.white,
                                              //                             ),
                                              //                             boxWidth(5),
                                              //                             text(
                                              //                                 widget.model.acceptReject ==
                                              //                                         "1"
                                              //                                     ? "Start"
                                              //                                     : "Complete",
                                              //                                 fontFamily:
                                              //                                     fontMedium,
                                              //                                 fontSize: 10.sp,
                                              //                                 isCentered:
                                              //                                     true,
                                              //                                 textColor:
                                              //                                     Colors
                                              //                                         .white),
                                              //                           ],
                                              //                         )),
                                              //                       )
                                              //                       // :CircularProgressIndicator(),
                                              //                       )
                                              //                   : SizedBox()
                                              //               : InkWell(
                                              //                   onTap: () {
                                              //                     /*setState(() {acceptStatus = true;});*/
                                              //                     if (widget.model
                                              //                             .acceptReject ==
                                              //                         "1") {
                                              //                       /*setState(() {widget.model.acceptReject="6";});*/
                                              //                       startRide(
                                              //                           widget
                                              //                               .model.bookingId!,
                                              //                           "6");
                                              //                     } else {
                                              //                       print("complete");
                                              //                       completeRide(
                                              //                           widget
                                              //                               .model.bookingId!,
                                              //                           "3");
                                              //                     }
                                              //                   },
                                              //                   child: !acceptStatus
                                              //                       ? Container(
                                              //                           width: 28.w,
                                              //                           height: 5.h,
                                              //                           decoration: boxDecoration(
                                              //                               radius: 5,
                                              //                               bgColor: Theme.of(
                                              //                                       context)
                                              //                                   .primaryColor),
                                              //                           child: Center(
                                              //                               child: Row(
                                              //                             mainAxisAlignment:
                                              //                                 MainAxisAlignment
                                              //                                     .center,
                                              //                             children: [
                                              //                               Icon(
                                              //                                 Icons.check,
                                              //                                 color: Colors
                                              //                                     .white,
                                              //                               ),
                                              //                               boxWidth(5),
                                              //                               text(
                                              //                                   widget.model.acceptReject ==
                                              //                                           "1"
                                              //                                       ? "Start"
                                              //                                       : "Complete",
                                              //                                   fontFamily:
                                              //                                       fontMedium,
                                              //                                   fontSize:
                                              //                                       10.sp,
                                              //                                   isCentered:
                                              //                                       true,
                                              //                                   textColor:
                                              //                                       Colors
                                              //                                           .white),
                                              //                             ],
                                              //                           )),
                                              //                         )
                                              //                       : CircularProgressIndicator(),
                                              //                 ),
                                              //         ],
                                              //       )
                                              //     : SizedBox(),
                                            ],
                                          ),
                                        )
                                      : SizedBox(),

                                  detailModel != null
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.grey.shade300),
                                          ),
                                          padding: EdgeInsets.all(getWidth(16)),
                                          margin: EdgeInsets.only(
                                              bottom: 12, top: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Ride Detail",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    "Start Meter",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    "Reading : ${detailModel?.odhometer?[0].value ?? ''}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Container(
                                                    height: 100,
                                                    width: 150,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: detailModel
                                                                    ?.odhometer?[
                                                                        0]
                                                                    .image ==
                                                                null
                                                            ? DottedBorder(
                                                                color: Colors
                                                                    .green,
                                                                // Dotted border color
                                                                strokeWidth: 2,
                                                                dashPattern: [
                                                                  8,
                                                                  4
                                                                ],
                                                                // Dotted pattern
                                                                borderType:
                                                                    BorderType
                                                                        .RRect,
                                                                radius:
                                                                    const Radius
                                                                        .circular(
                                                                        8),
                                                                child:
                                                                    Container(
                                                                  height: 100,
                                                                  color: Colors
                                                                      .green
                                                                      .shade50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Odometer",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                ),
                                                              )
                                                            : Image.network(
                                                                imgUrl +
                                                                    "${detailModel?.odhometer?[0].image}",
                                                                height: 100,
                                                                width: 150,
                                                                fit:
                                                                    BoxFit.fill,
                                                                colorBlendMode: profileStatus ==
                                                                        "0"
                                                                    ? BlendMode
                                                                        .hardLight
                                                                    : BlendMode
                                                                        .color,
                                                                color: profileStatus ==
                                                                        "0"
                                                                    ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.4)
                                                                    : Colors
                                                                        .transparent,
                                                              )),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    "End Meter",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    "Reading : ${detailModel?.odhometer?[1].value ?? ''}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Container(
                                                    height: 100,
                                                    width: 150,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: detailModel
                                                                    ?.odhometer?[
                                                                        1]
                                                                    .image ==
                                                                null
                                                            ? DottedBorder(
                                                                color: Colors
                                                                    .green,
                                                                // Dotted border color
                                                                strokeWidth: 2,
                                                                dashPattern: [
                                                                  8,
                                                                  4
                                                                ],
                                                                // Dotted pattern
                                                                borderType:
                                                                    BorderType
                                                                        .RRect,
                                                                radius:
                                                                    const Radius
                                                                        .circular(
                                                                        8),
                                                                child:
                                                                    Container(
                                                                  height: 100,
                                                                  color: Colors
                                                                      .green
                                                                      .shade50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Odometer",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                ),
                                                              )
                                                            : Image.network(
                                                                imgUrl +
                                                                    "${detailModel?.odhometer?[1].image}",
                                                                height: 100,
                                                                width: 150,
                                                                fit:
                                                                    BoxFit.fill,
                                                                colorBlendMode: profileStatus ==
                                                                        "0"
                                                                    ? BlendMode
                                                                        .hardLight
                                                                    : BlendMode
                                                                        .color,
                                                                color: profileStatus ==
                                                                        "0"
                                                                    ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.4)
                                                                    : Colors
                                                                        .transparent,
                                                              )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                              // Spacer(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              bottomNavigationBar: /*!widget.complete &&*/
                  widget.model.driverStatus != "4" &&
                          widget.model.status != "Cancelled" &&
                          widget.model.driverStatus != "0"
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16, bottom: 16),
                          child: InkWell(
                              onTap: () async {
                                /*setState(() {acceptStatus = true;});*/
                                if (widget.model.acceptReject == "0"
                                    // widget.model.status == "accept"
                                    ) {
                                  /*setState(() {widget.model.acceptReject="6";});*/
                                  // showDialog(context: context, builder: (context) => selfieDialog());
                                  if (widget.model.driverStatus == '0') {
                                    fromGarage = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StartGarageScreen(
                                            bookingId: widget.model.bookingId,
                                            garage: isGarage),
                                      ),
                                    );
                                    if (fromGarage) {
                                      setState(() {
                                        getBookingDetail();
                                      });
                                    }
                                  } else if (widget.model.driverStatus == '1') {
                                    updatebookingStatus(
                                        widget.model.bookingId!, '2');
                                  } else if (widget.model.driverStatus == '2') {
                                    startRide(widget.model.bookingId!, "6");
                                  }
                                } else {
                                  print("complete");
                                  completeRide(widget.model.bookingId!, "3");
                                }
                              },
                              child: Container(
                                  height: 6.h,
                                  decoration: boxDecoration(
                                      radius: 5,
                                      bgColor: AppTheme.secondaryColor),
                                  child: Center(
                                      child: !acceptStatus
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Icon(
                                                //   Icons.check,
                                                //   color: Colors
                                                //       .white,
                                                // ),
                                                // boxWidth(5),
                                                text(
                                                    widget.model.driverStatus ==
                                                            "0"
                                                        ? "Start from garage"
                                                        : isGarage &&
                                                                widget.model
                                                                        .driverStatus ==
                                                                    "1"
                                                            ? "Reached Location"
                                                            : widget.model
                                                                        .driverStatus ==
                                                                    "2"
                                                                ? "Start ride"
                                                                : "Complete ride",
                                                    fontFamily: fontMedium,
                                                    fontSize: 12.sp,
                                                    isCentered: true,
                                                    textColor: Colors.white),
                                              ],
                                            )
                                          : CircularProgressIndicator()))),
                        )
                      : SizedBox()),
        ),
      ),
    );
  }

  getDifference() {
    String date = widget.model.pickupDate.toString();
    DateTime temp = DateTime.parse(date);
    print(temp);
    print(date);
    if (temp.day == DateTime.now().day) {
      String time = widget.model.pickupTime.toString().split(" ")[0];
      int i = 0;
      if (widget.model.pickupTime.toString().split(" ").length > 1 &&
          widget.model.pickupTime.toString().split(" ")[1].toLowerCase() ==
              "pm") {
        i = 12;
      }
      print(time);
      if (time != "") {
        DateTime temp = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            int.parse(time.split(":")[0]) + i,
            int.parse(time.split(":")[1]));
        print("check" + temp.difference(DateTime.now()).inMinutes.toString());
        print(temp);
        print(DateTime.now());
        print(1 > temp.difference(DateTime.now()).inMinutes);
        return 1 > temp.difference(DateTime.now()).inMinutes;
      } else {
        return true;
      }
    } else {
      print(false);
      return false;
    }
  }
}
