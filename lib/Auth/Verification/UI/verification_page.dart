import 'package:flutter/material.dart';

import '../../login_navigator.dart';
import 'verification_interactor.dart';
import 'verification_ui.dart';

class VerificationPage extends StatefulWidget {
  String mobile, otp, comeFrom;

  VerificationPage(this.mobile, this.otp, this.comeFrom);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage>
    implements VerificationInteractor {
  @override
  Widget build(BuildContext context) {
    return VerificationUI(this, widget.mobile, widget.otp, widget.comeFrom);
  }

  @override
  void notReceived() {
    Navigator.pushNamed(context, LoginRoutes.bankDetails);
  }

  @override
  void verify() {
    Navigator.pushNamed(context, LoginRoutes.bankDetails);
  }
}
