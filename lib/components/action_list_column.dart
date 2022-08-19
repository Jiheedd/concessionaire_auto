import 'package:concessionaire_auto/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class ActionList extends StatefulWidget {

  String iconPath;
  String desc;
  Color? iconColor;
  final VoidCallback? press;

  ActionList({
    required this.iconPath,
    required this.desc,
    required this.iconColor,
    this.press,
    Key? key
  }) : super(key: key);

  @override
  _ActionListState createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: yellowColor,
        focusColor: yellowColor,
        //hoverColor: borderContainer,
        //highlightColor: yellowColor,
        onTap: widget.press,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(40)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                widget.iconPath,
                fit: BoxFit.contain,
                height: SizeConfig.screenHeight*0.058,
                width: SizeConfig.screenWidth*0.13,
                color: widget.iconColor,
              ),
              SizedBox(
                height: getProportionateScreenHeight(8),
              ),
              Text(
                widget.desc,
                style: TextStyle(color: widget.iconColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
