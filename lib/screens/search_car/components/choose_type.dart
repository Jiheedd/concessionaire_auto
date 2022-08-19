import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChooseType extends StatefulWidget {

  late String currentType;
  Function(String,int,String,int,int)? onChange;

  ChooseType({
    required this.currentType,
    this.onChange,
    Key? key,
  }) : super(key: key);


  @override
  _ChooseTypeState createState() => _ChooseTypeState();
}

class _ChooseTypeState extends State<ChooseType> {
  final Stream<QuerySnapshot> loadMatricules = FirebaseFirestore.instance.collection('matricules').snapshots();
  late int _type, lengthLeft, lengthRight;
  String _arabic = "";
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
                    Colors.blue,
                  ]),
              color:Colors.white,
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
                    return DropdownMenuItem(
                      onTap: (){
                        _type = type["type"];
                        if (_type==1) {
                          _arabic = type["arabe"];
                          lengthLeft = type["longueur"];
                        } else if (_type==2){
                          lengthLeft = type["gauche"];
                          lengthRight = type["droite"];
                        } else if (_type==3){
                          lengthLeft = type["longueur"];
                        }
                      },
                      enabled: isEnabled,
                      value: type.id,
                      child: Text(type["titre"], overflow: TextOverflow.fade,),
                    );
                  }).toList(),
                  onChanged: (value) {
                    widget.currentType = value.toString();
                    widget.onChange!(widget.currentType,_type,_arabic,lengthLeft,lengthRight);
                  },
                  isDense: true,
                  isExpanded: true, //make true to take width of parent widget
                  style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                  dropdownColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  iconSize: 32,
                ),
              ),
            ),
          ),
        );
        },
    );
  }
}

