import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:pristine_andaman_driver/Components/custom_button.dart';
import 'package:pristine_andaman_driver/Components/entry_field.dart';
import 'package:pristine_andaman_driver/Locale/strings_enum.dart';
import 'package:pristine_andaman_driver/Model/cab_model.dart';
import 'package:pristine_andaman_driver/Model/user_model.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/colors.dart';
import 'package:pristine_andaman_driver/utils/common.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';

class MyProfilePage extends StatefulWidget {
  final String? isActive;
  const MyProfilePage({Key? key, this.isActive}) : super(key: key);
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController genderCon = new TextEditingController();
  TextEditingController dobCon = new TextEditingController();
  TextEditingController modelCon = new TextEditingController();
  TextEditingController vehicleCon = new TextEditingController();
  TextEditingController carCon = new TextEditingController();
  TextEditingController emerNameCon = TextEditingController();
  TextEditingController emerEmailCon = TextEditingController();
  TextEditingController emerMobileCon = TextEditingController();

  TextEditingController bankCon = new TextEditingController();
  TextEditingController accountCon = new TextEditingController();
  TextEditingController codeCon = new TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];
  bool saveStatus = true, update = false;
  String msg = "";
  UserModel? model;
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  getProfile() async {
    try {
      setState(() {
        saveStatus = true;
      });
      Map params = {
        "user_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl + "get_profile_driver"), params);
      setState(() {
        saveStatus = false;
      });
      if (response['status']) {
        var data = response["data"];
        model = UserModel.fromJson(data);
        msg = response["notification"] != null ? response["notification"] : "";
        print(data);
        name = data['user_name'] ?? '';
        mobile = data['phone'] ?? '';
        email = data['email'] ?? '';
        gender1 = data['gender'] ?? '';
        homeAddress = (data['home_address'] ?? '').toString();
        // walletAccount = data['wallet_amount'];
        dob = data['dob'] ?? '';
        if (response['rating'] != null) {
          rating =
              double.parse(response['rating'].toString()).toStringAsFixed(2);
        }
        imagePath = response['image_path'].toString();
        image = data['user_image'] ?? '';
        print("image valus is ${image}");
        drivingImage = data['driving_licence_photo'] ?? '';
        panCard = data['pan_card'] ?? '';
        adharCard = data['aadhar_card'] ?? '';
        vehicle = data['vehical_imege'] ?? '';
        insurance = data['insurance'] ?? '';
        cheque = data['bank_chaque'] ?? '';
        brand = data['car_type'] ?? '';
        model2 = data['car_model'] ?? '';
        number = data['car_no'] ?? '';
        bankName = data['bank_name'] ?? '';
        accountNumber = data['account_number'] ?? '';
        code = data['ifsc_code'] ?? '';
        profileStatus = data['profile_status'] ?? '';
        isActive = data['is_active'] ?? '';
        reject = data['reject'] ?? '';
        print("dta" + data['profile_status']);
        nameCon.text = name;
        emerNameCon.text = data['emergency_name'] ?? '';
        emerEmailCon.text = data['emergency_gmail'] ?? '';
        emerMobileCon.text = data['emergency_mobile'] ?? '';
        mobileCon.text = mobile;
        emailCon.text = email;
        vehicleCon.text = number;
        carCon.text = brand;
        genderCon.text = gender1;
        dobCon.text = dob;
        bankCon.text = bankName;
        codeCon.text = code;
        accountCon.text = accountNumber;
        carCon.text = brand;
        modelId = model2;
        print("modelId$modelId");
        refer = data['referral_code'] ?? '';
      } else {
        // setSnackbar(response['message'], context);
      }
      getCab();
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
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
        checkChange(model!.dob!, dobCon.text, 4);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  PersistentBottomSheetController? persistentBottomSheetController1;
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
                        persistentBottomSheetController1!.setState!(() {
                          genderCon.text = gender[index];
                        });
                        Navigator.pop(context);
                        checkChange(model!.gender!, genderCon.text, 3);
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

  int checkField = 0;
  checkChange(String first, second, int number) {
    if (first.toLowerCase() != second.toLowerCase()) {
      print("okay");
      if (!update)
        setState(() {
          update = true;
          checkField = number;
        });
    } else {
      print("no");
      if (checkField == number) {
        setState(() {
          update = false;
          checkField = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        backgroundColor: MyColorName.colorBg1,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 20,
            fontFamily:  AppTheme.fontFamily,
            color: MyColorName.secondary,),
        ),
      ),
      body: !saveStatus
          ? SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(182),
                            border: Border.all(
                              color: Colors.black, // border color
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 70, // Adjust size
                            backgroundColor: Colors.green.shade50,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : (image != null && image.isNotEmpty
                                    ? NetworkImage("$image") as ImageProvider
                                    : null),
                            child:
                                _image == null && (image == null || image.isEmpty)
                                    ? Text(
                                        "Upload Profile Pic",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      )
                                    : null,
                          ),
                        ),
                        // Edit Icon
                        Positioned(
                          bottom: 5,
                          right: 20,
                          child: InkWell(
                            onTap: () {
                              if (profileStatus == "0") return;
                              _pickImage();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border: Border.all(
                                  color: Colors.black, // border color
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      // color: theme.colorScheme.background,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EntryField(
                            label: getTranslated(context, "ENTER_PHONE")!,
                            controller: mobileCon,
                            onChanged: (val) {
                              checkChange(model!.phone!, val, 9);
                            },
                            //initialValue: mobile,
                            //readOnly: true,
                          ),
                          EntryField(
                            label: getTranslated(context, Strings.FULL_NAME),
                            controller: nameCon,
                            onChanged: (val) {
                              checkChange(model!.userName!, val, 1);
                            },
                            keyboardType: TextInputType.name,
                          ),
                          EntryField(
                            label:
                                "${getTranslated(context, Strings.EMAIL_ADD)} (optional)",
                            controller: emailCon,
                            onChanged: (val) {
                              checkChange(model!.email!, val, 2);
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          gender.length > 0
                              ? EntryField(
                                  maxLength: 10,
                                  readOnly: true,
                                  controller: genderCon,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  onTap: () {
                                    showBottom1();
                                  },
                                  label: getTranslated(context, "GENDER")!,
                                )
                              : SizedBox(),
                          EntryField(
                            label: getTranslated(context, "DOB")!,
                            controller: dobCon,
                            readOnly: true,
                            onTap: () {
                              selectDate(context);
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 24, vertical: 20),
                          //   child: Text(
                          //     'Emergency Contact Person Details',
                          //     style: theme.textTheme.headlineSmall,
                          //   ),
                          // ),
                          //
                          // EntryField(
                          //   readOnly: true,
                          //   //  initialValue: name.toString(),
                          //   controller: emerNameCon,
                          //   keyboardType: TextInputType.name,
                          //   label: getTranslated(context, 'FULL_NAME'),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          //
                          // EntryField(
                          //   readOnly: true,
                          //   label: getTranslated(context, 'ENTER_PHONE'),
                          //   // initialValue: mobile.toString(),
                          //   controller: emerMobileCon,
                          //   maxLength: 10,
                          //   keyboardType: TextInputType.phone,
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // EntryField(
                          //   readOnly: true,
                          //   //initialValue: email.toString(),
                          //   controller: emerEmailCon,
                          //   label: getTranslated(context, 'EMAIL_ADD'),
                          //   keyboardType: TextInputType.emailAddress,
                          // ),
                          // Divider(
                          //   color: Colors.black,
                          //   thickness: 5,
                          // ),
                          // SizedBox(height: 10),
                          // Text(
                          //   getTranslated(context, Strings.CAR_INFO)!,
                          //   style: theme.textTheme.headlineMedium,
                          // ),
                          // EntryField(
                          //   controller: carCon,
                          //   //initialValue: brand,
                          //   onTap: () {
                          //     if (profileStatus != "1") {
                          //       showBottom();
                          //     }
                          //   },
                          //   label: getTranslated(context, Strings.CAR_BRAND),
                          //   hint: getTranslated(
                          //       context, Strings.SELECT_CAR_BRAND),
                          //   suffixIcon: Icon(Icons.arrow_drop_down),
                          //   readOnly: true,
                          // ),
                          // carCon.text.toLowerCase() != "auto"
                          //     ? EntryField(
                          //         onTap: () {
                          //           showBottom2();
                          //         },
                          //         controller: modelCon,
                          //         readOnly: true,
                          //         label:
                          //             getTranslated(context, Strings.CAR_MODEL),
                          //         hint: getTranslated(
                          //             context, Strings.SELECT_CAR_MODEL),
                          //         suffixIcon: Icon(Icons.arrow_drop_down),
                          //       )
                          //     : SizedBox(),
                          EntryField(
                            //    initialValue: number,
                            controller: vehicleCon,
                            onChanged: (val) {
                              checkChange(model!.carNo!, val, 5);
                            },
                            label: getTranslated(context, Strings.VEHICLE_NUM),
                            hint: getTranslated(
                                context, Strings.ENTER_VEHICLE_NUM),
                          ),
                          // SizedBox(height: 20),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 24),
                          //   child: Text(
                          //     getTranslated(context, "BANK_INFO")!,
                          //     style: theme.textTheme.headlineMedium,
                          //   ),
                          // ),
                          EntryField(
                            maxLength: 16,
                            keyboardType: TextInputType.phone,
                            controller: accountCon,
                            onChanged: (val) {
                              checkChange(model!.accountNumber!, val, 6);
                            },
                            label: getTranslated(context, "Accountnumber")!,
                            hint: "",
                          ),
                          EntryField(
                            keyboardType: TextInputType.text,
                            controller: bankCon,
                            label: getTranslated(context, "BANK_NAME")!,
                            onChanged: (val) {
                              checkChange(model!.bankName!, val, 7);
                            },
                            hint: "",
                          ),
                          EntryField(
                            maxLength: 11,
                            keyboardType: TextInputType.text,
                            controller: codeCon,
                            onChanged: (val) {
                              checkChange(model!.ifscCode!, val, 8);
                            },
                            label: getTranslated(context, "BANK_CODE")!,
                            hint: "",
                          ),
                          // SizedBox(height: 20),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 24),
                          //   child: Text(
                          //     getTranslated(context, Strings.DOCUMENT)!,
                          //     style: theme.textTheme.headlineMedium,
                          //   ),
                          // ),

                          // SizedBox(height: 10),
                          // Container(
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.only(left: 30, right: 20),
                          //     child:
                          //         Text(getTranslated(context, "UPLOAD_BANK")!),
                          //   ),
                          // ),
                          // SizedBox(height: 10),
                          // InkWell(
                          //   onTap: () {
                          //     if (profileStatus == "0") {
                          //       return;
                          //     }
                          //     // requestPermission(context, 7);
                          //   },
                          //   child: Container(
                          //     width: getWidth(300),
                          //     padding:
                          //         const EdgeInsets.only(left: 30, right: 20),
                          //     child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(10),
                          //         child: bankImage == null
                          //             ? cheque == null || cheque.isEmpty
                          //                 ? DottedBorder(
                          //                     color: Colors.green,
                          //                     // Dotted border color
                          //                     strokeWidth: 2,
                          //                     dashPattern: [8, 4],
                          //                     // Dotted pattern
                          //                     borderType: BorderType.RRect,
                          //                     radius: const Radius.circular(8),
                          //                     child: Container(
                          //                       height: 200,
                          //                       color: Colors.green.shade50,
                          //                       alignment: Alignment.center,
                          //                       child: Text(
                          //                         "Upload Bank Cheque",
                          //                         style: const TextStyle(
                          //                             fontSize: 18,
                          //                             color: Colors.green),
                          //                       ),
                          //                     ),
                          //                   )
                          //                 : Image.network(
                          //                     "${imagePath}${cheque}",
                          //                     height: 200,
                          //                     fit: BoxFit.fill,
                          //                     colorBlendMode:
                          //                         profileStatus == "0"
                          //                             ? BlendMode.hardLight
                          //                             : BlendMode.color,
                          //                     color: profileStatus == "0"
                          //                         ? Colors.white
                          //                             .withOpacity(0.4)
                          //                         : Colors.transparent,
                          //                   )
                          //             : Image.file(
                          //                 bankImage!,
                          //                 height: 100,
                          //                 width: 100,
                          //                 fit: BoxFit.fill,
                          //               )),
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildUploadBox(
                                  label: "Driving License",
                                  fileImage: _finalImage,
                                  networkImage: drivingImage,
                                  onTap: () => pickImage((file) =>
                                      setState(() => _finalImage = file)),
                                ),
                                buildUploadBox(
                                  label: "Passbook",
                                  fileImage: panImage,
                                  networkImage: panCard,
                                  onTap: () => pickImage((file) =>
                                      setState(() => panImage = file)),
                                ),
                                buildUploadBox(
                                  label: "Aadhaar Card(Front)",
                                  fileImage: adharImage,
                                  networkImage: adharCard,
                                  onTap: () => pickImage((file) =>
                                      setState(() => adharImage = file)),
                                ),
                                buildUploadBox(
                                  label: "Aadhaar Card(Back)",
                                  fileImage: insuranceImage,
                                  networkImage: insurance,
                                  onTap: () => pickImage((file) => setState(
                                      () => insuranceImage = file)),
                                ),
                                buildUploadBox(
                                  label: "Upload RC",
                                  fileImage: bankImage,
                                  networkImage: cheque,
                                  onTap: () => pickImage((file) => setState(
                                      () => bankImage = file)),
                                ),
                                buildUploadBox(
                                  label: "Vehicle Image",
                                  fileImage: vehicleImage,
                                  networkImage: vehicle,
                                  onTap: () => pickImage((file) =>
                                      setState(() => vehicleImage = file)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
      bottomNavigationBar: !loading
          ? Container(
              width: getWidth(375),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(
                  //   width: getWidth(360),
                  //   decoration:
                  //       BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  //   child: CustomButton(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //     icon: Icons.circle,
                  //     textColor: profileStatus == "0"
                  //         ? Colors.yellow
                  //         : profileStatus == "1"
                  //             ? Colors.green
                  //             : Colors.red,
                  //     text: profileStatus == "0"
                  //         ? getTranslated(context, "WAIT")!
                  //         : profileStatus == "1"
                  //             ? getTranslated(context, "APPROVED")!
                  //             : getTranslated(context, "REJECTED")!,
                  //     onTap: () {},
                  //   ),
                  // ),
                  // profileStatus != "0" && profileStatus != "1"
                  //     ? Container(
                  //         width: getWidth(375),
                  //         color: Colors.white,
                  //         padding: EdgeInsets.all(5),
                  //         child: Text(
                  //           msg,
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(color: Colors.red),
                  //         ))
                  //     : SizedBox(),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    borderRadius: BorderRadius.circular(10),
                    text: getTranslated(context, "Updateprofile")!,
                    color: update
                        ? Theme.of(context).primaryColor
                        : AppTheme.primaryColor,
                    onTap: profileStatus == "0"
                        ? () {
                            setSnackbar("Please Wait For Review", context);
                          }
                        : () {
                            if (mobileCon.text == "" ||
                                mobileCon.text.length != 10) {
                              setSnackbar(
                                  "Please Enter Valid Mobile Number", context);
                              return;
                            }
                            // if (!update) {
                            //   setSnackbar(
                            //       "Please Change Some Thing", context);
                            //   return;
                            // }
                            if (validateField(
                                    nameCon.text, "Please Enter Full Name") !=
                                null) {
                              setSnackbar("Please Enter Full Name", context);
                              return;
                            }
                            if (emerMobileCon.text.length > 0 &&
                                emerMobileCon.text.length != 10) {
                              setSnackbar(
                                  "Please Enter Valid Emergency Mobile Number",
                                  context);
                              return;
                            }
                            if (emerEmailCon.text.length > 0 &&
                                validateEmail(
                                        emerEmailCon.text,
                                        ' Please Enter Valid Email',
                                        'Please Enter Valid Email') !=
                                    null) {
                              setSnackbar(
                                  validateEmail(
                                          emerEmailCon.text,
                                          'Please Enter Valid Email',
                                          'Please Enter Valid Email')
                                      .toString(),
                                  context);
                              return;
                            }
                            /*if (validateEmail(
                                    emailCon.text,
                                    "Please Enter Email",
                                    "Please Enter Valid Email") !=
                                null) {
                              setSnackbar(
                                  validateEmail(
                                          emailCon.text,
                                          "Please Enter Email",
                                          "Please Enter Valid Email")
                                      .toString(),
                                  context);
                              return;
                            }*/
                            if (vehicleCon.text == "" ||
                                vehicleCon.text.length != 10) {
                              setSnackbar(
                                  "Please Enter Valid Vehicle Number", context);
                              return;
                            }
                            // if (accountCon.text == "" ||
                            //     accountCon.text.length < 10) {
                            //   setSnackbar("Please Enter Valid Account Number",
                            //       context);
                            //   return;
                            // }
                            // if (bankCon.text == "") {
                            //   setSnackbar(
                            //       "Please Enter Valid Bank Name", context);
                            //   return;
                            // }
                            // if (codeCon.text == "" ||
                            //     codeCon.text.length != 11) {
                            //   setSnackbar("Please Enter Valid Code", context);
                            //   return;
                            // }
                            setState(() {
                              loading = true;
                            });
                            _updateProfile();
                          },
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            )
          : Container(
              width: 50,
              height: 50,
              child: Center(child: CircularProgressIndicator())),
    );
  }

  Future<void> _updateProfile() async {
    await App.init();

    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl + "update_driver_profile"),
        );
        Map<String, String> headers = {
          "token": App.localStorage.getString("token").toString(),
          "Content-type": "multipart/form-data"
        };
        if (_image != null)
          request.files.add(
            http.MultipartFile(
              'user_image',
              _image!.readAsBytes().asStream(),
              _image!.lengthSync(),
              filename: path.basename(_image!.path),
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        if (vehicleImage != null)
          request.files.add(
            http.MultipartFile(
              'vehical_imege',
              vehicleImage!.readAsBytes().asStream(),
              vehicleImage!.lengthSync(),
              filename: path.basename(vehicleImage!.path),
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        if (adharImage != null)
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
        if (_finalImage != null)
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
          "user_id": curUserId.toString(),
          "gender": genderCon.text,
          "dob": dobCon.text,
          "account_number": accountCon.text,
          "ifsc_code": codeCon.text,
          "bank_name": bankCon.text,
          "user_fullname": nameCon.text,
          "user_phone": mobileCon.text,
          "car_no": vehicleCon.text,
          "car_type": cabId,
          "car_model": modelId,
          "user_email":
              emailCon.text != "" ? emailCon.text.trim().toString() : "",
          'emergency_name': emerNameCon.text,
          'emergency_mobile': emerMobileCon.text,
          'emergency_gmail': emerEmailCon.text,
          // "firebaseToken": "no data",
        });
        /* if(referCon.text!=""){
          request.fields.addAll({
            "friends_code": referCon.text,
          });
        }*/
        print("request: " + request.toString());
        var res = await request.send();
        print("This is response:" + res.toString());
        setState(() {
          loading = false;
        });
        print(res.statusCode);
        if (res.statusCode == 200) {
          final respStr = await res.stream.bytesToString();
          print(respStr.toString());
          Map data = jsonDecode(respStr.toString());

          if (data['status']) {
            //  Map info = data['data'];
            setSnackbar(data['message'].toString(), context);
            await App.init();
            App.localStorage.clear();
            Navigator.pop(context);
            //Common().toast("Logout");
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => LoginPage()),
            //     (route) => false);
            /*if (isActive == "1" && reject == "1") {
              await App.init();
              App.localStorage.clear();
              //Common().toast("Logout");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => OfflinePage("")),
                  (route) => false);
            }*/
          } else {
            setSnackbar(data['message'].toString(), context);
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
        setState(() {
          loading = true;
        });
      }
    } else {
      setSnackbar("No Internet Connection", context);
      setState(() {
        loading = true;
      });
    }
  }

  File? drivingImageFile;
  String? drivingImageUrl;

  File? passportImageFile;
  String? passportImageUrl;

  File? aadhaarImageFile;
  String? aadhaarImageUrl;

  File? insuranceImageFile;
  String? insuranceImageUrl;

  File? rcImageFile;
  String? rcImageUrl;

  File? vehicleImageFile;
  String? vehicleImageUrl;

  final ImagePicker picker = ImagePicker();

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

  PersistentBottomSheetController? persistentBottomSheetController2;
  showBottom2() async {
    persistentBottomSheetController2 =
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
                          persistentBottomSheetController2!.setState!(() {
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

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);

                  if (pickedFile != null) {
                    _updateImage(File(pickedFile.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    _updateImage(File(pickedFile.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateImage(File imageFile) {
    setState(() {
      _image = File(imageFile.path);
    });
  }

//   void requestPermission(BuildContext context, int i) async {
//     if (await Permission.camera.isPermanentlyDenied ||
//         await Permission.storage.isPermanentlyDenied) {
//       // The user opted to never again see the permission request dialog for this
//       // app. The only way to change the permission's status now is to let the
//       // user manually enable it in the system settings.
//       openAppSettings();
//     } else {
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.camera,
//         Permission.storage,
//       ].request();
// // You can request multiple permissions at once.
//
//       if (statuses[Permission.camera] == PermissionStatus.granted &&
//           statuses[Permission.storage] == PermissionStatus.granted) {
//         getImage(ImageSource.gallery, context, i);
//       } else {
//         if (await Permission.camera.isDenied ||
//             await Permission.storage.isDenied) {
//           // The user opted to never again see the permission request dialog for this
//           // app. The only way to change the permission's status now is to let the
//           // user manually enable it in the system settings.
//           openAppSettings();
//         } else {
//           setSnackbar("Oops you just denied the permission", context);
//         }
//       }
//     }
//   }

  File? _image,
      _finalImage,
      panImage,
      vehicleImage,
      adharImage,
      insuranceImage,
      bankImage;

  Widget buildUploadBox({
    required String label,
    required File? fileImage,
    required String? networkImage,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 175, // Same as dotted border
              width: double.infinity, // Full width or specify a width
              child: fileImage != null
                  ? Image.file(
                fileImage,
                fit: BoxFit.cover,
              )
                  : (networkImage != null && networkImage.isNotEmpty)
                  ? Image.network(
                networkImage.startsWith('http')
                    ? networkImage
                    : "$imagePath$networkImage",
                fit: BoxFit.cover,
                colorBlendMode:
                profileStatus == "0" ? BlendMode.hardLight : null,
                color: profileStatus == "0"
                    ? Colors.white.withOpacity(0.4)
                    : null,
              )
                  : DottedBorder(
                color: Colors.green,
                strokeWidth: 2,
                dashPattern: [8, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(8),
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  color: Colors.green.shade50,
                  child: Text(
                    "Upload $label",
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(label),
    //     SizedBox(height: 10),
    //     InkWell(
    //       onTap: onTap,
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(10),
    //         child: fileImage != null
    //             ? Image.file(fileImage, height: 150, fit: BoxFit.cover)
    //             : (networkImage != null && networkImage.isNotEmpty)
    //                 ? Image.network(
    //                     networkImage.startsWith('http')
    //                         ? networkImage
    //                         : "$imagePath$networkImage",
    //                     height: 150,
    //                     fit: BoxFit.cover,
    //                     colorBlendMode:
    //                         profileStatus == "0" ? BlendMode.hardLight : null,
    //                     color: profileStatus == "0"
    //                         ? Colors.white.withOpacity(0.4)
    //                         : null,
    //                   )
    //                 : DottedBorder(
    //                     color: Colors.green,
    //                     strokeWidth: 2,
    //                     dashPattern: [8, 4],
    //                     borderType: BorderType.RRect,
    //                     radius: Radius.circular(8),
    //                     child: Container(
    //                       height: 120,
    //                       color: Colors.green.shade50,
    //                       alignment: Alignment.center,
    //                       child: Text(
    //                         "Upload $label",
    //                         style: TextStyle(fontSize: 18, color: Colors.green),
    //                       ),
    //                     ),
    //                   ),
    //       ),
    //     ),
    //     SizedBox(height: 20),
    //   ],
    // );
  }

  Future<void> pickImage(Function(File) onImagePicked) async {
    if (profileStatus == "0") return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pick from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final picked =
                    await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  onImagePicked(File(picked.path));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final picked =
                    await picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  onImagePicked(File(picked.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future getImage(ImageSource source, BuildContext context, int i) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: source,
      // source: ImageSource.camera,
      imageQuality: 30,
    );

    if (image != null) {
      setState(() {
        update = true;
        if (i == 1) {
          _image = File(image!.path);
        } else if (i == 2) {
          panImage = File(image!.path);
        } else if (i == 4) {
          vehicleImage = File(image!.path);
        } else if (i == 3) {
          adharImage = File(image!.path);
        } else if (i == 6) {
          insuranceImage = File(image!.path);
        } else if (i == 7) {
          bankImage = File(image!.path);
        } else {
          _finalImage = File(image!.path);
        }
      });
      // getCropImage(context, i, image.path);
    }
  }
  // Future getImage(ImgSource source, BuildContext context, int i) async {
  //   var image = await ImagePickerGC.pickImage(
  //     context: context,
  //     source: source, imageQuality: 30,
  //     cameraIcon: Icon(
  //       Icons.add,
  //       color: Colors.red,
  //     ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
  //   );
  //   getCropImage(context, i, image);
  // }

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
  //       compressQuality: 60,
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
  //     update = true;
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

  List<CabModel> cabList = [];
  String cabId = "", cabName = "";
  List<modelModel> modelList = [];
  String modelId = "", modelName = "";
  TextEditingController mobileCon = new TextEditingController();
  TextEditingController referCon = new TextEditingController();
  TextEditingController emailCon = new TextEditingController();
  TextEditingController nameCon = new TextEditingController();

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = false;
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
        // setSnackbar(msg, context);
        if (response['status']) {
          for (var v in response['data']) {
            setState(() {
              cabList.add(new CabModel(
                  v['id'], v['car_type'], v['car_image'], v['status']));
            });
          }
          if (cabList.length > 0) {
            setState(() {
              /* if(cabId==""){
                cabId = cabList[0].id;
                cabName = cabList[0].car_type;
                carCon.text = cabList[0].car_type;
              }else{
                int i =cabList.indexWhere((element) => element.id==cabId);
                if(i!=-1){
                  cabId = cabList[i].id;
                  cabName = cabList[i].car_type;
                  carCon.text = cabList[i].car_type;
                }

              }*/
              if (carCon.text == "") {
                cabId = cabList[0].id;
                cabName = cabList[0].car_type;
                carCon.text = cabList[0].car_type;
              } else {
                int i = cabList
                    .indexWhere((element) => element.car_type == carCon.text);
                cabId = cabList[i].id;
                cabName = cabList[i].car_type;
                carCon.text = cabList[i].car_type;
              }
            });
          }
          getModel();
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
        setState(() {
          loading = false;
        });
      }
    } else {
      setSnackbar("No Internet Connection", context);
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
        //setSnackbar(msg, context);
        if (response['status']) {
          for (var v in response['data']) {
            setState(() {
              modelList.add(new modelModel(v['id'].toString(),
                  v['car_type_id'].toString(), v['car_model'].toString()));
            });
          }
          if (modelList.length > 0) {
            if (modelId != "") {
              int i = modelList.indexWhere((element) => element.id == modelId);
              if (i != -1) {
                setState(() {
                  modelId = modelList[i].id;
                  modelName = modelList[i].car_model;
                  modelCon.text = modelList[i].car_model;
                });
              } else {}
            } else {
              setState(() {
                modelId = modelList[0].id;
                modelName = modelList[0].car_model;
                modelCon.text = modelList[0].car_model;
              });
            }
          }
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
        setState(() {
          loading = false;
        });
      }
    } else {
      setSnackbar("No Internet Connection", context);
      setState(() {
        loading = false;
      });
    }
  }
}
