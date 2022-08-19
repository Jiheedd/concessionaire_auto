
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class textFieldDisabled extends StatelessWidget {
  const textFieldDisabled({
    Key? key,
    required this.hint,
    required this.boxColor,
    required this.h,
    required this.w,
    required this.fontSize,
    required this.inputBorder,

  }) : super(key: key);

  final String hint;
  final Color boxColor;
  final double w,h;
  final InputBorder inputBorder;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          textAlign: TextAlign.center,
          //textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal:0),
            fillColor: Colors.white,
            //border: InputBorder.none,
            border: inputBorder,
            hintText: hint,
            enabled: false,
            hintStyle: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
