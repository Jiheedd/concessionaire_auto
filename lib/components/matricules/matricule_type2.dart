import 'package:concessionaire_auto/components/textField/textFieldEnabled.dart';
import 'package:flutter/material.dart';

import '../../../../utils/size_config.dart';

class MatriculeType2 extends StatefulWidget {
  MatriculeType2({Key? key,
    this.currentType,
    required this.type,
    required this.leftSide,
    required this.rightSide,
    required this.getMatricule,
    this.lengthLeft,
    this.lengthRight,
  }) : super(key: key);

  String? currentType;
  int type;
  int? lengthLeft, lengthRight;
  Function(String,String) getMatricule;
  TextEditingController leftSide;
  TextEditingController rightSide;

  @override
  State<MatriculeType2> createState() => _MatriculeType2State();
}

class _MatriculeType2State extends State<MatriculeType2> {

  late String _currentLeftSide = '';
  late String _currentRightSide = '';
  late String matricule = '';
  //TextInputAction? textInputAction;

  FocusNode? pin1FocusNode;
  FocusNode? pin2FocusNode;

  @override
  void initState() {
    super.initState();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin1FocusNode!.dispose();
    pin2FocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String starsLeft = "";
    String starsRight = "";

    setState(() {

      List.generate(widget.lengthLeft!, (index) => starsLeft = starsLeft + '*');
      List.generate(widget.lengthRight!, (index) => starsRight = starsRight + '*');
    });

    getLeftSide(String value){
      setState(() {
        _currentLeftSide = value;
        widget.getMatricule(_currentLeftSide, _currentRightSide);
      });
    }
    getRightSide(String value){
      setState(() {
        _currentRightSide = value;
        widget.getMatricule(_currentLeftSide, _currentRightSide);
      });
    }


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
              textFieldEnabled(
                w: getProportionateScreenWidth(100),
                h: getProportionateScreenHeight(60),
                hint: starsLeft,
                boxColor: Colors.black,
                fontSize: SizeConfig.screenWidth * 0.07,
                inputBorder: InputBorder.none,
                inputType: TextInputType.number,
                inputController: widget.leftSide,
                getSide: getLeftSide,
                length: widget.lengthLeft,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Text(
                  widget.currentType??"",
                  style: const TextStyle(fontSize: 36, color: Colors.white, fontFamily: 'OrelegaOne',letterSpacing: 3),
                ),
              ),
              textFieldEnabled(
                w: getProportionateScreenWidth(120),
                h: getProportionateScreenHeight(60),
                hint: starsRight,
                boxColor: Colors.black,
                fontSize: SizeConfig.screenWidth * 0.07,
                inputBorder: InputBorder.none,
                inputType: TextInputType.number,
                inputController: widget.rightSide,
                getSide: getRightSide,
                length: widget.lengthRight,
                textInputAction: TextInputAction.done,

              ),
            ],
          ),
        ),
      ),
    );

  }
}
