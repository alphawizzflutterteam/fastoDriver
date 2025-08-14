import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:pristine_andaman_driver/Auth/Login/UI/login_page.dart';
import 'package:pristine_andaman_driver/Locale/strings_enum.dart';
import 'package:pristine_andaman_driver/Model/cab_model.dart';
import 'package:pristine_andaman_driver/Provider/UserProvider.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/PushNotificationService.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/colors.dart';
import 'package:pristine_andaman_driver/utils/common.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/new_utils/ui.dart';
import 'package:pristine_andaman_driver/utils/widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Theme/style.dart';

class RegistrationUI extends StatefulWidget {
  String? phoneNumber;

  RegistrationUI(this.phoneNumber);

  @override
  _RegistrationUIState createState() => _RegistrationUIState();
}

class _RegistrationUIState extends State<RegistrationUI> {
  TextEditingController mobileCon = new TextEditingController();
  TextEditingController referCon = new TextEditingController();
  TextEditingController emailCon = new TextEditingController();
  TextEditingController bankCon = new TextEditingController();
  TextEditingController accountCon = new TextEditingController();
  TextEditingController codeCon = new TextEditingController();
  TextEditingController nameCon = new TextEditingController();
  TextEditingController vehicleCon = new TextEditingController();
  TextEditingController carCon = new TextEditingController();
  TextEditingController modelCon = new TextEditingController();
  TextEditingController genderCon = new TextEditingController();
  TextEditingController dobCon = new TextEditingController();
  final TextEditingController accountTypeCon = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileCon.text = widget.phoneNumber.toString();
    PushNotificationService notificationService =
        new PushNotificationService(context: context, onResult: (result) {});
    notificationService.initialise();
    getCab();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> brands = [];

  List<String> brandsModel = [];
  List<String> gender = ["Male", "Female", "Other"];
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? persistentBottomSheetController;

