import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:pristine_andaman_driver/Model/review_model.dart';
import 'package:pristine_andaman_driver/Routes/page_routes.dart';
import 'package:pristine_andaman_driver/utils/ApiBaseHelper.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';

import '../../Theme/style.dart';
import '../../utils/colors.dart';

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = true;
  List<ReviewModel> reviewList = [];
  String path = "";
  getReview(type) async {
    try {
      setState(() {
        loading = true;
      });
      Map params = {
        "driver_id": curUserId,
        "type": type,
      };
      print("get revies ${params}");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "payment/get_review"), params);
      setState(() {
        loading = false;
        reviewList.clear();
      });
      if (response['status']) {
        print(response['data']);
        for (var v in response['data']) {
          setState(() {
            path = response['image_path'];
            rating =
                double.parse(response['rating'].toString()).toStringAsFixed(2);
            reviewList.add(ReviewModel.fromJson(v));
          });
        }
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReview("1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //drawer: AppDrawer(false),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        backgroundColor: MyColorName.colorBg1,
        centerTitle: true,
        title: Text('Rating',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 19,
                  fontFamily: AppTheme.fontFamily,
                  color: MyColorName.secondary,
                )),
      ),
      body: FadedSlideAnimation(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xff41C9B5).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Overall Rating",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                    Text(
                      rating,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 32),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 1; i <= 5; i++)
                          Icon(
                            Icons.star_rounded,
                            color: Color(0xffFFC549),
                            size: 25,
                          )
                      ],
                    ),
                    Text(
                      'Based on ${reviewList.length} review',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),

            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            //   child: Text(
            //     getTranslated(context,Strings.CURRENT_RATINGS)!.toUpperCase(),
            //     style: Theme.of(context)
            //         .textTheme
            //         .bodyText1!
            //         .copyWith(fontSize: 18),
            //   ),
            // ),
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            //   child: Row(
            //     children: [
            //       Container(
            //         padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(30),
            //           color: AppTheme.ratingsColor,
            //         ),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text(
            //               rating,
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .bodyText2!
            //                   .copyWith(fontSize: 24),
            //             ),
            //             SizedBox(width: 8),
            //             Icon(
            //               Icons.star,
            //               color: AppTheme.starColor,
            //               size: 20,
            //             )
            //           ],
            //         ),
            //       ),
            //       SizedBox(
            //         width: 12,
            //       ),
            //       Text(
            //         '${reviewList.length} ' + getTranslated(context,Strings.PEOPLE_RATED)!,
            //         style: Theme.of(context)
            //             .textTheme
            //             .bodyText1!
            //             .copyWith(color: Theme.of(context).hintColor),
            //       )
            //     ],
            //   ),
            // ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text("Review",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w700)),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Container(
            //     decoration: boxDecoration(radius: 10, showShadow: true),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Container(
            //           padding:
            //               EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            //           child: Row(
            //             children: [
            //               Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     // reviewList[index].username.toString(),
            //                     "UserName",
            //                     style: Theme.of(context).textTheme.bodySmall,
            //                   ),
            //                   SizedBox(
            //                     height: 8,
            //                   ),
            //                   Text(
            //                     //getDate1(reviewList[index].time),
            //                     "date",
            //                     style: Theme.of(context).textTheme.bodySmall,
            //                   ),
            //                 ],
            //               ),
            //               Spacer(),
            //               Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 crossAxisAlignment: CrossAxisAlignment.end,
            //                 children: [
            //                   Container(
            //                     padding: EdgeInsets.symmetric(
            //                         horizontal: 6, vertical: 2),
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(30),
            //                       color: AppTheme.ratingsColor,
            //                     ),
            //                     child: Row(
            //                       mainAxisSize: MainAxisSize.min,
            //                       children: [
            //                         Text(
            //                           // reviewList[index].rating.toString(),
            //                           "rating",
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .bodySmall!
            //                               .copyWith(fontSize: 14),
            //                         ),
            //                         SizedBox(width: 4),
            //                         Icon(
            //                           Icons.star,
            //                           color: AppTheme.starColor,
            //                           size: 14,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.only(left: 20, right: 16, bottom: 12),
            //           // color: Theme.of(context).colorScheme.background,
            //           child: Text(
            //             // reviewList[index].comment.toString(),
            //             'comment',
            //             style: Theme.of(context).textTheme.bodySmall,
            //           ),
            //         ),
            //         SizedBox(height: 12),
            //       ],
            //     ),
            //   ),
            // ),

            !loading
                ? reviewList.isNotEmpty
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reviewList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final review = reviewList[index];
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, PageRoutes.rideInfoPage),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            path + review.userImage.toString(),
                                          ),
                                          backgroundColor: Colors.grey[200],
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                review.username.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              SizedBox(height: 4),
                                              Text(getDate1(review.time),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.ratingsColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                review.rating.toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.star,
                                                  color: AppTheme.starColor,
                                                  size: 16),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      child: Text(review.comment.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          getTranslated(context, "Noreview")!,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
