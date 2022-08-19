import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/components/radio_item.dart';
import 'package:concessionaire_auto/models/appointment_model.dart';
import 'package:flutter/material.dart';

import '../../../models/time_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../precise_model/precise_model_screen.dart';
import '../../../components/button/button.dart';


class Body extends StatefulWidget {
  Body({
    Key? key,
    this.appointment,
    //required String leftSide, rightSide;
  }) : super(key: key);

  AppointmentModel? appointment;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  static String _currentDay = "initial";
  static String _currentHour = "initial";

  final CollectionReference _path = FirebaseFirestore.instance.collection('places');
  late Map<String, dynamic> data3 = {"debut": {"heure" : 7},"fin":{"heure":12}};
  static List<dynamic> listHeure = [];
  List<dynamic>? listJours = [];
  late List<dynamic> hourReserved;
  late int _capacite;
  late List<List> chaines;
  late DateTime tomorrow;
  late int _duration;


  Widget wid3 = Container();
  Widget wid4 = SizedBox(height: SizeConfig.screenHeight*0.15,);

  @override
  void initState() {
    hourReserved = [] ;
    _capacite = 1;
    chaines = [];
    tomorrow = DateTime.now().add(const Duration(days: 1));
    super.initState();
  }

  onChangeDay(String day,){
    setState(() {
      _currentDay = day;
      widget.appointment!.jour = _currentDay;
      _currentHour = "initial";
      wid4 = SizedBox(height: SizeConfig.screenHeight*0.25,);
    });
  }

  onChangeHour(String hour){
    setState(() {
      _currentHour = hour;
      widget.appointment!.heure = _currentHour;
      print("l'heure $_currentHour");

    });
  }

  getListHour(List<dynamic>? list){
    setState(() {
      listHeure = [];
      listHeure = list!;
    });
  }

