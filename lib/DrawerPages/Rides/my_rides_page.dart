import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pristine_andaman_driver/DrawerPages/Rides/ride_info_new.dart';
import 'package:pristine_andaman_driver/Model/my_ride_model.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';

import '../Home/offline_page.dart';

class MyRidesPage extends StatefulWidget {
  int selected;

  MyRidesPage({this.selected = 1});

  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

class _MyRidesPageState extends State<MyRidesPage> {
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = true;
  List<MyRideModel> rideList = [];

  getRides(type) async {
    try {
      setState(() {
        loading = true;
      });
      Map params = {
        "driver_id": curUserId,
        "type": type,
      };
      print("GET ALL COMPLETE ========= $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/get_all_complete"), params);
      setState(() {
        loading = false;
        rideList.clear();
      });
      if (response['status']) {
        print(response['data']);
        for (var v in response['data']) {
          setState(() {
            selectedFil = "All";
            rideList.add(MyRideModel.fromJson(v));
          });
        }
      } else {
        setState(() {
          selectedFil = "All";
        });
        // setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.selected;
    getRides("1");
    // if (widget.selected) {
    //   getRides("3");
    // } else {
    //   getRides("3");
    // }
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

  int selected = 1;
  List<String> filter = ["All", "Today", "Weekly", "Monthly"];
  String selectedFil = "All";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: onWill,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "My Ride",
            style: theme.textTheme.headlineSmall!.copyWith(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /*  Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  getTranslated(context,Strings.MY_RIDES)!,
                  style: theme.textTheme.headline4,
                ),
              ),*/
              /* Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  getTranslated(context,Strings.LIST_OF_RIDES_COMPLETED)!,
                  style:
                      theme.textTheme.bodyText2!.copyWith(color: theme.hintColor),
                ),
              ),*/
              boxHeight(10),
              Container(
                width: getWidth(322.1),
                decoration: boxDecoration(
                  // bgColor: Theme.of(context).primaryColor,
                  bgColor: Colors.white,
                  radius: 10,
                  showShadow: true,
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 1;
                        });
                        getRides("1");
                      },
                      child: Container(
                        height: getHeight(49),
                        width: getWidth(105),
                        decoration: selected == 1
                            ? BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(52, 61, 164, 139),
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 8.0,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).primaryColor,
                              )
                            : BoxDecoration(),
                        child: Center(
                          child: text(
                            getTranslated(context, "Pending")!,
                            fontFamily: fontSemibold,
                            fontSize: 11.sp,
                            textColor: selected == 1
                                ? Colors.white
                                : Color(0xff37778A),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 3;
                        });
                        getRides("3");
                      },
                      child: Container(
                        height: getHeight(49),
                        width: getWidth(105),
                        decoration: selected == 3
                            ? BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(52, 61, 164, 139),
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 8.0,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).primaryColor,
                              )
                            : BoxDecoration(),
                        child: Center(
                          child: text(
                            getTranslated(context, "Completed")!,
                            fontFamily: fontSemibold,
                            fontSize: 11.sp,
                            textColor: selected == 3
                                ? Colors.white
                                : Color(0xff37778A),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 4;
                        });
                        getRides("4");
                      },
                      child: Container(
                        height: getHeight(49),
                        width: getWidth(105),
                        decoration: selected == 4
                            ? BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(52, 61, 164, 139),
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 8.0,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).primaryColor,
                              )
                            : BoxDecoration(),
                        child: Center(
                          child: text(
                            // getTranslated(context, "upcoming")!,
                            "Cancelled",
                            fontFamily: fontSemibold,
                            fontSize: 11.sp,
                            textColor: selected == 4
                                ? Colors.white
                                : Color(0xff37778A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              boxHeight(19),
              // Wrap(
              //   spacing: 3.w,
              //   children: filter.map((e) {
              //     return InkWell(
              //       onTap: () {
              //         setState(() {
              //           selectedFil = e.toString();
              //         });
              //         var now = new DateTime.now();
              //         var now_1w = now.subtract(Duration(days: 7));
              //         var now_1m =
              //             new DateTime(now.year, now.month - 1, now.day);
              //         if (selectedFil == "Today") {
              //           for (int i = 0; i < rideList.length; i++) {
              //             DateTime date = DateTime.parse(
              //                 rideList[i].createdDate.toString());
              //             if (now.day == date.day && now.month == date.month) {
              //               setState(() {
              //                 rideList[i].show = true;
              //               });
              //             } else {
              //               setState(() {
              //                 rideList[i].show = false;
              //               });
              //             }
              //           }
              //         }
              //         if (selectedFil == "Weekly") {
              //           for (int i = 0; i < rideList.length; i++) {
              //             DateTime date = DateTime.parse(
              //                 rideList[i].createdDate.toString());
              //             if (now_1w.isBefore(date)) {
              //               setState(() {
              //                 rideList[i].show = true;
              //               });
              //             } else {
              //               setState(() {
              //                 rideList[i].show = false;
              //               });
              //             }
              //           }
              //         }
              //         if (selectedFil == "Monthly") {
              //           for (int i = 0; i < rideList.length; i++) {
              //             DateTime date = DateTime.parse(
              //                 rideList[i].createdDate.toString());
              //             if (now_1m.isBefore(date)) {
              //               setState(() {
              //                 rideList[i].show = true;
              //               });
              //             } else {
              //               setState(() {
              //                 rideList[i].show = false;
              //               });
              //             }
              //           }
              //         }
              //         if (selectedFil == "All") {
              //           for (int i = 0; i < rideList.length; i++) {
              //             setState(() {
              //               rideList[i].show = true;
              //             });
              //           }
              //         }
              //       },
              //       child: Chip(
              //         side: BorderSide(color: MyColorName.primaryLite),
              //         backgroundColor: selectedFil == e
              //             ? MyColorName.primaryLite
              //             : Colors.transparent,
              //         shadowColor: Colors.transparent,
              //         label: text(e,
              //             fontFamily: fontMedium,
              //             fontSize: 10.sp,
              //             textColor:
              //                 selected == e ? Colors.white : Colors.black),
              //       ),
              //     );
              //   }).toList(),
              // ),
              //  boxHeight(19),

              //static Tile for Upcoming rides

              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       border: Border.all(width: 0.5, color: Colors.grey.shade300),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(15.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text("Wagon R / Indica Or Similar",
              //               style: theme.textTheme.titleMedium!
              //                   .copyWith(fontWeight: FontWeight.bold)),
              //           Card(
              //             elevation: 0,
              //             color: Colors.grey.shade100,
              //             child: Padding(
              //               padding: const EdgeInsets.all(5.0),
              //               child: Text(
              //                 "Hatchback",
              //                 style: TextStyle(
              //                     color: AppTheme.primaryColor, fontSize: 12),
              //               ),
              //             ),
              //           ),
              //           Text("₹118",
              //               style: theme.textTheme.titleLarge!.copyWith(
              //                   fontWeight: FontWeight.bold,
              //                   color: AppTheme.secondaryColor)),
              //           Divider(
              //             color: Colors.grey.shade300,
              //           ),
              //           Text('Pickup & Drop'),
              //           Padding(
              //             padding: const EdgeInsets.symmetric(vertical: 10.0),
              //             child: Row(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Icon(
              //                   Icons.location_on_rounded,
              //                   color: Color(0xff217503),
              //                 ),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.only(top: 2.0, left: 10),
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         "Pickup Location",
              //                         style: TextStyle(color: Colors.grey),
              //                       ),
              //                       SizedBox(
              //                         height: 5,
              //                       ),
              //                       Text('Indore'),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.symmetric(vertical: 10.0),
              //             child: Row(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Icon(
              //                   Icons.location_on_rounded,
              //                   color: Color(0xffE90614),
              //                 ),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.only(top: 2.0, left: 10),
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         "Drop Location",
              //                         style: TextStyle(color: Colors.grey),
              //                       ),
              //                       SizedBox(
              //                         height: 5,
              //                       ),
              //                       Text('Jaipur'),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              //static Tile for completed rides
              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5),
              //         border:
              //             Border.all(width: 0.5, color: Colors.grey.shade300)),
              //     child: Row(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: Container(
              //             height: 90,
              //             width: 90,
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(5),
              //                 image: DecorationImage(
              //                     image: AssetImage("assets/xuv.png"),
              //                     fit: BoxFit.cover)),
              //           ),
              //         ),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text("Wagon R / Indica Or Similar",
              //                 style: theme.textTheme.titleMedium!
              //                     .copyWith(fontWeight: FontWeight.bold)),
              //             Card(
              //               elevation: 0,
              //               color: Colors.grey.shade100,
              //               child: Padding(
              //                 padding: const EdgeInsets.all(5.0),
              //                 child: Text(
              //                   "Hatchback",
              //                   style: TextStyle(
              //                       color: AppTheme.primaryColor, fontSize: 12),
              //                 ),
              //               ),
              //             ),
              //             Text("₹118",
              //                 style: theme.textTheme.titleLarge!.copyWith(
              //                     fontWeight: FontWeight.bold,
              //                     color: AppTheme.secondaryColor)),
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // ),

              !loading
                  ? rideList.length > 0
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: rideList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => rideList[index].show!
                              ? GestureDetector(
                                  onTap: () async {
                                    if (rideList[index].bookingType ==
                                            'schedule' &&
                                        selected == 1) {
                                      // Parse the pickup date
                                      DateTime pickupDate =
                                          DateFormat("dd MMM, yyyy").parse(
                                              rideList[index]
                                                  .pickupDate
                                                  .toString());
                                      DateTime currentDate = DateTime.now();
// Compare only the year, month, and day
//                                         if (pickupDate.year == currentDate.year &&
//                                             pickupDate.month == currentDate.month &&
//                                             pickupDate.day == currentDate.day)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OfflinePage(
                                              rideList[index].bookingId ?? ''),
                                        ),
                                      );
                                      print(
                                          "Pickup date is the same as the current date.");
                                      // }else{
                                      //   var result = await     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               RideInfoNew(rideList[index], complete: selected)
                                      //         // RideInfoPage(rideList[index], check: rideList[index].acceptReject != "3" ? null : "yes",)
                                      //       ));
                                      // }
                                      print('klkllkll111');
                                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OfflinePage(rideList[index].bookingId ?? '')));
                                    } else {
                                      var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RideInfoNew(
                                                rideList[index],
                                                complete: selected)
                                            // RideInfoPage(rideList[index], check: rideList[index].acceptReject != "3" ? null : "yes",)
                                            ),
                                      );
                                      // if (result != null) {
                                      //   if (!selected) {
                                      //     getRides("3");
                                      //   } else {
                                      //     getRides("3");
                                      //   }
                                      //   //  getRides(type);
                                      // }
                                      if (rideList[index].acceptReject !=
                                          "3") {}
                                    }
                                  },
                                  child: Padding(
                                    //current tile for completed rides
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 16),
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0, vertical: 8),
                                            child: Row(
                                              children: [
                                                ///image
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Container(
                                                    height: getWidth(80),
                                                    width: getWidth(80),
                                                    decoration: boxDecoration(
                                                        radius: 10,
                                                        color: Colors.grey),
                                                    child: Image.network(
                                                      imagePath +
                                                          rideList[index]
                                                              .userImage
                                                              .toString(),
                                                      height: getWidth(80),
                                                      width: getWidth(80),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            getString1(rideList[
                                                                    index]
                                                                .username
                                                                .toString()),
                                                            style: theme
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            "Trip ID - ${getString1(rideList[index].uneaqueId.toString())}",
                                                            style: theme
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Card(
                                                            margin:
                                                                EdgeInsets.zero,
                                                            elevation: 0,
                                                            color: Colors
                                                                .grey.shade100,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                '${rideList[index].bookingType}',
                                                                style: TextStyle(
                                                                    color: AppTheme
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          rideList[index]
                                                                      .status ==
                                                                  "complete"
                                                              ? Text(
                                                                  "Completed",
                                                                  style: theme
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .green,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              14),
                                                                )
                                                              : rideList[index]
                                                                          .status ==
                                                                      "pending"
                                                                  ? Text(
                                                                      "Pending",
                                                                      style: theme.textTheme.titleMedium!.copyWith(
                                                                          color: Colors
                                                                              .orangeAccent,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  : Text(
                                                                      "cancelled",
                                                                      style: theme.textTheme.titleMedium!.copyWith(
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Pick Date - ${rideList[index].pickupDate} ${rideList[index].pickupTime}',
                                                            style: theme
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          // rideList[index].orderType ==
                                                          //             null ||
                                                          //         rideList[index]
                                                          //                 .orderType ==
                                                          //             'null'
                                                          //     ? SizedBox()
                                                          //     : Text(
                                                          //         '${rideList[index].orderType}',
                                                          //         textAlign:
                                                          //             TextAlign
                                                          //                 .end,
                                                          //         style: theme
                                                          //             .textTheme
                                                          //             .bodySmall!
                                                          //             .copyWith(
                                                          //                 fontSize:
                                                          //                     14),
                                                          //       ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          rideList[index].returnDate ==
                                                                      null ||
                                                                  rideList[index]
                                                                          .returnDate ==
                                                                      "" ||
                                                                  rideList[index]
                                                                          .returnDate ==
                                                                      "false"
                                                              ? SizedBox()
                                                              : Text(
                                                                  'Return Date - ${rideList[index].returnDate}',
                                                                  style: theme
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .green,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                ),
                                                          rideList[index].hours ==
                                                                      null ||
                                                                  rideList[index]
                                                                          .hours ==
                                                                      "null"
                                                              ? SizedBox()
                                                              : Text(
                                                                  'Hour - ${rideList[index].hours}',
                                                                  style: theme
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14),
                                                                ),
                                                        ],
                                                      ),

                                                      // SizedBox(
                                                      //   height: 4,
                                                      // ),
                                                      // Text(
                                                      //     '\u{20B9} ${rideList[index].finalTotal}',
                                                      //     style: theme
                                                      //         .textTheme.titleLarge!
                                                      //         .copyWith(
                                                      //         fontWeight:
                                                      //         FontWeight.bold,
                                                      //         color: AppTheme
                                                      //             .secondaryColor)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      rideList[index]
                                                              .taxiType ??
                                                          '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall!
                                                          .copyWith(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                    // Text("•"),
                                                    // Text(
                                                    //   "${rideList[index].seatingCapacity ?? ''} Seats",
                                                    //   style: Theme.of(context)
                                                    //       .textTheme
                                                    //       .bodyText2!
                                                    //       .copyWith(
                                                    //       fontSize: 14,
                                                    //       fontWeight:
                                                    //       FontWeight.w500),
                                                    // ),
                                                    // Text("•"),
                                                    Text(
                                                      "${rideList[index].distance ?? ''} Kms",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall!
                                                          .copyWith(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // Text("Fuel Type",
                                                            //     style: Theme.of(context)
                                                            //         .textTheme
                                                            //         .bodyText2!
                                                            //         .copyWith(
                                                            //         fontSize: 12,
                                                            //         fontWeight:
                                                            //         FontWeight.bold)),

                                                            rideList[index].extraKmPrice ==
                                                                        null ||
                                                                    rideList[index]
                                                                            .extraKmPrice ==
                                                                        '' ||
                                                                    rideList[index]
                                                                            .extraKmPrice ==
                                                                        '0.00'
                                                                ? SizedBox()
                                                                : Text(
                                                                    "Extra km charges",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headlineSmall!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                            rideList[index]
                                                                        .luggageCarrier ==
                                                                    'yes'
                                                                ? Text(
                                                                    "Luggage Carrier",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headlineSmall!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold))
                                                                : const SizedBox()
                                                            // Text("Insurance Expiry",
                                                            //     style: Theme.of(context)
                                                            //         .textTheme
                                                            //         .bodyText2!
                                                            //         .copyWith(
                                                            //         fontSize: 12,
                                                            //         fontWeight:
                                                            //         FontWeight.bold)),
                                                            // Text("Pollution Expiry",
                                                            //     style: Theme.of(context)
                                                            //         .textTheme
                                                            //         .bodyText2!
                                                            //         .copyWith(
                                                            //         fontSize: 12,
                                                            //         fontWeight:
                                                            //         FontWeight.bold)),
                                                          ]),
                                                    ),
                                                    // const SizedBox(width: 40),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Text(
                                                          //   ":  ${rideList[index].fuelType}",
                                                          //   style: Theme.of(context)
                                                          //       .textTheme
                                                          //       .bodyText2!
                                                          //       .copyWith(
                                                          //       fontSize: 12,
                                                          //       fontWeight:
                                                          //       FontWeight.w500),
                                                          // ),
                                                          rideList[index].extraKmPrice ==
                                                                      null ||
                                                                  rideList[index]
                                                                          .extraKmPrice ==
                                                                      '' ||
                                                                  rideList[index]
                                                                          .extraKmPrice ==
                                                                      '0.00'
                                                              ? SizedBox()
                                                              : Text(
                                                                  ":  ₹${rideList[index].extraKmPrice}/Km after ${rideList[index].distance} Kms",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headlineSmall!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                ),
                                                          rideList[index]
                                                                      .luggageCarrier ==
                                                                  'yes'
                                                              ? Text(
                                                                  ":  ${rideList[index].luggageCarrier ?? ''}",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headlineSmall!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                )
                                                              : const SizedBox()
                                                          // Text(
                                                          //   rideList[index].vehicle_no.toString(),
                                                          //   style: Theme.of(context)
                                                          //       .textTheme
                                                          //       .bodyText2!
                                                          //       .copyWith(
                                                          //       fontSize: 14,
                                                          //       fontWeight:
                                                          //       FontWeight.w500),
                                                          // ),
                                                          // Text(
                                                          //   rideList[index].insurance_expiry.toString(),
                                                          //   style: Theme.of(context)
                                                          //       .textTheme
                                                          //       .bodyText2!
                                                          //       .copyWith(
                                                          //       fontSize: 12,
                                                          //       fontWeight:
                                                          //       FontWeight.w500),
                                                          // ),
                                                          // Text(
                                                          //   rideList[index].pollution_expiry.toString(),
                                                          //   style: Theme.of(context)
                                                          //       .textTheme
                                                          //       .bodyText2!
                                                          //       .copyWith(
                                                          //       fontSize: 12,
                                                          //       fontWeight:
                                                          //       FontWeight.w500),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 0,
                                            color: Colors.grey.shade300,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8.0),
                                            child: Text(
                                              "Pickup & Drop",
                                              style: TextStyle(fontSize: 17),
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
                                                    '${rideList[index].pickupAddress}'),
                                              ],
                                            ),
                                          ),
                                          ListTile(
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
                                                    '${rideList[index].dropAddress}'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12)
                                        ],
                                      ),
                                    ),
                                  ),
                                  /*child: Padding(
                                    //current tile for completed rides
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5),
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Colors.grey.shade300)),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                  height: getWidth(80),
                                                  width: getWidth(80),
                                                  decoration: boxDecoration(
                                                      radius: 10,
                                                      color: Colors.grey),
                                                  child: Image.network(
                                                    imagePath +
                                                        rideList[index]
                                                            .userImage
                                                            .toString(),
                                                    height: getWidth(80),
                                                    width: getWidth(80),
                                                  )),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getString1(rideList[index]
                                                      .username
                                                      .toString()),
                                                  style: theme
                                                      .textTheme.titleMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                          '${rideList[index].transaction}',
                                                          // "Hatchback",
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .primaryColor,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      '${rideList[index].dateAdded}',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                    '\u{20B9} ${rideList[index].amount}',
                                                    style: theme
                                                        .textTheme.titleLarge!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppTheme
                                                                .secondaryColor)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),*/

                                  // Container(                                                                 //previous tile for completed ride
                                  //   margin: EdgeInsets.all(getWidth(10)),
                                  //   decoration: boxDecoration(
                                  //       radius: 10,
                                  //       bgColor: Colors.white,
                                  //       showShadow: true),
                                  //   child: Column(
                                  //     children: [
                                  //       Container(
                                  //         padding: EdgeInsets.symmetric(
                                  //             vertical: 12, horizontal: 16),
                                  //         child: Row(
                                  //           children: [
                                  //             ClipRRect(
                                  //               borderRadius:
                                  //                   BorderRadius.circular(10),
                                  //               child: Container(
                                  //                   height: getWidth(72),
                                  //                   width: getWidth(72),
                                  //                   decoration: boxDecoration(
                                  //                       radius: 10,
                                  //                       color: Colors.grey),
                                  //                   child: Image.network(
                                  //                     imagePath +
                                  //                         rideList[index]
                                  //                             .userImage
                                  //                             .toString(),
                                  //                     height: getWidth(72),
                                  //                     width: getWidth(72),
                                  //                   )),
                                  //             ),
                                  //             SizedBox(width: 16),
                                  //             Expanded(
                                  //               child: Column(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.center,
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Text(
                                  //                     'Trip ID-${getString1(rideList[index].uneaqueId.toString())}',
                                  //                     style: theme
                                  //                         .textTheme.bodyText1,
                                  //                   ),
                                  //                   SizedBox(
                                  //                     height: 5,
                                  //                   ),
                                  //                   Text(
                                  //                     '${rideList[index].dateAdded}',
                                  //
                                  //                     style: theme
                                  //                         .textTheme.bodySmall,
                                  //                   ),
                                  //                   SizedBox(
                                  //                     height: 5,
                                  //                   ),
                                  //                   Text(
                                  //                     getString1(rideList[index]
                                  //                         .username
                                  //                         .toString()),
                                  //                     style:
                                  //                         theme.textTheme.caption,
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //             SizedBox(
                                  //               width: 10,
                                  //             ),
                                  //             Column(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.end,
                                  //               children: [
                                  //                 Text(
                                  //                   '\u{20B9} ${rideList[index].amount}',
                                  //                   style: theme
                                  //                       .textTheme.bodyText2!
                                  //                       .copyWith(
                                  //                           color: theme
                                  //                               .primaryColor),
                                  //                 ),
                                  //                 SizedBox(
                                  //                   height: 8,
                                  //                 ),
                                  //                 Text(
                                  //                   '${rideList[index].transaction}',
                                  //                   textAlign: TextAlign.right,
                                  //                   style:
                                  //                       theme.textTheme.caption,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       ListTile(
                                  //         leading: Icon(
                                  //           Icons.location_on,
                                  //           color: theme.primaryColor,
                                  //           size: 20,
                                  //         ),
                                  //         title: Text(getString1(rideList[index]
                                  //             .pickupAddress
                                  //             .toString())),
                                  //         dense: true,
                                  //         tileColor: theme.cardColor,
                                  //       ),
                                  //       ListTile(
                                  //         leading: Icon(
                                  //           Icons.navigation,
                                  //           color: theme.primaryColor,
                                  //           size: 20,
                                  //         ),
                                  //         title: Text(getString1(rideList[index]
                                  //             .dropAddress
                                  //             .toString())),
                                  //         dense: true,
                                  //         tileColor: theme.cardColor,
                                  //       ),
                                  //
                                  //
                                  //
                                  //       !rideList[index]
                                  //               .bookingType!
                                  //               .contains("Point")
                                  //           ? Row(
                                  //               mainAxisAlignment: rideList[
                                  //                                   index]
                                  //                               .sharing_type !=
                                  //                           null &&
                                  //                       rideList[index]
                                  //                               .sharing_type !=
                                  //                           ""
                                  //                   ? MainAxisAlignment
                                  //                       .spaceBetween
                                  //                   : MainAxisAlignment.center,
                                  //               children: [
                                  //                 AnimatedTextKit(
                                  //                   animatedTexts: [
                                  //                     ColorizeAnimatedText(
                                  //                       "Schedule - ${rideList[index].pickupDate} ${rideList[index].pickupTime}",
                                  //                       textStyle:
                                  //                           colorizeTextStyle,
                                  //                       colors: colorizeColors,
                                  //                     ),
                                  //                   ],
                                  //                   pause: Duration(
                                  //                       milliseconds: 100),
                                  //                   isRepeatingAnimation: true,
                                  //                   totalRepeatCount: 100,
                                  //                   onTap: () {
                                  //                     print("Tap Event");
                                  //                   },
                                  //                 ),
                                  //                 rideList[index].sharing_type !=
                                  //                             null &&
                                  //                         rideList[index]
                                  //                                 .sharing_type !=
                                  //                             ""
                                  //                     ? AnimatedTextKit(
                                  //                         animatedTexts: [
                                  //                           ColorizeAnimatedText(
                                  //                             "Ride Type - ${rideList[index].sharing_type}",
                                  //                             textStyle:
                                  //                                 colorizeTextStyle,
                                  //                             colors:
                                  //                                 colorizeColors,
                                  //                           ),
                                  //                         ],
                                  //                         pause: Duration(
                                  //                             milliseconds:
                                  //                                 100),
                                  //                         isRepeatingAnimation:
                                  //                             true,
                                  //                         totalRepeatCount: 100,
                                  //                         onTap: () {
                                  //                           print("Tap Event");
                                  //                         },
                                  //                       )
                                  //                     : SizedBox(),
                                  //               ],
                                  //             )
                                  //           : SizedBox(),
                                  //       SizedBox(height: 12),
                                  //     ],
                                  //   ),
                                  // ),
                                )
                              : SizedBox(),
                        )
                      : Center(
                          child: text(getTranslated(context, "Norides")!,
                              fontFamily: fontMedium,
                              fontSize: 12.sp,
                              textColor: Colors.black),
                        )
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

final colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

final colorizeTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w900,
  fontFamily: 'Inter',
);
