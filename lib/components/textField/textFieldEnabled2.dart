import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class textFieldEnabled2 extends StatelessWidget {
  textFieldEnabled2({
    Key? key,
    required this.hint,
    required this.boxColor,
    required this.h,
    required this.w,
    required this.fontSize,
    required this.inputBorder,
    required this.inputType,
    required this.inputController,
    required this.getSide,
    this.length,
    this.textInputAction,
  }) : super(key: key);

  final String hint;
  final Color boxColor;
  final double w,h;
  int? length;
  TextInputAction? textInputAction;
  final InputBorder inputBorder;
  final double fontSize;
  final TextInputType inputType;
  final TextEditingController inputController;
  Function(String) getSide;

  @override
  Widget build(BuildContext context) {

    if (textInputAction!=TextInputAction.done) {
      textInputAction = TextInputAction.next;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextFormField(
          textAlign: TextAlign.center,
          controller: inputController,
          onSaved: (newValue) => inputController.text = newValue!,
          onChanged: (value) {
            getSide(value);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top: 22,left: 22, right: 22),
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent, width: 1),
            ),
            focusedBorder: OutlineInputBorder(

              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.transparent, width: 2),
            ),
            hintText: hint,
            enabled: true,
            hintStyle: TextStyle(
              fontSize: fontSize * 1.2,
              color: Colors.white70,
            ),
          ),
          style: TextStyle(
            fontSize: fontSize ,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textInputAction: textInputAction,
          keyboardType: inputType,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            LengthLimitingTextInputFormatter(length),
          ],
        ),
      ),
    );
  }
}