  onChangeDate(DateTime dateTime){

    String day,month;
    if(dateTime.month<10) {
      month = "0${dateTime.month}";
    }else {
      month = "${dateTime.month}";
    }
    if(dateTime.day<10) {
      day = "0${dateTime.day}";
    }else{
      day = "${dateTime.day}";
    }
    //_currentDay = "${dateTime.year}/$month/$day";

    onChangeDay("${dateTime.year}/$month/$day");

    print("CurrentDay : $_currentDay");

    _path.doc(widget.appointment?.gouvernorat??"Ariana").collection("delegation").doc(widget.appointment?.delegation??"Sokra").get().then((value) {

      if (value.data()!.containsKey("capacite")) {
        _capacite = value["capacite"];
      }

      if(value.data()!.containsKey("debut")) {
        data3["debut"] = value["debut"];
      }
      if(value.data()!.containsKey("fin")) {
        data3["fin"] = value["fin"];
      }

      if(value.data()!.isEmpty){
        wid4 = const CircularProgressIndicator();
      }else{
        FirebaseFirestore.instance
            .collection("places")
            .doc(widget.appointment!.gouvernorat)
            .collection("delegation")
            .doc(widget.appointment!.delegation)
            .get().then((value) {

          for(int i=1; i<=_capacite; i++){
            String ch = "Ch$i";
            if(value.data()!.containsKey(ch)) {
              chaines.add(value.get(ch));
            }else{
              chaines.add([{"heure": [], "jour": ""}]);
            }
          }

          List<bool> listDaysExist = [];
          for(int i=0; i<chaines.length; i++){
            if(value.data()!.containsKey("Ch${i+1}")){
              for(int j=0; j<chaines[i].length; j++) {
                Map<String,dynamic> date = chaines[i][j];
                if (date["jour"] == _currentDay){
                  listDaysExist.add(true);
                  if(i==0){
                    hourReserved = date["heure"];
                  }
                  List Heures = date["heure"];
                  for (int i =0; i<hourReserved.length; i++) {
                    if(!Heures.contains(hourReserved[i])){
                      hourReserved.remove(hourReserved[i]);
                    }
                  }
                }
              }
            }
          }
          if(listDaysExist.length!=_capacite){
            hourReserved = [];
          }

          print("list heure : $listHeure");

          List elimineHours = [];
          for(int i=0; i<listHeure.length; i++) {
            String _heure = listHeure[i];
            List divisHeure = [];
            String time = "";

            int initList = int.parse(_heure.substring(0, _heure.indexOf("h")));
            print("init List = $initList");
            int endList;
            if(initList < 10 && (initList+_duration)>=10) {
              endList = int.parse(_heure.substring(_heure.indexOf("->")+3).substring(0,_heure.indexOf('h')+1));
            }else {
              endList = int.parse(_heure.substring(_heure.indexOf("->")+3).substring(0,_heure.indexOf('h')));
            }
            print("end List = $endList");

            for(int i = initList; i<endList; i++){
              time = "${i}h -> ${i+1}h";
              divisHeure.add(time);
            }

            for(int j=0; j<divisHeure.length; j++) {
              print("divis$j = ${divisHeure[j]}");

              if(hourReserved.contains(divisHeure[j])){
                elimineHours.add(listHeure[i]);
              }
            }
          }

          for(int i=0; i<elimineHours.length; i++){
            if(listHeure.contains(elimineHours[i])){
              listHeure.remove(elimineHours[i]);
            }
          }

          getListHour(listHeure);

          if (_currentDay!="initial"){
            if(listHeure.isNotEmpty) {
              wid4 = CustomRadio(
                listHeure: listHeure,
                onChange: onChangeHour,
              );
            }else {
              wid4 = Container(
                //height: (_currentDay=="initial")?SizeConfig.screenHeight*0.6 : SizeConfig.screenHeight*0.7,
                width: SizeConfig.screenWidth*0.9,
                height: SizeConfig.screenHeight*0.2,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.05, 0.1, 0.5, 0.9],
                        colors: actionContainerColorBlue)
                ),
                child: Text(
                  (widget.appointment!.averageDuration!=0)
                      ?
                  "Votre service a besoin d'environ ${_duration} heures. \nCette période n'est pas disponible le \"${_currentDay}\""
                      :
                  "Les chaînes sont réservés pour toutes la journée   \n\" ${_currentDay} \"",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getProportionateScreenWidth(18),
                      color: Colors.white,
                      letterSpacing: 2,
                      height: 2
                  ),
                ),
              );
            }
          }
        });
      }
    });
  }


  late Route route;

  @override
  Widget build(BuildContext context) {

    int heureDebut = Time.fromMap(data3["debut"]).heure??8;
    int heureFin = Time.fromMap(data3["fin"]).heure??14;

    String time = "";
    listHeure = [];

    _duration = (widget.appointment!.averageDuration!/60).ceil();

    for (int i=heureDebut; i < heureFin; i++){
      if(i+_duration<=heureFin) {
        time = "${i}h -> ${i+_duration}h";
        listHeure.add(time);
      }
    }

    Route route = MaterialPageRoute(builder: (context) => PreciseModelScreen(appointment: widget.appointment));

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
                  //SizedBox(height: SizeConfig.screenHeight*0.1),
                  //Header(),
                  SizedBox(height: SizeConfig.screenHeight*0.1),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                    child: Column(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: CalendarDatePicker(
                            initialDate: (tomorrow.weekday == 6 || tomorrow.weekday==7)?DateTime.now().add(const Duration(days: 3)):tomorrow,
                            firstDate: tomorrow,
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                            onDateChanged: (dateTime) => onChangeDate(dateTime),
                            selectableDayPredicate: (DateTime val) {
                              return val.weekday == 7
                                  || val.weekday == 6

                                  ?
                              false : true;
                            },
                            //onDateChanged: (dateTime) => _selectDate(context, dateTime),
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: getProportionateScreenHeight(5),),
                  wid4,
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                        child: nextButton(
                          appointment: widget.appointment,
                          route: route,
                          isColorBlue: true,
                          isFinal: true,
                        )
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

