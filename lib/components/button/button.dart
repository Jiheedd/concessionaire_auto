import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';


class nextButton extends StatelessWidget {
  nextButton({
    Key? key,
    this.route,
    this.titre,
    this.isColorBlue,
    this.isFinal,
    this.appointment,
  }) : super(key: key);

  final Route? route;
  final String? titre;
  bool? isColorBlue = false;
  bool? isFinal = false;
  AppointmentModel? appointment;

  BoxDecoration _boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30)
  );

  Color _txtColor = DarkBlueColor;


  @override
  Widget build(BuildContext context) {

    if(isColorBlue==true) {
      _boxDecoration = BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              stops: const [0, 0.1, 0.5, 0.9],
              colors: actionContainerColorBlue),
          borderRadius: BorderRadius.circular(30)
      );
      _txtColor = Colors.white;
    }
    return Container(
      margin: const EdgeInsets.all(20),
      width: getProportionateScreenWidth(220),
      height: getProportionateScreenWidth(45),
      decoration: _boxDecoration,
      child: FlatButton(
        onPressed: () {

          if(isFinal==true) {
            Navigator.pushNamedAndRemoveUntil(context,HomeScreen.routeName,ModalRoute.withName('/'));
            //Navigator.pushNamed(context,HomeScreen.routeName,);
            updateDetailsInFirestore(appointment!);
          }else {
            //Navigator.pushNamedAndRemoveUntil(context, TapChoice.routeName, ModalRoute.withName('/search_car'));
            Navigator.push(context,route!);
          }

        },
        child: Text(
          titre??"Enregistrer",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
            fontWeight: FontWeight.w900,
            letterSpacing: 7,
            fontStyle: FontStyle.normal,
            color: _txtColor,
          ),
        ),
      ),
    );
      //btnWhite(buttonText: "Suivant", routeName: HomeScreen.routeName);
  }
}

updateDetailsInFirestore(AppointmentModel appointment) async {

  List divisHeure = [];
  String time = "";
  int initList = int.parse(appointment.heure!.substring(0, appointment.heure!.indexOf("h")));

  int endList = 0;

  String _heure = appointment.heure!;

  if(initList < 10 && (initList+appointment.averageDuration!)>=10) {
    endList = int.parse(_heure.substring(_heure.indexOf("->")+3).substring(0,_heure.indexOf('h')+1));
  }else {
    endList = int.parse(_heure.substring(_heure.indexOf("->")+3).substring(0,_heure.indexOf('h')));
  }

  print("init lettre $initList");

  //initList = int.parse(initList.substring(0,initList.indexOf('h')));
  print("end lettre $endList");

  for(int i = initList; i<endList; i++){
    time = "${i}h -> ${i+1}h";
    divisHeure.add(time);
  }

  // calling our FireStore
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // calling our models
  User? user = FirebaseAuth.instance.currentUser;
  String userId = user?.uid??"";
  //Appointment appointment = Appointment();
  List<dynamic> reservedTimes = [];
  List<dynamic> listMatricules = [];
  int _capacite = 1;
  List<String> chaines = [];


  await firebaseFirestore
      .collection("appointments")
      .doc(appointment.matricule!["id"])
      .set(appointment.toMap());

  await firebaseFirestore
      .collection("places")
      .doc(appointment.gouvernorat)
      .collection("delegation")
      .doc(appointment.delegation)
      .get()
      .then((value) {

        if (value.data()!.containsKey("capacite")) {
          _capacite = value["capacite"];
        }

        for(int i=1; i<=_capacite; i++){
          chaines.add("Ch$i");
        }

        if(appointment.heure!=null && appointment.jour!=null){
          bool affected = false;
          int i=0;
          while(i<chaines.length && affected==false) {
            List<dynamic> heureList = [];
            reservedTimes.clear();
            if(value.data()!.containsKey(chaines[i])){
              reservedTimes = value[chaines[i]];
              bool dayExist = false;
              int j = 0;
              print("Value : ${value[chaines[i]]}");
              while(j<reservedTimes.length && dayExist==false){
                if(appointment.jour == reservedTimes[j]["jour"]){
                  heureList = [];
                  heureList = reservedTimes[j]["heure"];
                  for(int i=0; i<divisHeure.length; i++) {
                    if(!heureList.contains(divisHeure[i])){
                      heureList.add(divisHeure[i]);
                      reservedTimes[j]["heure"] = heureList;
                      affected = true;
                    }
                  }
                  dayExist = true;
                }
                j++;
              }
              if(dayExist==false){
                heureList = [];
                for(int i=0; i<divisHeure.length; i++) {
                  heureList.add(divisHeure[i]);
                }
                Map<String,dynamic> date = {"jour": appointment.jour, "heure": heureList};
                reservedTimes.add(date);
                affected = true;
              }
            }else{
              //heureList = [];
              for(int i=0; i<divisHeure.length; i++) {
                heureList.add(divisHeure[i]);
              }
              Map<String,dynamic> date = {"jour": appointment.jour, "heure": heureList};
              reservedTimes.add(date);
              affected = true;
            }
            if(affected==false) {
              i++;
            }
          }
          print("Affected = $affected");
          if(affected==true){
            firebaseFirestore
                .collection("places")
                .doc(appointment.gouvernorat)
                .collection("delegation")
                .doc(appointment.delegation)
                .update({chaines[i] : reservedTimes});
            print("reserved times = $reservedTimes");
          }else{
            print("Saturée le ${appointment.jour} de ${appointment.heure}");
          }
        }

  });

  if(userId.isNotEmpty) {
    firebaseFirestore
      .collection("user")
      .doc(userId)
      .get()
      .then((value) {


    if (value.data()!.containsKey("matricules")) {
      listMatricules = value["matricules"];
    }

    if ((appointment.matricule!["id"].isNotEmpty) && (!listMatricules.contains(appointment.matricule!["id"]))) {
      listMatricules.add(appointment.matricule!["id"]);
    }



    firebaseFirestore
        .collection("user")
        .doc(userId)
        .update({'matricules' : listMatricules});
    });
  }


}
