import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import 'UserIcon.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //padding: const EdgeInsets.symmetric(horizontal: 10),
      height: SizeConfig.screenHeight * 0.35,
      width: SizeConfig.screenWidth * 0.9 ,
      child: Center(
          child: UserIcon()
      ),
    );
  }
}
