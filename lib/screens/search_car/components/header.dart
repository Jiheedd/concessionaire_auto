import 'package:concessionaire_auto/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {

  Header({
    this.title = "Pour prendre un rendez-vous",
    this.underTitle = "Merci de passer vos coordonnées",
    this.search,
    Key? key
  }) : super(key: key);

  bool? search;
  String? title;
  String? underTitle;


  @override
  Widget build(BuildContext context) {
    if(search==true){
      title = "Pour chercher une voiture";
      underTitle = "Passer les coordonnées de matricule";
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            const SizedBox(height: 50,),
            Text( title!, style: const TextStyle(
              fontSize: 48,
              color: DarkBlueColor,
              fontFamily: 'Lobster',
              letterSpacing: 2,
            ),),
            const SizedBox(height: 10,),
            Text(underTitle!, style: const TextStyle(
              fontSize: 20,
              color: DarkBlueColor,
              fontFamily: 'Muli',
              letterSpacing: 2,
            ),),
          ],
        ),
      ),
    );
  }
}