  showBottom() async {
    persistentBottomSheetController =
        await scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        decoration:
            boxDecoration(radius: 0, showShadow: true, color: Colors.white),
        padding: EdgeInsets.all(getWidth(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            boxHeight(20),
            text(getTranslated(context, "VEHICLE_TYPE")!,
                textColor: MyColorName.colorTextPrimary,
                fontSize: 12.sp,
                fontFamily: fontBold),
            boxHeight(20),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cabList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        persistentBottomSheetController!.setState!(() {
                          cabId = cabList[index].id;
                          carCon.text = cabList[index].car_type;
                          cabName = cabList[index].car_type;
                        });
                        Navigator.pop(context);
                        getModel();
                      },
                      child: Container(
                        color: cabId == cabList[index].id
                            ? MyColorName.primaryLite.withOpacity(0.2)
                            : Colors.white,
                        padding: EdgeInsets.all(getWidth(10)),
                        child: text(cabList[index].car_type.toString(),
                            textColor: MyColorName.colorTextPrimary,
                            fontSize: 10.sp,
                            fontFamily: fontMedium),
                      ),
                    );
                  }),
            ),
            boxHeight(40),
          ],
        ),
      );
    });
  }

  PersistentBottomSheetController? persistentBottomSheetController1;

  showBottom1() async {
    persistentBottomSheetController1 =
        await scaffoldKey.currentState!.showBottomSheet((context) {
      return SingleChildScrollView(
        child: Container(
          decoration:
              boxDecoration(radius: 0, showShadow: true, color: Colors.white),
          padding: EdgeInsets.all(getWidth(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              boxHeight(20),
              text("Select Vehicle Model",
                  textColor: MyColorName.colorTextPrimary,
                  fontSize: 12.sp,
                  fontFamily: fontBold),
              boxHeight(20),
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: modelList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          persistentBottomSheetController1!.setState!(() {
                            modelId = modelList[index].id;
                            modelCon.text = modelList[index].car_model;
                            modelName = modelList[index].car_model;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: modelId == modelList[index].id
                              ? MyColorName.primaryLite.withOpacity(0.2)
                              : Colors.white,
                          padding: EdgeInsets.all(getWidth(10)),
                          child: text(modelList[index].car_model.toString(),
                              textColor: MyColorName.colorTextPrimary,
                              fontSize: 10.sp,
                              fontFamily: fontMedium),
                        ),
                      );
                    }),
              ),
              boxHeight(40),
            ],
          ),
        ),
      );
    });
  }

  DateTime startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        startDate = picked;
        dobCon.text = DateFormat("yyyy-MM-dd").format(startDate);
      });
    }
  }

  PersistentBottomSheetController? persistentBottomSheetController2;

  showBottom2() async {
    persistentBottomSheetController2 =
        await scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        decoration:
            boxDecoration(radius: 0, showShadow: true, color: Colors.white),
        padding: EdgeInsets.all(getWidth(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            boxHeight(20),
            text("Select Gender",
                textColor: MyColorName.colorTextPrimary,
                fontSize: 12.sp,
                fontFamily: fontBold),
            boxHeight(20),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: gender.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        persistentBottomSheetController2!.setState!(() {
                          genderCon.text = gender[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: genderCon.text == gender[index]
                            ? MyColorName.primaryLite.withOpacity(0.2)
                            : Colors.white,
                        padding: EdgeInsets.all(getWidth(10)),
                        child: text(gender[index].toString(),
                            textColor: MyColorName.colorTextPrimary,
                            fontSize: 10.sp,
                            fontFamily: fontMedium),
                      ),
                    );
                  }),
            ),
            boxHeight(40),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var userdata = Provider.of<UserProvider>(context, listen: false);
    var theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) / 1.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(200, 30),
                      bottomRight: Radius.elliptical(200, 30))),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 0,
                            color: Colors.black.withOpacity(0.3),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child:

                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           'Create Account',
                            //           style: theme.textTheme.headlineLarge!.copyWith(
                            //               fontSize: 25,
                            //               fontWeight: FontWeight.bold,
                            //               color: Colors.black),
                            //         ),
                            //         // SizedBox(
                            //         //   height: 10,
                            //         // ),
                            //         // Text('We have send code to your mobile number'),
                            //         // SizedBox(
                            //         //   height: 10,
                            //         // ),
                            //         // InkWell(
                            //         //   onTap: () {
                            //         //     // requestPermission(context, 1);
                            //         //   },
                            //         //   child: Padding(
                            //         //     padding:
                            //         //         const EdgeInsets.only(left: 10, top: 0),
                            //         //     child: Center(
                            //         //       child: ClipRRect(
                            //         //         borderRadius: BorderRadius.circular(10),
                            //         //         child: Container(
                            //         //           height: 120,
                            //         //           width: 120,
                            //         //           decoration: BoxDecoration(
                            //         //             border: Border.all(),
                            //         //             color: Colors.white,
                            //         //             borderRadius: BorderRadius.circular(10),
                            //         //           ),
                            //         //           alignment: Alignment.center,
                            //         //           child: _image != null
                            //         //               ? Image.file(
                            //         //                   _image!,
                            //         //                   height: 100,
                            //         //                   width: 100,
                            //         //                   fit: BoxFit.fill,
                            //         //                 )
                            //         //               : Icon(Icons.camera_alt,
                            //         //                   color: Colors.black),
                            //         //         ),
                            //         //       ),
                            //         //     ),
                            //         //   ),
                            //         // ),
                            //         EntryField(
                            //           readOnly: true,
                            //           controller: mobileCon,
                            //           maxLength: 10,
                            //           keyboardType: TextInputType.phone,
                            //           label: getTranslated(context, "ENTER_PHONE")!,
                            //         ),
                            //         EntryField(
                            //           controller: nameCon,
                            //           keyboardType: TextInputType.name,
                            //           label: getTranslated(context, Strings.FULL_NAME),
                            //         ),
                            //         EntryField(
                            //           controller: emailCon,
                            //           keyboardType: TextInputType.emailAddress,
                            //           label:
                            //           "${getTranslated(context, Strings.EMAIL_ADD)} (Optional)",
                            //         ),
                            //         gender.length > 0
                            //             ? EntryField(
                            //           label: "Gender",
                            //           dropdownItems: ["Male", "Female", "Other"],
                            //           selectedValue: genderCon.text.isNotEmpty
                            //               ? genderCon.text
                            //               : null,
                            //           onDropdownChanged: (value) {
                            //             genderCon.text = value ?? "";
                            //           },
                            //         )
                            //             : SizedBox(),
                            //         EntryField(
                            //           label: "Date of Birth",
                            //           controller: dobCon,
                            //           readOnly: true,
                            //           suffixIcon: Icon(Icons.calendar_today,
                            //               color: Theme.of(context).primaryColor),
                            //           onTap: () async {
                            //             DateTime? pickedDate = await showDatePicker(
                            //               context: context,
                            //               initialDate: DateTime.now(),
                            //               firstDate: DateTime(1900),
                            //               lastDate: DateTime.now(),
                            //             );
                            //             if (pickedDate != null) {
                            //               dobCon.text =
                            //               "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            //             }
                            //           },
                            //         ),
                            //
                            //         /* EntryField(
                            //                         controller: referCon,
                            //                         label: getTranslated(context, "REFER_CODE")!,
                            //                       ),*/
                            //         // SizedBox(height: 20),
                            //         // Padding(
                            //         //   padding: EdgeInsets.symmetric(horizontal: 24),
                            //         //   child: Text(
                            //         //     getTranslated(context, Strings.CAR_INFO)!,
                            //         //     style: theme.textTheme.headlineSmall,
                            //         //   ),
                            //         // ),
                            //         // EntryField(
                            //         //   maxLength: 10,
                            //         //   readOnly: true,
                            //         //   controller: carCon,
                            //         //   onTap: () {
                            //         //     showBottom();
                            //         //   },
                            //         //   label: getTranslated(context, "VEHICLE_TYPE")!,
                            //         //   hint: "",
                            //         // ),
                            //         carCon.text.toLowerCase() != "auto" &&
                            //             modelList.length > 0
                            //             ? EntryField(
                            //           maxLength: 10,
                            //           readOnly: true,
                            //           controller: modelCon,
                            //           onTap: () {
                            //             showBottom1();
                            //           },
                            //           label: "Vehicle Model",
                            //           hint: "",
                            //         )
                            //             : SizedBox(),
                            //         EntryField(
                            //           maxLength: 10,
                            //           controller: vehicleCon,
                            //           label:
                            //           getTranslated(context, Strings.VEHICLE_NUM),
                            //         ),
                            //         // SizedBox(height: 10),
                            //         // Padding(
                            //         //   padding: EdgeInsets.symmetric(horizontal: 24),
                            //         //   child: Text(
                            //         //     "Bank Info",
                            //         //     style: theme.textTheme.headlineSmall,
                            //         //   ),
                            //         // ),
                            //         EntryField(
                            //           keyboardType: TextInputType.phone,
                            //           controller: accountCon,
                            //           maxLength: 16,
                            //           label: getTranslated(context, "Accountnumber")!,
                            //           hint: "",
                            //         ),
                            //         EntryField(
                            //           keyboardType: TextInputType.text,
                            //           controller: bankCon,
                            //           label: "Bank Name",
                            //           hint: "",
                            //         ),
                            //         EntryField(
                            //           maxLength: 11,
                            //           keyboardType: TextInputType.text,
                            //           controller: codeCon,
                            //           label: "IFSC Code",
                            //           hint: "",
                            //         ),
                            //         SizedBox(height: 10),
                            //         EntryField(
                            //           label: "Account Type",
                            //           dropdownItems: ["Current", "Saving"],
                            //           selectedValue: accountTypeCon.text.isNotEmpty
                            //               ? accountTypeCon.text
                            //               : null,
                            //           onDropdownChanged: (value) {
                            //             accountTypeCon.text = value ?? "";
                            //           },
                            //         ),
                            //         // Padding(
                            //         //   padding: EdgeInsets.symmetric(horizontal: 20),
                            //         //   child: Text(
                            //         //     getTranslated(context, Strings.DOCUMENT)!,
                            //         //     style: theme.textTheme.headlineSmall,
                            //         //   ),
                            //         // ),
                            //         SizedBox(height: 10),
                            //         buildUploadTile("Upload Driving License",
                            //             _finalImage, (file) => _finalImage = file),
                            //         buildUploadTile(
                            //           "Upload Passbook",
                            //           panImage,
                            //               (file) => panImage = file,
                            //         ),
                            //         buildUploadTile("Upload Aadhaar (Front)",
                            //             adharImage, (file) => adharImage = file),
                            //         buildUploadTile(
                            //           "Upload Aadhaar (Back)",
                            //           insuranceImage,
                            //               (file) => insuranceImage = file,
                            //         ),
                            //         buildUploadTile(
                            //           "Upload RC",
                            //           bankImage,
                            //               (file) => bankImage = file,
                            //         ),
                            //         buildUploadTile("Upload Vehicle", vehicleImage,
                            //                 (file) => vehicleImage = file),
                            //         SizedBox(height: 20),
                            //         !loading
                            //             ? InkWell(
                            //           onTap: () {
                            //             if (mobileCon.text == "" ||
                            //                 mobileCon.text.length != 10) {
                            //               UI.setSnackBar(
                            //                   "Please Enter Valid Mobile Number",
                            //                   context);
                            //               return;
                            //             }
                            //             if (validateField(nameCon.text,
                            //                 "Please Enter Full Name") !=
                            //                 null) {
                            //               UI.setSnackBar(
                            //                   "Please Enter Full Name", context);
                            //               return;
                            //             }
                            //             // if(validateEmail(emailCon.text, "Please Enter Email","Please Enter Valid Email")!=null){
                            //             //   UI.setSnackBar(validateEmail(emailCon.text, "Please Enter Email","Please Enter Valid Email").toString(), context);
                            //             //   return;
                            //             // }
                            //             if (genderCon.text == "") {
                            //               UI.setSnackBar(
                            //                   "Please Select Gender", context);
                            //               return;
                            //             }
                            //             if (dobCon.text == "") {
                            //               UI.setSnackBar(
                            //                   "Please Enter Date of Birth",
                            //                   context);
                            //               return;
                            //             }
                            //             if (vehicleCon.text == "" ||
                            //                 vehicleCon.text.length != 10) {
                            //               UI.setSnackBar(
                            //                   "Please Enter Valid Vehicle Number",
                            //                   context);
                            //               return;
                            //             }
                            //             if (accountCon.text == "" ||
                            //                 accountCon.text.length < 10) {
                            //               UI.setSnackBar(
                            //                   "Please Enter Valid Account Number",
                            //                   context);
                            //               return;
                            //             }
                            //             if (bankCon.text == "") {
                            //               UI.setSnackBar(
                            //                   "Please Enter Valid Bank Name",
                            //                   context);
                            //               return;
                            //             }
                            //             if (codeCon.text == "" ||
                            //                 codeCon.text.length != 11) {
                            //               UI.setSnackBar(
                            //                   "Please Enter Valid IFSC Code",
                            //                   context);
                            //               return;
                            //             }
                            //             // if (_image == null) {
                            //             //   UI.setSnackBar(
                            //             //       "Please Upload Photo", context);
                            //             //   return;
                            //             // }
                            //             if (_finalImage == null) {
                            //               UI.setSnackBar(
                            //                   "Please Upload Document Photo",
                            //                   context);
                            //               return;
                            //             }
                            //             // if (panImage == null) {
                            //             //   UI.setSnackBar(
                            //             //       "Please Upload Citizenship/Passport Photo", context);
                            //             //   return;
                            //             // }
                            //             if (adharImage == null) {
                            //               UI.setSnackBar(
                            //                   "Please Upload Adhar Photo",
                            //                   context);
                            //               return;
                            //             }
                            //             /*if (insuranceImage == null) {
                            //   UI.setSnackBar("Please Upload Insurance Photo", context);
                            //   return;
                            // }
                            // if (bankImage == null) {
                            //   UI.setSnackBar("Please Upload Cheque Photo", context);
                            //   return;
                            // }*/
                            //             if (vehicleImage == null) {
                            //               UI.setSnackBar(
                            //                   "Please Upload Vehicle Photo",
                            //                   context);
                            //               return;
                            //             }
                            //             setState(() {
                            //               loading = true;
                            //             });
                            //             submitSubscription();
                            //           },
                            //           child: Container(
                            //               height: 50,
                            //               width:
                            //               MediaQuery.of(context).size.width,
                            //               decoration: BoxDecoration(
                            //                   color: AppTheme.primaryColor,
                            //                   borderRadius:
                            //                   BorderRadius.circular(5)),
                            //               child: Center(
                            //                   child: Text(
                            //                     "SignUp",
                            //                     style: TextStyle(
                            //                         color: Colors.white,
                            //                         fontWeight: FontWeight.w600),
                            //                   ))),
                            //         )
                            //             : Center(
                            //           child: Container(
                            //             width: 50,
                            //             height: 50,
                            //             child: Center(
                            //               child: CircularProgressIndicator(),
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),

                            Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Account',
                              style: theme.textTheme.headlineLarge!.copyWith(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            EntryField(
                              readOnly: true,
                              controller: mobileCon,
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              label: getTranslated(context, "ENTER_PHONE")!,
                            ),
                            EntryField(
                              controller: nameCon,
                              keyboardType: TextInputType.name,
                              label: getTranslated(context, Strings.FULL_NAME),
                            ),
                            EntryField(
                              controller: emailCon,
                              keyboardType: TextInputType.emailAddress,
                              label:
                                  "${getTranslated(context, Strings.EMAIL_ADD)} (Optional)",
                            ),
                            if (gender.isNotEmpty)
                              EntryField(
                                label: "Gender",
                                dropdownItems: ["Male", "Female", "Other"],
                                selectedValue: genderCon.text.isNotEmpty
                                    ? genderCon.text
                                    : null,
                                onDropdownChanged: (value) {
                                  genderCon.text = value ?? "";
                                },
                              ),
                            EntryField(
                              label: "Date of Birth",
                              controller: dobCon,
                              readOnly: true,
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).primaryColor,
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  dobCon.text =
                                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                }
                              },
                            ),
                            if (carCon.text.toLowerCase() != "auto" &&
                                modelList.isNotEmpty)
                              EntryField(
                                maxLength: 10,
                                readOnly: true,
                                controller: modelCon,
                                onTap: showBottom1,
                                label: "Vehicle Model",
                              ),
                            EntryField(
                              maxLength: 10,
                              controller: vehicleCon,
                              label:
                                  getTranslated(context, Strings.VEHICLE_NUM),
                            ),
                            EntryField(
                              keyboardType: TextInputType.phone,
                              controller: accountCon,
                              maxLength: 16,
                              label: getTranslated(context, "Accountnumber")!,
                            ),
                            EntryField(
                              keyboardType: TextInputType.text,
                              controller: bankCon,
                              label: "Bank Name",
                            ),
                            EntryField(
                              maxLength: 11,
                              keyboardType: TextInputType.text,
                              controller: codeCon,
                              label: "IFSC Code",
                            ),
                            const SizedBox(height: 10),
                            EntryField(
                              label: "Account Type",
                              dropdownItems: ["Current", "Saving"],
                              selectedValue: accountTypeCon.text.isNotEmpty
                                  ? accountTypeCon.text
                                  : null,
                              onDropdownChanged: (value) {
                                accountTypeCon.text = value ?? "";
                              },
                            ),
                            const SizedBox(height: 10),
                            buildUploadTile("Upload Driving License",
                                _finalImage, (file) => _finalImage = file),
                            buildUploadTile("Upload Passbook", panImage,
                                (file) => panImage = file),
                            buildUploadTile("Upload Aadhaar (Front)",
                                adharImage, (file) => adharImage = file),
                            buildUploadTile(
                                "Upload Aadhaar (Back)",
                                insuranceImage,
                                (file) => insuranceImage = file),
                            buildUploadTile("Upload RC", bankImage,
                                (file) => bankImage = file),
                            buildUploadTile("Upload Vehicle", vehicleImage,
                                (file) => vehicleImage = file),
                            const SizedBox(height: 20),
                            !loading
                                ? InkWell(
                                    onTap: () {
                                      if (mobileCon.text.isEmpty ||
                                          mobileCon.text.length != 10) {
                                        UI.setSnackBar(
                                            "Please Enter Valid Mobile Number",
                                            context);
                                        return;
                                      }
                                      if (validateField(nameCon.text,
                                              "Please Enter Full Name") !=
                                          null) {
                                        UI.setSnackBar(
                                            "Please Enter Full Name", context);
                                        return;
                                      }
                                      if (genderCon.text.isEmpty) {
                                        UI.setSnackBar(
                                            "Please Select Gender", context);
                                        return;
                                      }
                                      if (dobCon.text.isEmpty) {
                                        UI.setSnackBar(
                                            "Please Enter Date of Birth",
                                            context);
                                        return;
                                      }
                                      if (vehicleCon.text.isEmpty ||
                                          vehicleCon.text.length != 10) {
                                        UI.setSnackBar(
                                            "Please Enter Valid Vehicle Number",
                                            context);
                                        return;
                                      }
                                      if (accountCon.text.isEmpty ||
                                          accountCon.text.length < 10) {
                                        UI.setSnackBar(
                                            "Please Enter Valid Account Number",
                                            context);
                                        return;
                                      }
                                      if (bankCon.text.isEmpty) {
                                        UI.setSnackBar(
                                            "Please Enter Valid Bank Name",
                                            context);
                                        return;
                                      }
                                      if (codeCon.text.isEmpty ||
                                          codeCon.text.length != 11) {
                                        UI.setSnackBar(
                                            "Please Enter Valid IFSC Code",
                                            context);
                                        return;
                                      }
                                      if (_finalImage == null) {
                                        UI.setSnackBar(
                                            "Please Upload Document Photo",
                                            context);
                                        return;
                                      }
                                      if (adharImage == null) {
                                        UI.setSnackBar(
                                            "Please Upload Aadhaar Photo",
                                            context);
                                        return;
                                      }
                                      if (vehicleImage == null) {
                                        UI.setSnackBar(
                                            "Please Upload Vehicle Photo",
                                            context);
                                        return;
                                      }

                                      setState(() {
                                        loading = true;
                                      });
                                      print("seeeeeeeeeeeeeeeeee");
                                      submitSubscription();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "SignUp",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  File? _image,
      _finalImage,
      panImage,
      vehicleImage,
      adharImage,
      insuranceImage,
      bankImage;

  Future<File?> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Select Image Source"),
        actions: [
          TextButton(
            child: Text("Camera"),
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          TextButton(
            child: Text("Gallery"),
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    );
    if (source == null) return null;
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Widget buildUploadTile(
      String label, File? imageFile, Function(File) onImageSelected,
      {bool optional = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(optional ? "$label (Optional)" : label),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final file = await pickImage(context);
            if (file != null) {
              setState(() {
                onImageSelected(file);
              });
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.only(left: 24),
              decoration: BoxDecoration(
                border: Border.all(),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: imageFile != null
                  ? Image.file(imageFile,
                      height: 100, width: 100, fit: BoxFit.fill)
                  : Icon(Icons.camera_alt, color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // Future getImage(ImgSource source, BuildContext context, int i) async {
  //   var image = await ImagePicker.pickImage(
  //     context: context,
  //     source: source,
  //     maxHeight: 480,
  //     maxWidth: 480,
  //     cameraIcon: Icon(
  //       Icons.add,
  //       color: Colors.red,
  //     ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
  //   );
  //   getCropImage(context, i, image);
  // }
  Future getImage(ImageSource source, BuildContext context, int i) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      // context: context,
      source: source,
      maxHeight: 480,
      maxWidth: 480,
      // cameraIcon: Icon(
      //   Icons.add,
      //   color: Colors.red,
      // ),
      // imageQuality: 30,
    );

    if (image != null) {
      // getCropImage(context, i, image.path);
    }
  }

  // void getCropImage(BuildContext context, int i, var image) async {
  //   File? croppedFile = await ImageCropper().cropImage(
  //       sourcePath: image.path,
  //       aspectRatioPresets: [
  //         CropAspectRatioPreset.square,
  //         CropAspectRatioPreset.ratio3x2,
  //         CropAspectRatioPreset.original,
  //         CropAspectRatioPreset.ratio4x3,
  //         CropAspectRatioPreset.ratio16x9
  //       ],
  //       compressQuality: 40,
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Colors.lightBlueAccent,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         minimumAspectRatio: 1.0,
  //       ));
  //   setState(() {
  //     if (i == 1) {
  //       _image = File(croppedFile!.path);
  //     } else if (i == 2) {
  //       panImage = File(croppedFile!.path);
  //     } else if (i == 4) {
  //       vehicleImage = File(croppedFile!.path);
  //     } else if (i == 3) {
  //       adharImage = File(croppedFile!.path);
  //     } else if (i == 6) {
  //       insuranceImage = File(croppedFile!.path);
  //     } else if (i == 7) {
  //       bankImage = File(croppedFile!.path);
  //     } else {
  //       _finalImage = File(croppedFile!.path);
  //     }
  //   });
  // }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = false;

  Future<void> submitSubscription() async {
    await App.init();
    print("sdsdasdadsdasdasd");

    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl + "driver_registration"),
      );
      print("===============${baseUrl + "driver_registration"}===========");
      Map<String, String> headers = {
        "token": App.localStorage.getString("token").toString(),
        "Content-type": "multipart/form-data"
      };
      // request.files.add(
      //   http.MultipartFile(
      //     'user_image',
      //     _image!.readAsBytes().asStream(),
      //     _image!.lengthSync(),
      //     filename: path.basename(_image!.path),
      //     contentType: MediaType('image', 'jpeg'),
      //   ),
      // );
      request.files.add(
        http.MultipartFile(
          'vehical_imege',
          vehicleImage!.readAsBytes().asStream(),
          vehicleImage!.lengthSync(),
          filename: path.basename(vehicleImage!.path),
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      request.files.add(
        http.MultipartFile(
          'aadhar_card',
          adharImage!.readAsBytes().asStream(),
          adharImage!.lengthSync(),
          filename: path.basename(adharImage!.path),
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      if (panImage != null)
        request.files.add(
          http.MultipartFile(
            'pan_card',
            panImage!.readAsBytes().asStream(),
            panImage!.lengthSync(),
            filename: path.basename(panImage!.path),
            contentType: MediaType('image', 'jpeg'),
          ),
        );

      request.files.add(
        http.MultipartFile(
          'driving_licence_photo',
          _finalImage!.readAsBytes().asStream(),
          _finalImage!.lengthSync(),
          filename: path.basename(_finalImage!.path),
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      if (bankImage != null)
        request.files.add(
          http.MultipartFile(
            'bank_chaque',
            bankImage!.readAsBytes().asStream(),
            bankImage!.lengthSync(),
            filename: path.basename(bankImage!.path),
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      if (insuranceImage != null)
        request.files.add(
          http.MultipartFile(
            'insurance',
            insuranceImage!.readAsBytes().asStream(),
            insuranceImage!.lengthSync(),
            filename: path.basename(insuranceImage!.path),
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      request.headers.addAll(headers);
      request.fields.addAll({
        "user_fullname": nameCon.text,
        "user_phone": mobileCon.text,
        "gender": genderCon.text,
        "dob": dobCon.text,
        "bank_name": bankCon.text,
        "account_number": accountCon.text,
        "ifsc_code": codeCon.text,
        "car_no": vehicleCon.text,
        "car_type": cabId,
        "car_model": modelId,
        "device_token": fcmToken.toString(),
        "user_email": emailCon.text.trim().toString(),
        "firebaseToken": fcmToken.toString(),
        'account_type': accountTypeCon.text
      });
      print("rgistration ${request.fields}");
      if (referCon.text != "") {
        request.fields.addAll({
          "friends_code": referCon.text,
        });
      }
      print(request.fields.toString());
      print("request: " + request.toString());
      var res = await request.send();
      print("This is response:" + res.toString());
      setState(() {
        loading = false;
      });
      print(res.statusCode);
      final respStr = await res.stream.bytesToString();
      print(respStr.toString());
      if (res.statusCode == 200) {
        Map data = jsonDecode(respStr.toString());
        if (data['status']) {
          Map info = data['data'];
          UI.setSnackBar(data['message'].toString(), context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
          // navigateScreen(
          //     context, VerificationPage(info['phone'], info['otp']));
        } else {
          UI.setSnackBar(data['message'].toString(), context);
        }
      }
    } else {
      print("dasdasdasdasd1111111");
      UI.setSnackBar("No Internet Connection", context);
      setState(() {
        loading = true;
      });
    }
  }

  loginUser() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "mobile_no": mobileCon.text.trim().toString(),
          "fcm_id": fcmToken.toString(),
        };
        Map response =
            await apiBase.postAPICall(Uri.parse(baseUrl + "send_otp"), data);
        print(response);
        bool status = true;
        String msg = response['message'];
        setState(() {
          loading = false;
        });
        UI.setSnackBar(msg, context);
        if (response['status']) {
          //navigateScreen(context, VerificationPage(_numberController.text.trim()));
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

  List<CabModel> cabList = [];
  String cabId = "", cabName = "";
  List<modelModel> modelList = [];
  String modelId = "", modelName = "";

  getCab() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        var res = await http.get(Uri.parse(baseUrl + "get_cabs"));
        Map response = jsonDecode(res.body);
        print(response);
        bool status = true;
        String msg = response['message'];
        setState(() {
          loading = false;
        });
        // UI.setSnackBar(msg, context);
        if (response['status']) {
          for (var v in response['data']) {
            setState(() {
              cabList.add(new CabModel(
                  v['id'], v['car_type'], v['car_image'], v['status']));
            });
          }
          if (cabList.length > 0) {
            setState(() {
              cabId = cabList[0].id;
              cabName = cabList[0].car_type;
              carCon.text = cabList[0].car_type;
            });
          }
          getModel();
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

  getModel() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "mobile_no": mobileCon.text.trim().toString(),
          "cab_id": cabId,
        };
        Map response =
            await apiBase.postAPICall(Uri.parse(baseUrl + "get_model"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];
        setState(() {
          modelList.clear();
          loading = false;
        });
        //UI.setSnackBar(msg, context);
        if (response['status']) {
          for (var v in response['data']) {
            setState(() {
              modelList.add(new modelModel(v['id'].toString(),
                  v['car_type_id'].toString(), v['car_model'].toString()));
            });
          }
          if (modelList.length > 0) {
            setState(() {
              modelId = modelList[0].id;
              modelName = modelList[0].car_model;
              modelCon.text = modelList[0].car_model;
            });
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
}

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? initialValue;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final String? hint;
  final Function? onSuffixPressed;
  final TextCapitalization? textCapitalization;
  final bool showUnderline;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final VoidCallback? onTap;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final ValueChanged<String?>? onDropdownChanged;

  EntryField({
    this.controller,
    this.onChanged,
    this.minLines,
    this.suffixIcon,
    this.label,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.hint,
    this.maxLines,
    this.onSuffixPressed,
    this.textCapitalization,
    this.showUnderline = true,
    this.inputFormatters,
    this.obscureText = false,
    this.prefixIcon,
    this.style,
    this.onTap,
    this.dropdownItems,
    this.selectedValue,
    this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDropdown = dropdownItems != null && dropdownItems!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: label != null ? 16.0 : 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (label != null) SizedBox(height: 12),
          if (label != null)
            Text(
              label!,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Theme.of(context).hintColor),
            ),
          if (label != null) SizedBox(height: 5),
          Row(
            children: [
              if (prefixIcon != null)
                Icon(
                  prefixIcon,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              if (prefixIcon != null) SizedBox(width: 12),
              Expanded(
                child: isDropdown
                    ? DropdownButtonFormField<String>(
                        value: selectedValue,
                        items: dropdownItems!
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: onDropdownChanged,
                        decoration: InputDecoration(
                          focusedBorder: showUnderline
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                )
                              : InputBorder.none,
                          enabledBorder: showUnderline
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 0.5),
                                )
                              : InputBorder.none,
                          hintText: hint,
                          counter: Offstage(),
                        ),
                      )
                    : TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        inputFormatters: inputFormatters ?? [],
                        style: style ??
                            Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                        textCapitalization:
                            textCapitalization ?? TextCapitalization.sentences,
                        onTap: onTap,
                        obscureText: obscureText,
                        cursorColor: Theme.of(context).primaryColor,
                        autofocus: false,
                        controller: controller,
                        readOnly: readOnly ?? false,
                        onChanged: onChanged,
                        keyboardType: keyboardType,
                        minLines: minLines ?? 1,
                        initialValue: initialValue,
                        maxLength: maxLength,
                        maxLines: maxLines ?? 1,
                        decoration: InputDecoration(
                          suffixIcon: suffixIcon,
                          focusedBorder: showUnderline
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                )
                              : InputBorder.none,
                          enabledBorder: showUnderline
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 0.5),
                                )
                              : InputBorder.none,
                          hintText: hint,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                          counter: Offstage(),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
