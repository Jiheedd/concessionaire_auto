import 'package:flutter/material.dart';

import '../../components/custom_bottom_nav_bar.dart';
import '../../utils/enums.dart';
import 'components/body.dart';


class AppointmentPlaceScreen extends StatelessWidget {
  static String routeName = "/appointmentPlace";
  late String? matID;
  String? typeMat;

  AppointmentPlaceScreen({Key? key, this.matID, this.typeMat}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(matriculeID: matID, typeMat: typeMat,),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.ajouter,),
    );
  }
}
