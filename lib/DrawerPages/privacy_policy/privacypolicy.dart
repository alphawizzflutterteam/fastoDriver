import 'dart:async';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';

import '../../utils/ApiBaseHelper.dart';
import '../../utils/Session.dart';
import '../../utils/colors.dart';
import '../../utils/constant.dart';
import '../../utils/new_utils/ui.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy();

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Privacy Policy',style: TextStyle(fontSize: 20,
          fontFamily:  AppTheme.fontFamily,
          color: MyColorName.secondary,),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: status
              ? Center(child: CircularProgressIndicator())
              : Column(
            children: [Text(data.body.text,style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontWeight: FontWeight.w500,
              fontSize: 18),textAlign: TextAlign.justify)],
          ),
        ),
      ),

    );
  }
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool status = false;
  var data;
  getData() async {
    status = true;
    setState(() {});
    try {
      Map response = await apiBase.getAPICall(
        Uri.parse(baseUrl1 + "payment/page/driver-privacy-policy"),
      );
      status = false;
      setState(() {});
      if (response['status']) {
        data = parse(response["data"]['value']);
        print(data);
      } else {
        UI.setSnackBar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      UI.setSnackBar(getTranslated(context, "WRONG")!, context);
    }
  }
}
