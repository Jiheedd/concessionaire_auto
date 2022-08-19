import 'package:concessionaire_auto/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';


class ChooseDropdown extends StatefulWidget {
  final List<dynamic> table;
  Function(String) onChange;
  String? title;

  ChooseDropdown({
    required this.table,
    required this.onChange,
    this.title,
    Key? key,
  }) : super(key: key);


  @override
  _ChooseDropdownState createState() => _ChooseDropdownState();
}

class _ChooseDropdownState extends State<ChooseDropdown> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ]),
          color:Colors.white,
          border: Border.all(color: Colors.black38, width:1),
          borderRadius: BorderRadius.circular(16),

          //borderRadius: BorderRadius.circular(12),
          boxShadow: const <BoxShadow> [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                blurRadius: 5),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 23.0, right: 15),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              alignment: Alignment.bottomCenter,
              menuMaxHeight: SizeConfig.screenHeight * 0.6,
              hint: Text(widget.title??"Taper le choix", style: const TextStyle(fontSize: 16, color: DarkBlueColor),),
              items: widget.table.map((time) {
                return DropdownMenuItem(
                    value: time,
                    child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  //_currentChoice = value.toString();
                  widget.onChange(value.toString());
                });
              },
              //value: _currentChoice,
              //value: widget.table.first,
              isExpanded: true, //make true to take width of parent widget
              style: const TextStyle(fontSize: 18, color: DarkBlueColor, fontWeight: FontWeight.bold),
              dropdownColor: Colors.white,
              iconEnabledColor: DarkBlueColor,
              iconSize: 32,
            ),
          ),
        ),
      ),
    );
  }
}

