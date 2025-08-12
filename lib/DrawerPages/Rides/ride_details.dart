import 'package:flutter/material.dart';
import 'package:pristine_andaman_driver/Components/button_custom.dart';
import 'package:pristine_andaman_driver/DrawerPages/Rides/ride_summary.dart';
import 'package:pristine_andaman_driver/DrawerPages/notification_list.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/new_utils/ui.dart';
import 'package:pristine_andaman_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';

class RideDetails extends StatefulWidget {
  RideDetails();

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {
  String count = "0";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Ride Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              UI.commonIconButton(
                message: "Notifications",
                iconData: Icons.notifications_none,
                onPressed: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                  if (result != null) {
                    if (result == "yes") {
                      setState(() {
                        count = "0";
                      });
                      return;
                    }
                    // getBookingInfo(result);
                  }
                },
              ),
              count != "0"
                  ? Container(
                      width: getWidth(18),
                      height: getWidth(18),
                      margin: EdgeInsets.only(
                          right: getWidth(3), top: getHeight(3)),
                      decoration:
                          boxDecoration(radius: 100, bgColor: Colors.red),
                      child: Center(
                          child: text(count.toString(),
                              fontFamily: fontMedium,
                              fontSize: 6.sp,
                              textColor: Colors.white)),
                    )
                  : SizedBox(),
            ],
          ),
        ],

        // bottom: PreferredSize(
        //   preferredSize: Size(
        //     100.w,
        //     getHeight(50),
        //   ),
        //   child: ListTile(
        //     onTap: () async {
        //       var result = await Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => MyRidesPage(
        //                   selected: true,
        //                 )),
        //       );
        //       if (result != null) {
        //         getBookInfo();
        //       }
        //     },
        //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
        //     leading: ClipRRect(
        //         borderRadius: BorderRadius.circular(8),
        //         child: image != ""
        //             ? Image.network(
        //                 image,
        //                 width: getWidth(60),
        //                 height: getWidth(60),
        //                 fit: BoxFit.fill,
        //                 colorBlendMode: profileStatus == "0"
        //                     ? BlendMode.hardLight
        //                     : BlendMode.color,
        //                 color: profileStatus == "0"
        //                     ? Colors.white.withOpacity(0.4)
        //                     : Colors.transparent,
        //               )
        //             : SizedBox()),
        //     /*Image.asset('assets/delivery_boy.png'),*/
        //     title: Text('${totalRide} ' +
        //         getTranslated(context, Strings.RIDES)!.toUpperCase() +
        //         ' | \u{20B9}${totalAmount}',style: TextStyle(color: Colors.white,),),
        //     subtitle: Text(getTranslated(context, Strings.TODAY)!,style: TextStyle(color: Colors.white,),),
        //   ),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 0.5, color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Wagon R / Indica Or Similar",
                          style: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      Card(
                        elevation: 0,
                        color: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Hatchback",
                            style: TextStyle(
                                color: AppTheme.primaryColor, fontSize: 12),
                          ),
                        ),
                      ),
                      Text("₹118",
                          style: theme.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor)),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      Text('Pickup & Drop'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Color(0xff217503),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pickup Location",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Indore'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Color(0xffE90614),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Drop Location",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Jaipur'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 0.5, color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User Detail"),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("John Smith"),
                              Text("7909643765"),
                            ],
                          ),
                          Container(
                            height: 32,
                            width: 81,
                            decoration: BoxDecoration(
                                color: AppTheme.secondaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                child: Text(
                              "Call",
                              style: TextStyle(color: Colors.white),
                            )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 0.5, color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment',
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Base Fare',
                            style: theme.textTheme.bodySmall!
                                .copyWith(color: Colors.grey)),
                        Text('₹50.0'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Toll/State Tax',
                            style: theme.textTheme.bodySmall!
                                .copyWith(color: Colors.grey)),
                        Text('₹15.0'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('GST(5%)',
                            style: theme.textTheme.bodySmall!
                                .copyWith(color: Colors.grey)),
                        Text('₹20.0'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Parking Fees',
                            style: theme.textTheme.bodySmall!
                                .copyWith(color: Colors.grey)),
                        Text('0'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount',
                            style: theme.textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w900)),
                        Text('₹118'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> RideSummary()));
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          // height: 200,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                                left: 15,
                                right: 15,
                                top: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Start Ride',
                                  style: theme.textTheme.titleLarge!
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text('Enter OTP given by user',
                                    style: theme.textTheme.titleSmall!.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  maxLength: 4,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "OTP Here",
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20.0)),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            height: 180,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 90,
                                                        width: 90,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/xuv.png"),
                                                                fit: BoxFit
                                                                    .cover)),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Palak Kumar',
                                                            style: theme
                                                                .textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          Text(
                                                            '15 July 2024, 12:55 PM',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        RideSummary()));
                                                      },
                                                      child: ButtonCustom(
                                                          title: 'Complete'))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: ButtonCustom(title: 'Submit'),
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: ButtonCustom(title: 'Start')),
            ],
          ),
        ),
      ),
    );
  }
}
