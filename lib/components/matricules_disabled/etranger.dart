import 'package:concessionaire_auto/components/textField/textFieldDisabled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../components/textField/textFieldEnabled2.dart';
import '../../../../utils/size_config.dart';

class Stranger extends StatefulWidget {
  Stranger({
    Key? key,
    required this.mid,
  }) : super(key: key);

  String? mid;

  @override
  State<Stranger> createState() => _Stranger();
}

class _Stranger extends State<Stranger> {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0, left: 8),
            child: Text("N° Châssis: ", style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'Muli',
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: const BorderRadius.all(
                    Radius.circular(15)
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 6,
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textFieldDisabled(
                    w: SizeConfig.screenWidth * 0.88,
                    h: getProportionateScreenHeight(60),
                    hint: widget.mid!,
                    boxColor: Colors.transparent,
                    fontSize: SizeConfig.screenWidth * 0.07,
                    inputBorder: InputBorder.none,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}

