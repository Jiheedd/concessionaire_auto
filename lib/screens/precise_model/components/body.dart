import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/models/appointment_model.dart';
import 'package:flutter/material.dart';

import '../../../components/button/button.dart';
import '../../../components/choose_dropdown.dart';
import '../../../components/grid_view.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../search_car/components/header.dart';
import 'tap_choice.dart';


class Body extends StatefulWidget {
  Body({
    Key? key,
    this.appointment,
  }) : super(key: key);

  AppointmentModel? appointment;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final Stream<QuerySnapshot> places = FirebaseFirestore.instance.collection('marques').snapshots();
  late String _currentMarque = "VOLKSWAGEN";

  List<String> listMarques = [];


  Widget wid1 = Container();

  @override
  void initState() {
    super.initState();

  }

  onChangeMarque(String value){
    setState(() {
      _currentMarque = value;
      widget.appointment?.marque = _currentMarque;
      //widget.onChange(_currentGouv,"initial","initial","initial");
    });

  }

  late Route route;

  @override
  Widget build(BuildContext context) {

    listMarques = [];

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //SizedBox(height: SizeConfig.screenHeight*0.1,),
                      Header(title: "Choisir le modèle", underTitle: "Merci de choisir le modèle de votre voiture"),
                      SizedBox(height: SizeConfig.screenHeight*0.07,),
                      StreamBuilder<QuerySnapshot>(
                          stream: places,
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            late List<QueryDocumentSnapshot<Object?>> data = [];
                            if (snapshot.hasData){
                              data = snapshot.data!.docs;
                            }

                            //Route route = MaterialPageRoute(builder: (context) => AppointmentsScreen(matID: widget.matricule));


                            if (data.isNotEmpty) {
                              ListView(
                                children: data.map((DocumentSnapshot document) {
                                  listMarques.add(document.id);
                                  return Container();
                                }).toList(),
                              );

                              route = MaterialPageRoute(builder: (context) => TapChoice(appointment: widget.appointment));

                              return MyGridView(list: listMarques, onChange: onChangeMarque, route: route,);
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          })
                    ],
                  )
              ),
            )
            ),
          ),

      ],
    );
  }

}

