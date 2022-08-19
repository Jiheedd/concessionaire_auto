import 'package:concessionaire_auto/models/appointment_model.dart';
import 'package:flutter/material.dart';

import '../../components/custom_bottom_nav_bar.dart';
import '../../utils/enums.dart';
import 'components/body.dart';


class AppointmentDateScreen extends StatelessWidget {
  static String routeName = "/appointmentDate";
  late AppointmentModel? appointment;

  AppointmentDateScreen({Key? key, this.appointment}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(appointment: appointment),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.ajouter,),
    );
  }
}
