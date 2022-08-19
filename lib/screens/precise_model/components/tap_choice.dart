import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/components/radio_item.dart';
import 'package:concessionaire_auto/screens/appointment_date/appointment_date_screen.dart';
import 'package:flutter/material.dart';
import '../../../components/button/button.dart';
import '../../../components/choose_dropdown.dart';
import '../../../models/appointment_model.dart';
import '../../../models/checkbox_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../home/home_screen.dart';
import '../../search_car/components/header.dart';
import '../../../components/check_box.dart';



class TapChoice extends StatefulWidget {

  AppointmentModel? appointment;

  TapChoice({Key? key, required this.appointment}) : super(key: key);

  @override
  TapChoiceState createState() => TapChoiceState();
}


class TapChoiceState extends State<TapChoice>{

  late double totalPrice;
  late int _totalDuration;
  late String _currentModel = "initial";
  late String _typeEnergy = "initial";
  final CollectionReference _path = FirebaseFirestore.instance.collection('marques');
  late Map<String, dynamic> data3 = {"debut": {"heure" : 7},"fin":{"heure":12}};
  late List<String> listModels;
  List<CheckBoxModel> listOperations = [];
  List<dynamic>? listTypeEnergies = [];
  late List<Map<String,dynamic>> listCheckedOperations;
  Map<String,dynamic> _price = {}, _time = {};

  late bool isAutresActif;
  late int gamme = 2;




  Widget wid2 = Container();
  Widget wid3 = Container();
  Widget wid4 = Container();
  Widget wid5 = Container();
  Widget widAutre = Container();


  @override
  void initState() {
    _currentModel = "initial";
    listCheckedOperations = [];
    listModels = [];
    totalPrice = 0;
    _totalDuration = 0;
    isAutresActif = false;
    super.initState();
  }


  onChangeModel(String model){
    setState(() {
      _currentModel = model;
      widget.appointment!.model = _currentModel;

      FirebaseFirestore.instance.collection("marques").doc(widget.appointment?.marque??"VOLKSWAGEN").collection("models").doc(model).get().then((value) {
        if(value.data().toString().contains("gamme")){
          gamme = value["gamme"];
        }
      });

      totalPrice = 0;
      _typeEnergy = "initial";
      wid3 = Container();
      wid4 = Container();
      wid5 = Container();
      onChangeWidget(Container(), false);
      //isAutresActif = false;
      //widget.onChange(_currentGouv,_currentDelegation,_currentDay,_currentHour);
    });
  }

  onChangeTypeEnergy(String type,){
    setState(() {
      _typeEnergy = type;
      if(type=="initial"){
        totalPrice = 0;
        wid4 = Container();
        wid5 = Container();
        onChangeWidget(Container(), false);
      }
      widget.appointment!.typeEnergy = _typeEnergy;
      //widget.onChange(_currentGouv,_currentDelegation,_currentDay,_currentHour);
    });
  }

  listChecked(bool isChecked, Map<String,dynamic> checkedBoxMap){
    setState(() {
      if(isChecked==true){
        listCheckedOperations.add(checkedBoxMap);
      }else{
        listCheckedOperations.removeWhere((element) => element["titre"] == checkedBoxMap["titre"]);
      }
      widget.appointment!.operations = listCheckedOperations;
    });
  }

  addToServices(int price, int localDuration){
    setState((){
      totalPrice = totalPrice + price;
      _totalDuration = _totalDuration + localDuration;
      widget.appointment!.totalPrice = totalPrice;
      widget.appointment!.averageDuration = _totalDuration;
    });
  }

  subtractFromServices(int price, int localDuration){
    setState((){
      totalPrice = totalPrice - price;
      _totalDuration = _totalDuration - localDuration;
      widget.appointment!.totalPrice = totalPrice;
      widget.appointment!.averageDuration = _totalDuration;
    });
  }

  onChangeWidget(Widget wid, bool isActif){
    setState(() {
      widAutre = wid;
      isAutresActif = isActif;
    });
  }


