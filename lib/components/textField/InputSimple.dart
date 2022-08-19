import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/size_config.dart';

class InputSimple extends StatelessWidget {
  const InputSimple({
    Key? key,
    required this.hint,
    required this.inputType,
    required this.inputAction,

  }) : super(key: key);

  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: SizeConfig.screenWidth * 0.3,
        height: SizeConfig.screenHeight * 0.05,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 18,horizontal: 22),
              fillColor: Colors.white,
              // border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Colors.white54, width: 3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: Colors.white, width: 5.0),
              ),
              hintText: hint,
              enabled: true,
              hintStyle: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
          ),
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
    );
  }
}
