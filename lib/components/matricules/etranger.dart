import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../components/textField/textFieldEnabled2.dart';
import '../../../../utils/size_config.dart';

class Stranger extends StatefulWidget {
  Stranger({
    Key? key,
    required this.mid,
    required this.getChassis,
    this.length,
  }) : super(key: key);

  TextEditingController mid;
  Function(String,String) getChassis;
  int? length;

  @override
  State<Stranger> createState() => _Stranger();
}

class _Stranger extends State<Stranger> {
  late String _mid = '';

  @override
  Widget build(BuildContext context) {

    String stars = "";

    List.generate(widget.length!, (index) => stars = stars + '*');

    getChassis(String value){
      setState(() {
        _mid = value;
        widget.getChassis(_mid,"");
      });
    }
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
                  textFieldEnabled2(
                    w: SizeConfig.screenWidth * 0.88,
                    h: getProportionateScreenHeight(60),
                    hint: stars,
                    boxColor: Colors.transparent,
                    fontSize: SizeConfig.screenWidth * 0.07,
                    inputBorder: InputBorder.none,
                    inputType: TextInputType.streetAddress,
                    inputController: widget.mid,
                    getSide: getChassis,
                    length: widget.length,
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

