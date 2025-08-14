import 'package:flutter/material.dart';
import 'package:pristine_andaman_driver/Locale/strings_enum.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';

import '../Theme/style.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? text;
  final Color? color;
  final textColor;
  final BorderRadius? borderRadius;
  final IconData? icon;

  CustomButton({
    this.onTap,
    this.text,
    this.color,
    this.textColor,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return icon != null
        ? TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16),
              minimumSize: Size(200, 40),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero,
                side: BorderSide.none,
              ),
              backgroundColor: color ?? AppTheme.secondaryColor,
            ),
            onPressed: onTap as void Function()? ?? () {},
            icon: Icon(
              icon,
              color: textColor ?? theme.scaffoldBackgroundColor,
            ),
            label: Text(
              text != null ? text! : getTranslated(context, Strings.CONTINUE)!,
              style: theme.textTheme.headlineSmall!
                  .copyWith(color: textColor ?? theme.scaffoldBackgroundColor),
            ),
          )
        : TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24),
              minimumSize: Size(300, 40), // Height 40 fix
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero,
                side: BorderSide.none,
              ),
              backgroundColor: color ?? theme.primaryColor,
            ),
            onPressed: onTap as void Function()? ?? () {},
            child: Text(
              text != null ? text! : getTranslated(context, Strings.CONTINUE)!,
              style: theme.textTheme.headlineSmall!.copyWith(
                color: Colors.white,
              ),
            ),
          );
  }
}
