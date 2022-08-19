import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/models/appointment_model.dart';
import 'package:concessionaire_auto/screens/precise_model/precise_model_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helper/keyboard.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../appointment_place/appointment_place_screen.dart';

class nextButton extends StatelessWidget {

  nextButton({
    Key? key,
    required this.buttonText,
    this.mat,
    this.typeMat,
    required this.isEmpty,
  }) : super(key: key);

  bool isEmpty=true;
  final String? mat, typeMat;
  final String buttonText;
  //final AppointmentScreen routeWithData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
      width: getProportionateScreenWidth(120),
      height: getProportionateScreenWidth(40),
      decoration: BoxDecoration(
          color: borderContainer,
          borderRadius: BorderRadius.circular(30)
      ),
      child: FlatButton(
        onPressed: () {
          KeyboardUtil.hideKeyboard(context);

          if (isEmpty==true) {
            Fluttertoast.showToast(msg: "Entrer les coordonnées de votre matricule");
          }else{
            Navigator.push(context,MaterialPageRoute(builder: (context) => AppointmentPlaceScreen(matID: mat, typeMat: typeMat,)));
          }
        },
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
            fontWeight: FontWeight.w900,
            letterSpacing: 7,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


