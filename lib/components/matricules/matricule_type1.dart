import 'package:concessionaire_auto/components/textField/textFieldEnabled.dart';
import 'package:flutter/material.dart';

import '../../../../utils/size_config.dart';

class MatriculeType1 extends StatefulWidget {
  MatriculeType1({Key? key,
    this.currentType,
    required this.type,
    required this.mid,
    required this.getMatricule,
    this.arabic,
    this.length,
  }) : super(key: key);

  String? currentType;
  int type;
  int? length;
  Function(String,String) getMatricule;
  TextEditingController mid;
  String? arabic;

  @override
  State<MatriculeType1> createState() => _MatriculeType1State();
}

class _MatriculeType1State extends State<MatriculeType1> {

  late String _mid = '';
  late String matricule = '';

  @override
  Widget build(BuildContext context) {

    String stars = "";
    setState(() {
      List.generate(widget.length!, (index) => stars = stars + '*');
    });

    getMid(String value){
      setState(() {
        _mid = value;
        widget.getMatricule(_mid,widget.arabic!);
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
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.02, right: 0),
                child: Text(
                  widget.currentType??"",
                  style: const TextStyle(fontSize: 36, color: Colors.white, fontFamily: 'OrelegaOne',letterSpacing: 3),
                ),
              ),
              textFieldEnabled(
                w: getProportionateScreenWidth(140),
                h: getProportionateScreenHeight(60),
                hint: stars,
                boxColor: Colors.black,
                fontSize: SizeConfig.screenWidth * 0.07,
                inputBorder: InputBorder.none,
                inputType: TextInputType.streetAddress,
                inputController: widget.mid,
                getSide: getMid,
                length: widget.length,
                textInputAction: TextInputAction.done,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0, right: SizeConfig.screenWidth * 0.035),
                child: Text(
                  widget.arabic??"",
                  style: const TextStyle(fontSize: 36, color: Colors.white, fontFamily: 'OrelegaOne',letterSpacing: 3),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
