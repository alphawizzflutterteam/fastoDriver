import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pristine_andaman_driver/Components/entry_field.dart';
import 'package:pristine_andaman_driver/Model/wallet_model.dart';
import 'package:pristine_andaman_driver/Routes/page_routes.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/Razorpay.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';

class WalletPage extends StatefulWidget {
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  ApiBaseHelper apiBase = new ApiBaseHelper();
  double totalBal = 0;
  double minimumBal = 0;
  bool isNetwork = false;
  bool saveStatus = true;
  bool showText = false;
  TextEditingController amount = new TextEditingController();
  getSetting() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "user_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/minimum_balance"), params);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        var data = response["data"][0];
        print(data);
        minimumBal = double.parse(data['wallet_amount'].toString());
        amount.text = minimumBal.toString().split(".")[0];
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

  //Schedule Ride
  List<WalletModel> walletList = [];
  getWallet() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "user_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/get_wallet"), params);
      setState(() {
        saveStatus = true;
        walletList.clear();
      });
      if (response['status']) {
        var data = response["data"];
        for (var v in data) {
          print(v['created_at']);
          setState(() {
            walletList.add(new WalletModel.fromJson(v));
          });
        }
        print(data);
        totalBal = double.parse(response['wallet'].toString());
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

  List<WithdrawModel> withdrawList = [];

  getWithdraw() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "driver_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/get_widrwwal"), params);
      setState(() {
        saveStatus = true;
        withdrawList.clear();
      });
      if (response['status']) {
        var data = response["data"];
        for (var v in data) {
          setState(() {
            withdrawList.add(new WithdrawModel(
                v['id'], v['amount'], v['status'], v['added_date']));
          });
        }
        print(data);
        totalBal = double.parse(response['wallet'].toString());
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

  bool loading = false;
  bool showWithdraw = false;
  addWallet(orderId) async {
    try {
      setState(() {
        loading = true;
      });
      Map params = {
        "user_id": curUserId.toString(),
        "Amount": amount.text.contains(".")
            ? amount.text.toString().split(".")[0]
            : amount.text.toString(),
        "txn_id": orderId.toString(),
        "txn_date": DateTime.now().toString(),
        "status": "Paid",
        "gateway_name": "Razorpay",
      };
      print("add money ${params}");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/wallet"), params);
      setState(() {
        loading = false;
      });
      amount.clear();
      if (response['status']) {
        setSnackbar(response['message'], context);
        getWallet();
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
    getSetting();
    getWallet();
    getWithdraw();
  }

  Future<bool> onWill() {
    Navigator.pop(context, true);
    /* Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );*/
    /*Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SearchLocationPage()),
        (route) => false);*/

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: onWill,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          centerTitle: true,
          title: Text(
            "Wallet",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        //drawer: AppDrawer(false),
        body: SingleChildScrollView(
          child: saveStatus
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),

                          // Available Balance
                          Text(
                            getTranslated(context, "AVAILABLE_AMOUNT") ?? "",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${totalBal ?? "0"}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          // Amount Entry Field
                          EntryField(
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: amount,
                            hint: getTranslated(context, "EnterAmount") ?? "",
                            label: getTranslated(context, "EnterAmount") ?? "",
                          ),
                          const SizedBox(height: 16),

                          // Add Money Button
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 20),
                            child: SizedBox(
                              width: 250,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                onPressed: loading
                                    ? null
                                    : () {
                                        if (amount.text.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: "Please enter an amount");
                                          return;
                                        }

                                        double enteredAmount =
                                            double.tryParse(amount.text) ?? 0;
                                        if (enteredAmount <= 0) {
                                          Fluttertoast.showToast(
                                              msg: "Enter a valid amount");
                                          return;
                                        }
                                        // Optional: Minimum amount check
                                        // if (enteredAmount < 100) {
                                        //   ScaffoldMessenger.of(context).showSnackBar(
                                        //     SnackBar(
                                        //       content: Text("Minimum amount is ₹100"),
                                        //       backgroundColor: Colors.red,
                                        //     ),
                                        //   );
                                        //   return;
                                        // }
                                        RazorPayHelper razorPay =
                                            RazorPayHelper(
                                          amount.text,
                                          context,
                                          (result) {
                                            if (result != "error") {
                                              addWallet(result);
                                            } else {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          },
                                        );
                                        setState(() {
                                          loading = true;
                                        });
                                        razorPay.init();
                                      },
                                child: loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        getTranslated(context, "Addmoney") ??
                                            "",
                                        style: TextStyle(
                                          fontFamily: fontMedium,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // boxHeight(5),
                    showText
                        ? Container(
                            width: getWidth(330),
                            decoration:
                                boxDecoration(radius: 10, showShadow: true),
                            child: Column(
                              children: [
                                EntryField(
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: amount,
                                  label: getTranslated(context, "Enteramonut")!,
                                ),
                                boxHeight(10),
                                InkWell(
                                  onTap: () {
                                    RazorPayHelper razorPay =
                                        new RazorPayHelper(amount.text, context,
                                            (result) {
                                      if (result != "error") {
                                        addWallet(result);
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    });
                                    setState(() {
                                      loading = true;
                                    });
                                    razorPay.init();
                                  },
                                  child: Container(
                                    width: 80.w,
                                    height: 5.h,
                                    decoration: boxDecoration(
                                        radius: 5,
                                        bgColor:
                                            Theme.of(context).primaryColor),
                                    child: Center(
                                      child: !loading
                                          ? text(
                                              getTranslated(
                                                  context, "Addmoney")!,
                                              fontFamily: fontMedium,
                                              fontSize: 13.sp,
                                              isCentered: true,
                                              textColor: Colors.white)
                                          : CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ),
                                boxHeight(10),
                              ],
                            ),
                          )
                        : SizedBox(),
                    boxHeight(10),
                    Container(
                      width: getWidth(330),
                      child: text(
                          // 'Note-You need to add minimum \u{20B9}500 to get booking request.',
                          totalBal < 500
                              ? "Note-You need to add minimum \u{20B9}500 to get booking request."
                              : "Note-Please maintain \u{20B9}${minimumBal} minimum balance to take rides.",
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.red),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, "RECENT_TRANS")!,
                            style: theme.textTheme.headlineSmall!
                                .copyWith(color: theme.hintColor),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     setState(() {
                          //       showWithdraw = !showWithdraw;
                          //     });
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.all(getWidth(10)),
                          //     decoration: boxDecoration(
                          //         radius: 10, color: MyColorName.primaryDark),
                          //     child: Text(
                          //       showWithdraw
                          //           ? "Hide History"
                          //           : getTranslated(
                          //               context, "Withdrawhistory")!,
                          //       style: theme.textTheme.headlineSmall!
                          //           .copyWith(color: theme.hintColor),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    !showWithdraw
                        ? saveStatus
                            ? walletList.length > 0
                                ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: walletList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final item = walletList[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Card(
                                          elevation: 5,
                                          child: ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6),
                                            title: Text(
                                              item.note != null &&
                                                      item.note!.isNotEmpty
                                                  ? item.note!
                                                  : "Transaction ID - ${item.txnId}",
                                              style: theme
                                                  .textTheme.headlineSmall!
                                                  .copyWith(fontSize: 15),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getDate(item
                                                      .createdAt), // Format date as needed
                                                  style: theme
                                                      .textTheme.headlineSmall!
                                                      .copyWith(fontSize: 15),
                                                ),
                                                // Text(
                                                //   "Status: ${item.status}",
                                                //   style: theme
                                                //       .textTheme.bodySmall!
                                                //       .copyWith(
                                                //           color: Colors.grey),
                                                // ),
                                              ],
                                            ),
                                            trailing: Text(
                                              "${item.sign == "+" ? "+" : "-"}₹${item.balance}",
                                              style: theme
                                                  .textTheme.headlineSmall!
                                                  .copyWith(
                                                color: item.sign == "+"
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontSize: 17,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  PageRoutes.rideInfoPage);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: text(
                                        getTranslated(
                                            context, "Notransaction")!,
                                        fontFamily: fontMedium,
                                        fontSize: 12.sp,
                                        textColor: Colors.black),
                                  )
                            : Center(child: CircularProgressIndicator())
                        : saveStatus
                            ? walletList.length > 0
                                ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: withdrawList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.only(bottom: 4.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 6),
                                        tileColor: theme.colorScheme.background,
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(image.toString(),
                                              height: 60, width: 60),
                                        ),
                                        title: Text(
                                          withdrawList[index].status == "0"
                                              ? "Status - Pending"
                                              : withdrawList[index].status ==
                                                      "1"
                                                  ? "Status - Confirm"
                                                  : "Status - Cancel",
                                          style: theme.textTheme.headlineSmall!
                                              .copyWith(fontSize: 17),
                                        ),
                                        subtitle: Text(
                                          '${getDate(withdrawList[index].added_date)}',
                                          style: theme.textTheme.headlineSmall,
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              ' \u{20B9}${withdrawList[index].amount}',
                                              style: theme
                                                  .textTheme.headlineSmall!
                                                  .copyWith(
                                                      color: Colors.red,
                                                      fontSize: 17),
                                            ),
                                            /*  SizedBox(height: 4),
                          Text(
                            getTranslated(context,Strings.RIDE_INFO)! + '  >',
                            style: theme.textTheme.caption!
                                .copyWith(color: theme.primaryColor),
                          ),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: text("No Withdrawal",
                                        fontFamily: fontMedium,
                                        fontSize: 12.sp,
                                        textColor: Colors.black),
                                  )
                            : Center(child: CircularProgressIndicator())
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class WithdrawModel {
  String id, amount, status, added_date;
  WithdrawModel(this.id, this.amount, this.status, this.added_date);
}
