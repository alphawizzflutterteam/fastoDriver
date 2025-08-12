import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:pristine_andaman_driver/Components/custom_button.dart';
import 'package:pristine_andaman_driver/Components/entry_field.dart';
import 'package:pristine_andaman_driver/Locale/strings_enum.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';

class SendToBankPage extends StatefulWidget {
  String total, min;

  SendToBankPage(this.total, this.min);

  @override
  _SendToBankPageState createState() => _SendToBankPageState();
}

class _SendToBankPageState extends State<SendToBankPage> {
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _bankCodeController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  ApiBaseHelper apiBase = new ApiBaseHelper();
  double totalBal = 0;
  double minimumBal = 0;
  bool isNetwork = false;
  bool saveStatus = false;
  bool getBank1 = false;

  addBank() async {
    try {
      setState(() {
        saveStatus = true;
      });
      Map params = {
        "driver_id": curUserId.toString(),
        "bank_name": _bankNameController.text.toString(),
        "bank_code": _bankCodeController.text.toString(),
        "account_number": _accountNumberController.text.toString(),
      };

      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/driver_bank"), params);
      setState(() {
        saveStatus = false;
      });
      if (response['status']) {
        setSnackbar(response['message'], context);
        addWithdraw();
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  getBank() async {
    try {
      setState(() {
        saveStatus = true;
      });
      Map params = {
        "driver_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/driver_get_bank"), params);
      setState(() {
        saveStatus = false;
      });
      if (response['status']) {
        var v = response['data'][0];
        // setSnackbar(response['message'], context);
        getBank1 = true;
        _bankNameController.text = v['bank_name'];
        _accountNumberController.text = v['account_number'];
        _bankCodeController.text = v['bank_code'];
        // addWithdraw();
      } else {
        // setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      // setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  addWithdraw() async {
    try {
      setState(() {
        saveStatus = true;
      });
      Map params = {
        "driver_id": curUserId.toString(),
        "amount": _amountController.text.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/send_windraw_request"), params);
      setState(() {
        saveStatus = false;
      });
      if (response['status']) {
        setSnackbar(response['message'], context);
        Navigator.pop(context, true);
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bankNameController.text = bankName;
    _accountNumberController.text = accountNumber;
    _bankCodeController.text = code;
    getBank();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _bankCodeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      //  drawer: AppDrawer(false),
      body: FadedSlideAnimation(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height + 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      centerTitle: true,
                      title: Text(
                        "Withdraw Money",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    // Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    //   child: Text(
                    //     getTranslated(context, "AVAILABLE_AMOUNT")!,
                    //     style: theme.textTheme.headlineSmall!
                    //         .copyWith(color: theme.hintColor),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 24),
                    //   child: Text(
                    //     '₹ ${widget.total}',
                    //     style: theme.textTheme.headlineSmall,
                    //   ),
                    // ),
                    // SizedBox(height: 32),
                    Container(
                      // color: theme.colorScheme.background,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          /* Container(
                            width: getWidth(330),
                            child: text(
                                "Note-You should have at least \u{20B9}${widget.min} to get booking request.",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.red),
                          ),*/
                          // SizedBox(
                          //   height: 12,
                          // ),
                          EntryField(
                            readOnly: true,
                            controller: _bankNameController,
                            label: getTranslated(context, "BANK_NAME"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          EntryField(
                            readOnly: true,
                            controller: _accountNumberController,
                            label: getTranslated(context, "ACC_NUM"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          EntryField(
                            readOnly: true,
                            controller: _bankCodeController,
                            label: getTranslated(context, Strings.BANK_CODE),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          EntryField(
                            keyboardType: TextInputType.number,
                            // readOnly: true,
                            controller: _amountController,
                            label: getTranslated(
                                context, Strings.ENTER_AMOUNT_TO_TRANSFER),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    !saveStatus
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: CustomButton(
                              text: getTranslated(context, "SUBMIT"),
                              onTap: () {
                                if (_bankNameController.text == "") {
                                  setSnackbar(
                                      "Please Enter Bank Name", context);
                                  return;
                                }
                                if (_accountNumberController.text == "" ||
                                    _accountNumberController.text.length < 10) {
                                  setSnackbar(
                                      "Please Enter Account Number", context);
                                  return;
                                }
                                if (_bankCodeController.text == "" ||
                                    _bankCodeController.text.length != 11) {
                                  setSnackbar(
                                      "Please Enter IFSC Code", context);
                                  return;
                                }
                                if (_amountController.text == "") {
                                  setSnackbar("Please Enter Amount", context);
                                }
                                if (double.parse(_amountController.text) > 0 &&
                                    double.parse(_amountController.text) >
                                        (double.parse(widget.total) -
                                            double.parse(widget.min))) {
                                  setSnackbar(
                                      "You can withdraw only ₹${(double.parse(widget.total) - double.parse(widget.min))}",
                                      context);
                                  return;
                                }
                                addWithdraw();
                              },
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    // Container(
                    //   color: theme.cardColor,
                    //   padding: EdgeInsets.symmetric(vertical: 20),
                    //   child: EntryField(
                    //     controller: _amountController,
                    //     inputFormatters: [
                    //       FilteringTextInputFormatter.digitsOnly
                    //     ],
                    //     keyboardType: TextInputType.number,
                    //     label: getTranslated(
                    //         context, Strings.ENTER_AMOUNT_TO_TRANSFER),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            // PositionedDirectional(
            //   start: 0,
            //   end: 0,
            //   child: !saveStatus
            //       ? CustomButton(
            //           text: getTranslated(context, "SUBMIT"),
            //           onTap: () {
            //             if (_bankNameController.text == "") {
            //               setSnackbar("Please Enter Bank Name", context);
            //               return;
            //             }
            //             if (_accountNumberController.text == "" ||
            //                 _accountNumberController.text.length < 10) {
            //               setSnackbar("Please Enter Account Number", context);
            //               return;
            //             }
            //             if (_bankCodeController.text == "" ||
            //                 _bankCodeController.text.length != 11) {
            //               setSnackbar("Please Enter IFSC Code", context);
            //               return;
            //             }
            //             if (_amountController.text == "") {
            //               setSnackbar("Please Enter Amount", context);
            //             }
            //             if (double.parse(_amountController.text) > 0 &&
            //                 double.parse(_amountController.text) >
            //                     (double.parse(widget.total) -
            //                         double.parse(widget.min))) {
            //               setSnackbar(
            //                   "You can withdraw only ₹${(double.parse(widget.total) - double.parse(widget.min))}",
            //                   context);
            //               return;
            //             }
            //             addWithdraw();
            //           },
            //         )
            //       : Center(
            //           child: CircularProgressIndicator(),
            //         ),
            // ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
