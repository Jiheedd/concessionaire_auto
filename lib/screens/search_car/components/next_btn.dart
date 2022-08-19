import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/models/appointment_model.dart';
import 'package:concessionaire_auto/screens/management_data/management_data_screen.dart';
import 'package:concessionaire_auto/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helper/keyboard.dart';
import '../../../utils/size_config.dart';
import '../../appointment_place/appointment_place_screen.dart';

class nextButton extends StatefulWidget {

  nextButton({
    Key? key,
    required this.buttonText,
    this.mat,
    this.typeMat,
    required this.isEmpty,
    this.search,
  }) : super(key: key);

  bool? search;
  bool isEmpty=true;
  final String? mat;
  final String buttonText;
  String? typeMat;
  //final AppointmentScreen routeWithData;

  @override
  State<nextButton> createState() => _nextButtonState();
}

class _nextButtonState extends State<nextButton> {
  @override
  Widget build(BuildContext context) {
    Color? txtColor = DarkBlueColor;
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
          KeyboardUtil.hideKeyboard(context);

          if (widget.isEmpty==true) {
            Fluttertoast.showToast(msg: "Entrer les coordonnées de votre matricule");
          }else{
            if(widget.search==true){
              Navigator.push(context,MaterialPageRoute(builder: (context) => const ManagementDataScreen()),);
            }else {
              Navigator.push(context,MaterialPageRoute(builder: (context) => AppointmentPlaceScreen(matID: widget.mat, typeMat: widget.typeMat,)),);
              txtColor = Colors.yellow;
            }
            //postDetailsToFirestore(mat!);
          }

        },
        child: Text(
          widget.buttonText,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
            fontWeight: FontWeight.w900,
            letterSpacing: 7,
            fontStyle: FontStyle.normal,
            color: txtColor,
          ),
        ),
      ),
    );
  }
}

postDetailsToFirestore(String matID) async {
  // calling our FireStore
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // calling our user model
  AppointmentModel appointment = AppointmentModel();

  // writting all the values
  appointment.matricule = {"id": matID};
  //carModel.title = "FORD FIESTA";

  // sending there values
  await firebaseFirestore
      .collection("appointments")
      .doc(matID)
      .set(appointment.toMap());
}

