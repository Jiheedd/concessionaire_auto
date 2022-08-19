import 'package:concessionaire_auto/components/textField/textFieldDisabled.dart';
import 'package:concessionaire_auto/components/textField/textFieldEnabled.dart';
import 'package:flutter/material.dart';

import '../../../../utils/size_config.dart';

class MatriculeType2 extends StatefulWidget {
  MatriculeType2({Key? key,
    this.currentType,
    this.leftSide,
    this.rightSide,
  }) : super(key: key);

  String? currentType;
  String? leftSide;
  String? rightSide;

  @override
  State<MatriculeType2> createState() => _MatriculeType2State();
}

class _MatriculeType2State extends State<MatriculeType2> {


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.all(
                Radius.circular(15)
            ),
            border: Border.all(
              color: Colors.white,
              width: 6,
            )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textFieldDisabled(
                w: getProportionateScreenWidth(100),
                h: getProportionateScreenHeight(60),
                hint: widget.leftSide!,
                boxColor: Colors.black,
                fontSize: SizeConfig.screenWidth * 0.07,
                inputBorder: InputBorder.none,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Text(
                  widget.currentType??"",
                  style: const TextStyle(fontSize: 36, color: Colors.white, fontFamily: 'OrelegaOne',letterSpacing: 3),
                ),
              ),
              textFieldDisabled(
                w: getProportionateScreenWidth(120),
                h: getProportionateScreenHeight(60),
                hint: widget.rightSide!,
                boxColor: Colors.black,
                fontSize: SizeConfig.screenWidth * 0.07,
                inputBorder: InputBorder.none,
              ),
            ],
          ),
        ),
      ),
    );

  }
}
