
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../components/matricules/etranger.dart';
import '../../../components/matricules/matricule_type1.dart';
import '../../../components/matricules/matricule_type2.dart';


class TapMatricule extends StatefulWidget {
  final String currentType;
  TapMatricule({Key? key,
    required this.currentType,
    required this.leftSide,
    required this.rightSide,
    required this.getMatricule,
    required this.type,
    this.arabic,
    this.lengthLeft,
    this.lengthRight,
  }) : super(key: key);

  final TextEditingController leftSide;
  final TextEditingController rightSide;
  Function(String,bool) getMatricule;
  final int type;
  final int? lengthLeft, lengthRight;
  final String? arabic;

  @override
  TapMatriculeState createState() => TapMatriculeState();
  }

class TapMatriculeState extends State<TapMatricule>{

  late String _matricule = 'vide mezel';
  late bool _isEmpty=true;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {

    getMatricule(String? left, String? right){
      setState(() {
        _matricule = widget.leftSide.text + widget.currentType + widget.rightSide.text;
        if(widget.type==1 || widget.type==3){
          if(widget.leftSide.text.length<=widget.lengthLeft! && widget.leftSide.text.isNotEmpty){
            _isEmpty = false;
          } else {
            _isEmpty = true;
          }
        } else if(widget.type==2){
          if((widget.leftSide.text.isNotEmpty && widget.rightSide.text.isNotEmpty) && (widget.leftSide.text.length<=widget.lengthLeft! && widget.rightSide.text.length<=widget.lengthRight!)){
            _isEmpty = false;
          }
          else {
            _isEmpty = true;
          }
        }
        widget.getMatricule(_matricule,_isEmpty);
        print("isEmpty"+_isEmpty.toString());
      });
    }
    Widget wid = Container();


    switch(widget.type) {
      case 1 : {
        print("Current Type: " + widget.currentType + ",  Type: " + widget.type.toString());
        wid = MatriculeType1(type: widget.type, mid: widget.leftSide, getMatricule: getMatricule, currentType: widget.currentType, arabic: widget.arabic,length: widget.lengthLeft,);
      } break;

      case 2 : {
        print("Current Type: " + widget.currentType + ",  Type: " + widget.type.toString());
        wid = MatriculeType2(leftSide: widget.leftSide, rightSide: widget.rightSide, getMatricule: getMatricule, currentType: widget.currentType,
          type: widget.type,lengthLeft: widget.lengthLeft, lengthRight: widget.lengthRight,);
      } break;

      case 3 : {
        print("Current Type: " + widget.currentType + ",  Type: " + widget.type.toString());
        wid = Stranger(mid: widget.leftSide, getChassis: getMatricule,length: widget.lengthLeft,);
      } break;

      default : {
        print(widget.currentType);
        wid = Container();
      }
    }

    return wid;
  }
}
