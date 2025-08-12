import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String heading;
  String subheading;
   CustomText({required this.heading,required this.subheading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey)),
        Text(subheading),
      ],
    );
  }
}
