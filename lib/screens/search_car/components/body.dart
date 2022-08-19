import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/screens/search_car/components/next_btn.dart';

import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';

import 'header.dart';
import 'tap_matricule.dart';


class SearchCarBody extends StatefulWidget {

  SearchCarBody({this.search, Key? key}) : super(key: key);

  bool? search;

  @override
  State<SearchCarBody> createState() => _SearchCarBodyState();
}

class _SearchCarBodyState extends State<SearchCarBody> {
  final _formKey = GlobalKey<FormState>();
  final Stream<QuerySnapshot> loadMatricules = FirebaseFirestore.instance.collection('matricules').snapshots();

  late String _currentType="";
  late String _matricule="";
  late int _type=0, _lengthLeft=3, _lengthRight=4;
  late String _arabic = '';
  late bool _isEmpty = true;
  bool isEnabled = true;

  TextEditingController leftSide = TextEditingController();
  TextEditingController rightSide= TextEditingController();

  String btnText = "Suivant";

  @override
  void initState() {
    if(widget.search==true){
      btnText = "Chercher";
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    onChange(String value, int type, String? arabic, int lenghtLeft, int? lengthRight){
      setState(() {
        _currentType = value;
        _type = type;
        _arabic = arabic??"";
        _lengthLeft = lenghtLeft;
        _lengthRight = lengthRight!;
      });
    }
    getMatricule(String value, bool isEmpty){
      setState(() {
        _matricule = value;
        _isEmpty = isEmpty;
      });
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Header(search: widget.search),
                    SizedBox(height: _currentType.isEmpty? getProportionateScreenWidth(120) : getProportionateScreenWidth(40)),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: const [0.05, 0.1, 0.35, 0.8],
                              colors: actionContainerColorBlue)),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: SizeConfig.screenHeight * 0.08),
                          StreamBuilder<QuerySnapshot>(
                            stream: loadMatricules,
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.white,
                                        ]),
                                    //color:Colors.white70,
                                    border: Border.all(color: Colors.black38, width:1),
                                    borderRadius: BorderRadius.circular(16),

                                    //borderRadius: BorderRadius.circular(12),
                                    boxShadow: const <BoxShadow> [
                                      BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                          blurRadius: 5),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 23.0, right: 15),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField(
                                        hint: const Text("Choisir le type d'immatriculation", style: TextStyle(fontSize: 16),),
                                        items: snapshot.data!.docs.map((type) {
                                          String titre;
                                          if(type.data().toString().contains("titre:")){
                                            titre = type["titre"];
                                          }else {
                                            titre = type.id.toString();
                                          }
                                          return DropdownMenuItem(
                                            onTap: (){
                                              _type = type["type"];
                                              if (_type==1) {
                                                _arabic = type["arabe"];
                                                _lengthLeft = type["longueur"];
                                              } else if (_type==2){
                                                _lengthLeft = type["gauche"];
                                                _lengthRight = type["droite"];
                                              } else if (_type==3){
                                                _lengthLeft = type["longueur"];
                                              }
                                            },
                                            enabled: isEnabled,
                                            value: type.id,
                                            child: Text(titre, overflow: TextOverflow.fade,),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          _currentType = value.toString();
                                          onChange(_currentType,_type,_arabic,_lengthLeft,_lengthRight);
                                        },
                                        isDense: true,
                                        isExpanded: true, //make true to take width of parent widget
                                        style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                                        dropdownColor: Colors.white,
                                        iconEnabledColor: Colors.black87,
                                        iconSize: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          //ChooseType(currentType: _currentType,onChange: onChange,),
                          SizedBox(height: SizeConfig.screenHeight * 0.06),
                          TapMatricule(currentType: _currentType,leftSide: leftSide,rightSide: rightSide, getMatricule: getMatricule,type: _type, arabic: _arabic,
                            lengthLeft: _lengthLeft, lengthRight: _lengthRight,),
                          SizedBox(height: SizeConfig.screenHeight * 0.1),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: nextButton(isEmpty: _isEmpty, buttonText: btnText, mat: _matricule, typeMat: _currentType, search: widget.search)
                          ),
                          SizedBox(height: getProportionateScreenWidth(30)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


}