  @override
  Widget build(BuildContext context) {

    listTypeEnergies = ["Essence", "Disel"];

    if (_currentModel!="initial"){
      //wid3 = ChooseDropdown(table: listTypeEnergies!, onChange: onChangeTypeEnergy, title: "Choisir le type d'énergie",);
      wid3 = CustomRadio(listHeure: listTypeEnergies, onChange: onChangeTypeEnergy, isRow: true,);
    }

    Route route = MaterialPageRoute(builder: (context) => AppointmentDateScreen(appointment: widget.appointment,));


    FirebaseFirestore.instance.collection("operations").get().then((value) {
      listOperations = [];

      List<DocumentSnapshot> list = value.docs.toList();

      for (int i = 0; i < list.length; i++) {

        if(list[i].data().toString().contains("prix")){
          _price = list[i]["prix"];
        }
        if(list[i].data().toString().contains("temps")){
          _time = list[i]["temps"];
        }
        if(_price.isNotEmpty && _time.isNotEmpty) {
          listOperations.add(CheckBoxModel(title: list[i].id, price: _price, time: _time));
        }else if(_price.isNotEmpty){
          listOperations.add(CheckBoxModel(title: list[i].id, price: _price,));
        }else if(_time.isNotEmpty){
          listOperations.add(CheckBoxModel(title: list[i].id, time: _time));
        }else{
          listOperations.add(CheckBoxModel(title: list[i].id));
        }
        _price = {};
        _time = {};
      }
    });


    if (_typeEnergy!="initial"){
      //listCheckedOperations = [];
      //wid4 = ChooseDropdown(table: listOperations, onChange: onAddOperation, title: "Choisir l'opération à éffectuer",);
      wid4 = Padding(
        padding: EdgeInsets.only(left: getProportionateScreenWidth(20), right: getProportionateScreenHeight(20),),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              heightFactor: 3.5,
              child: Text("Choisir les services à éffectuer :", style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.underline),),
            ),
            listOperations.isNotEmpty?
            ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: listOperations.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return OperationItem(
                    title: listOperations[index].title,
                    price: listOperations[index].price,
                    time: listOperations[index].time,
                    gamme: gamme,
                    id: index,
                    addToServices: addToServices,
                    subtractFromServices: subtractFromServices,
                    listCheckedOperations: listChecked,
                  );
                }
            )
                : Container(),
            OperationItem(
              title: "Autres",
              id: listOperations.length,
              onChangeWidget: onChangeWidget,
            ),
            widAutre,
          ],
        ),
      );


      wid5 = Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
        child: Row(
            children: [
              const Text("Prix Total :", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
              const Spacer(),
              Container(
                  height: SizeConfig.screenHeight * 0.065,
                  width: SizeConfig.screenWidth * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text("$totalPrice Dt", style: const TextStyle(color: DarkBlueColor, fontSize: 20, fontWeight: FontWeight.bold,),),
                  )
              ),
            ]
        ),
      );
    }

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
                    SizedBox(height: SizeConfig.screenHeight*0.02),
                    InkWell(
                      child: Header(),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
                    ),
                    SizedBox(height: SizeConfig.screenHeight*0.075),
                    Container(
                      height: (_currentModel=="initial")
                          ? SizeConfig.screenHeight*0.3 : (_typeEnergy=="initial")
                          ? SizeConfig.screenHeight*0.38 : (isAutresActif == false)
                          ? SizeConfig.screenHeight * (listOperations.length/10) : SizeConfig.screenHeight * (listOperations.length/8.6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),

                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: const [0.05, 0.1, 0.5, 0.9],
                              colors: actionContainerColorBlue)),
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * 0.05),
                          StreamBuilder(
                            stream: _path.doc(widget.appointment?.marque??"VOLKSWAGEN").collection("models").snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                              late List<QueryDocumentSnapshot<Object?>> data2 = [];

                              if (snapshot.hasData){
                                data2 = snapshot.data!.docs;
                              }

                              listModels = [];

                              ListView(
                                children: data2.map((DocumentSnapshot document) {
                                  listModels.add(document.id);
                                  return Container();
                                }).toList(),
                              );

                              wid2 = ChooseDropdown(table: listModels, onChange: onChangeModel, title: "Choisir le jour de rendez-vous",);

                              return wid2;
                            }),
                          SizedBox(height: SizeConfig.screenHeight * 0.04),
                          wid3,
                          SizedBox(height: SizeConfig.screenHeight * 0.04),
                          wid4,
                          SizedBox(height: SizeConfig.screenHeight * 0.06),
                          wid5,
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Center(
                          child: nextButton(
                            appointment: widget.appointment,
                            titre: "Suivant",
                            route: route,
                            isColorBlue: true,
                          )
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                  ],
                ),
              )
          ),
        ),
      ],
    );
  }
}
