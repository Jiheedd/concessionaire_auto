import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const[
            SizedBox(height: 50,),
            Text("Rendez-vous", style: TextStyle(
              fontSize: 48,
              color: DarkBlueColor,
              fontFamily: 'Lobster',
              letterSpacing: 2,
            ),),
            SizedBox(height: 10,),
            Text("Taper sur le matricule pour afficher ou modifier les détails", style: TextStyle(
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
