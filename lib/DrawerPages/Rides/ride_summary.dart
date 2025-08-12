import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pristine_andaman_driver/Components/button_custom.dart';
import 'package:pristine_andaman_driver/Components/custom_text.dart';
import 'package:pristine_andaman_driver/DrawerPages/Home/offline_page.dart';
import 'package:pristine_andaman_driver/DrawerPages/Rides/my_rides_page.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';

class RideSummary extends StatefulWidget {
  const RideSummary();

  @override
  State<RideSummary> createState() => _RideSummaryState();
}

class _RideSummaryState extends State<RideSummary> {
  @override
  Widget build(BuildContext context) {
   var theme = Theme.of(context);
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        leading: GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OfflinePage('')));
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text('Ride Summary',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.5,color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image: AssetImage("assets/xuv.png"),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Wagon R / Indica Or Similar",style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5,),
                            Text("#ID4562526",style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey)),
                            Card(
                              elevation: 0,
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Hatchback",style: TextStyle(color: AppTheme.primaryColor,fontSize: 12),),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(color: Colors.grey.shade300,),
                    Text('Pickup & Drop'),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_rounded,color: Color(0xff217503),),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Pickup Location",style: TextStyle(color: Colors.grey),),
                                SizedBox(height: 5,),
                                Text('Indore'),
                              ],
                            ),
                          ),
                        ],),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_rounded,color: Color(0xffE90614),),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Drop Location",style: TextStyle(color: Colors.grey),),
                                SizedBox(height: 5,),
                                Text('Jaipur'),
                              ],
                            ),
                          ),
                        ],),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.5,color: Colors.grey.shade300),
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User Detail"),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(heading: 'Name', subheading: 'John Smith'),
                      CustomText(heading: "Number", subheading: '7909642723'),
                      SizedBox()
                    ],
                  ),
                  SizedBox(height: 10,),
                  CustomText(heading: "Email", subheading: "John12@gmail.com")
                ]
              ),
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.5,color: Colors.grey.shade300),
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date & Time"),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                            Container(
                                height: 50,
                                width: 50,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white
                                ),
                                child: Image.asset('assets/Calendar.png')),
                            CustomText(heading: 'Date', subheading: '7 September,2024')
                            ],
                          ),
                          Row(
                           children: [
                             Container(
                                 height: 50,
                                 width: 50,
                                 padding: EdgeInsets.all(10),
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     color: Colors.white
                                 ),
                                 child: Image.asset('assets/timecirclegrey.png')),
                             CustomText(heading: "Time", subheading: "07:00 PM")
                           ],
                         ),
                          SizedBox()
                        ],
                      ),
                    ),
                  ]
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: getWidth(375),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.5,color: Colors.grey.shade300),
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
               Text('Ride Fare'),
               SizedBox(height: 5,),
               Text('₹150',style: TextStyle(color: AppTheme.secondaryColor,fontSize: 20),),
                  ]
              ),
            ),
            Expanded(child: SizedBox()),
            GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyRidesPage()));
                },
                child: ButtonCustom(title: 'Ride Completed'))

          ],
        ),
      ),

    );
  }
}
