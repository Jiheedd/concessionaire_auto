import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/models/appointment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/size_config.dart';

class btnWhite extends StatelessWidget {

  const btnWhite({
    Key? key,
    required this.buttonText,
    required this.routeName,
    this.mat,
    //this.postData,

  }) : super(key: key);

  final String? mat;
  final String buttonText;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: getProportionateScreenWidth(220),
      height: getProportionateScreenWidth(45),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.pushNamed(context,routeName);
          print("DOOOONNEE" + mat!);

          //postDetailsToFirestore(mat!);
          //postData!;
        },
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
            fontWeight: FontWeight.w900,
            letterSpacing: 7,
            fontStyle: FontStyle.normal,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

postDetailsToFirestore(String data) async {
  // calling our FireStore
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // calling our user model
  AppointmentModel appointment = AppointmentModel();

  // writting all the values
  //appointment.matriculeID = data ;////
  //carModel.title = "FORD FIESTA";

  // sending there values
  await firebaseFirestore
      .collection("appointments")
      .doc(data)
      .set(appointment.toMap());
}

