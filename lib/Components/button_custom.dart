import 'package:flutter/material.dart';
import 'package:pristine_andaman_driver/Theme/style.dart';

class ButtonCustom extends StatelessWidget {
  String title;
  ButtonCustom({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(5)),
      child: Center(
          child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      )),
    );
  }
}
