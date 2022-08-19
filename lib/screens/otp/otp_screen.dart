import 'package:flutter/material.dart';
import '../../utils/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  String? name, phone, email, password;
  OtpScreen({
    this.name,
    this.phone,
    this.email,
    this.password,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Body(name: name, phone: phone, email: email, password: password,),
    );
  }
}
