import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/components/grid_view.dart';
import 'package:concessionaire_auto/models/appointment_model.dart';
import 'package:concessionaire_auto/screens/precise_model/precise_model_screen.dart';
import 'package:flutter/material.dart';

import '../../../components/choose_dropdown.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../search_car/components/header.dart';
import '../../../components/button/button.dart';


class Body extends StatefulWidget {
  Body({
    Key? key,
    this.matriculeID,
    this.typeMat,
    //required String leftSide, rightSide;
  }) : super(key: key);

  final String? matriculeID;
  String? typeMat;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final Stream<QuerySnapshot> places = FirebaseFirestore.instance.collection('places').snapshots();
  late String _currentGouv = "initial";
  late String _currentDelegation = "initial";

  List<String> listGouv = [];
  List<String> listDeleg = [];

  AppointmentModel appointment = AppointmentModel();

  Widget wid1 = Container();
  Widget wid2 = Container();
  late Route route;


  @override
  void initState() {
    Map<String,dynamic> matricule = {"id": widget.matriculeID, "type": widget.typeMat};
    appointment.matricule = matricule;
    route = MaterialPageRoute(builder: (context) => PreciseModelScreen(appointment: appointment));
    super.initState();
  }

  onChangeGouv(String value){
    setState(() {
      _currentGouv = value;
      appointment.gouvernorat = _currentGouv;
      wid2 = Container();
      onChangeDeleg("initial");
    });
  }

  onChangeDeleg(String value){
    setState(() {
      _currentDelegation = value;
      appointment.delegation = _currentDelegation;
    });
  }

  getListDeleg(List<String>? list,){
    setState(() {
      listDeleg= [];
      listDeleg = list!;
    });
  }


  @override
  Widget build(BuildContext context) {

    listGouv = [];

    FirebaseFirestore.instance.collection('places').doc(appointment.gouvernorat).collection("delegation").get().then((value) {
      late List<QueryDocumentSnapshot<Object?>> data2 = [];

      if (value.docs.isNotEmpty){
        data2 = value.docs;
      }

      listDeleg = [];

      ListView(
        children: data2.map((DocumentSnapshot document) {
          listDeleg.add(document.id);
          return Container();
        }).toList(),
      );

      getListDeleg(listDeleg);

      if(_currentGouv!="initial"){
        //wid2 = ChooseDropdown(table: listDeleg, onChange: onChangeDeleg, title: "Choisir le garage",);
        wid2 = MyGridView(list: listDeleg, onChange: onChangeDeleg, route: route, islittleWhite: true,);
      }
      route = MaterialPageRoute(builder: (context) => PreciseModelScreen(appointment: appointment));
      return wid2;
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(height: (_currentGouv=="initial")?SizeConfig.screenHeight*0.13 : SizeConfig.screenHeight*0.06),
                  Header(),
                  SizedBox(height: (_currentGouv=="initial")?SizeConfig.screenHeight*0.13 : SizeConfig.screenHeight*0.06),
                  Container(
                    height: (_currentGouv=="initial")?SizeConfig.screenHeight*0.353 : SizeConfig.screenHeight*0.493,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.05, 0.1, 0.5, 0.9],
                            colors: actionContainerColorBlue)),
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        //TapGouv(data: data, matricule: widget.matricule,),
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
                                    listGouv.add(document.id);
                                    return Container();
                                  }).toList(),
                                );

                                wid1 = ChooseDropdown(table: listGouv, onChange: onChangeGouv, title: "Choisir gouvernorat",);

                                return wid1;
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        wid2,
                      ],
                    ),

                  ),
                ],
              ),

            ),
          ),
        ),

      ],
    );
  }

}

