
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/screens/management_data/components/next_btn.dart';
import 'package:concessionaire_auto/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../components/matricules_disabled/etranger.dart';
import '../../../components/matricules_disabled/matricule_type1.dart';
import '../../../components/matricules_disabled/matricule_type2.dart';
import '../../../utils/constants.dart';


class AppointmentInfo extends StatefulWidget {
  final DocumentSnapshot appointmentDocument;
  const AppointmentInfo({Key? key,
    required this.appointmentDocument,
  }) : super(key: key);

  @override
  AppointmentInfoState createState() => AppointmentInfoState();

  }

class AppointmentInfoState extends State<AppointmentInfo>{

  late String _matriculeID = 'vide mezel';
  late String _typeAbrev;

  late int lengthLeft, lengthRight;
  late String leftSide="", rightSide="", arabic;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {

    _matriculeID = widget.appointmentDocument["matricule"]["id"];
    _typeAbrev = widget.appointmentDocument["matricule"]["type"];

    Widget wid = Container();



    return Column(
      children: [
        FutureBuilder(
            future: FirebaseFirestore.instance.collection("matricules").doc(_typeAbrev).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {


              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white,),
                );
              }else if(snapshot.connectionState == ConnectionState.done){

                late DocumentSnapshot? data;
                data = snapshot.data!;


                if(data["type"]==1 || data["type"]==3){
                  lengthLeft = data["longueur"];
                  arabic = data["arabe"];
                  int indexOf = _matriculeID.indexOf(_typeAbrev);
                  print("index : $indexOf");
                  leftSide = _matriculeID.substring(0,indexOf);
                }else if(data["type"]==2){
                  lengthLeft = data["gauche"];
                  lengthRight = data["droite"];
                  int indexOf = _matriculeID.indexOf(_typeAbrev);
                  leftSide = _matriculeID.substring(0, indexOf);
                  rightSide = _matriculeID.substring(indexOf+2);
                }

                switch(data["type"]) {
                  case 1 : {
                    wid = GestureDetector(
                      child: MatriculeType1(mid: leftSide, currentType: _typeAbrev, arabic: data["arabe"],),
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentsScreen(matID: _matriculeID, typeMat: _typeAbrev,)));
                        openDialog();
                      },
                    );
                  } break;

                  case 2 : {
                    wid = GestureDetector(
                      child: MatriculeType2(leftSide: leftSide, rightSide: rightSide, currentType: _typeAbrev,),
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentsScreen(matID: _matriculeID, typeMat: _typeAbrev,)));
                        openDialog();
                      },
                    );
                  } break;

                  case 3 : {
                    wid = Stranger(mid: leftSide);
                  } break;

                  default : {
                    //print(widget.currentType);
                    wid = MatriculeType1(mid: leftSide, currentType: _typeAbrev, arabic: "ن ت",);
                  }
                }
                return wid;
              }
              return const Center(
                child: CircularProgressIndicator(color: Colors.white,),
              );
            }


        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        )
      ],
    );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(30), horizontal: getProportionateScreenWidth(20)),
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(30)),
          child: Text("Les détails de rendez-vous", style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(20), color: borderContainer),),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
        ),
        content: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  const Text("Ce rendez-vous sera le "),
                  Expanded(child: Text("${widget.appointmentDocument["jour"]??""}", style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),)),
                  //SizedBox(width: getProportionateScreenWidth(15)),
                ],
              ),
              //Text("de ${widget.appointmentDocument["heure"]}"),
              SizedBox(height: getProportionateScreenHeight(20),),
              Row(
                children: [
                  const Text("De "),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Text(widget.appointmentDocument["heure"]??"", style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                  const Text(", la chaîne ",),
                  Text("${widget.appointmentDocument["chaine"]??""}.", style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20),),
              Row(
                children: const [
                  Text("Les operations à effectuer :"),
                ],
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Column(
                  children: [
                    for(var operation in widget.appointmentDocument["services"]["operations"]??[])
                      Row(
                        children: [
                          const Text("- "),
                          Text("${operation["titre"]??""}", style: const TextStyle(fontWeight: FontWeight.bold,),),
                        ],
                      ),
                  ]
              ),
              SizedBox(height: getProportionateScreenHeight(10),),
              Row(
                children: [
                  const Text("Voiture: "),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Expanded(child: Text(
                    "${widget.appointmentDocument["voiture"]["marque"]??""}, ${widget.appointmentDocument["voiture"]["model"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(30),),
              Row(
                children: [
                  const Text("Localisation: "),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Expanded(child: Text(
                    "${widget.appointmentDocument["gouvernorat"]??""}, ${widget.appointmentDocument["delegation"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20),),
              Row(
                children: [
                  const Text("Total de facturation :"),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Text(widget.appointmentDocument["services"]["prix_total"]??"", style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: Colors.green),),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(60),),
              nextButton(buttonText: "modifier", isEmpty: false, mat: _matriculeID, typeMat: _typeAbrev,),
              SizedBox(height: getProportionateScreenHeight(15),),
            ],
          ),
        ),
      ),
  );
}
