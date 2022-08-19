
import 'package:concessionaire_auto/utils/constants.dart';
import 'package:concessionaire_auto/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../models/time_model.dart';

class OperationItem extends StatefulWidget {
  final String? title;
  final int? id;
  Map<String,dynamic>? price;
  Map<String, dynamic>? time;
  int? gamme;
  Function(int, int)? addToServices;
  Function(int, int)? subtractFromServices;
  Function(Widget, bool)? onChangeWidget;
  Function(bool, Map<String,dynamic>)? listCheckedOperations;

  OperationItem({
    required this.title,
    this.id,
    this.price,
    this.time,
    this.gamme,
    this.addToServices,
    this.subtractFromServices,
    this.onChangeWidget,
    this.listCheckedOperations,
    Key? key}) : super(key: key);

  @override
  _OperationItemPageState createState() => _OperationItemPageState();
}

class _OperationItemPageState extends State<OperationItem> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late Map<String, dynamic> duration;
  Map<String, dynamic> checkedBox = {};

  bool _checkboxConditions = false;
  late int _price, maxPrice, minPrice;
  late int minDuration, maxDuration, averageDuration;


  @override
  void initState() {

    if(widget.price != null){
      if(widget.price!.containsKey("minimum")) {
        minPrice = widget.price?["minimum"];
      }
      if(widget.price!.containsKey("maximum")) {
        maxPrice = widget.price?["maximum"];
      }
    }


    switch(widget.gamme){
      case 1: {
        if(widget.price != null) {
          _price = widget.price?["minimum"];
        }else {
          _price = 10;
        }
      } break;
      case 2: {
        if(widget.price != null) {
          _price = (minPrice + (maxPrice - minPrice) * 0.25).round();
        }else {
          _price = 20;
        }
      } break;

      case 3: {
        if(widget.price != null) {
          _price = (minPrice + (maxPrice - minPrice) * 0.5).round();
        }else {
          _price = 50;
        }
      } break;
      case 4: {
        if(widget.price != null) {
          _price = (minPrice + (maxPrice - minPrice) * 0.75).round();
        }else {
          _price = 70;
        }
      } break;

      case 5: {
        if(widget.price != null) {
          _price = maxPrice;
        }else {
          _price = 90;
        }
      } break;

      default: {
        _price = 20;
      } break;
    }

    if(widget.title != "Autres"){

      duration = {"maximum": {"heure" : 1, "minute": 30}, "minimum":{"minute":30}};

      Map<String,dynamic> _time, _widgetTime;

      _widgetTime = widget.time??{};


      if (_widgetTime.containsKey("maximum")) {
        _time = widget.time!["maximum"];
        if(_time.containsKey("heure") || _time.containsKey("minute")){
          duration["maximum"] = _time;
        }
      }

      if (_widgetTime.containsKey("minimum")) {
        _time = widget.time!["minimum"];
        if(_time.containsKey("heure") || _time.containsKey("minute")){
          duration["minimum"] = _time;
        }

      }

      int heureMax = Time.fromMap(duration["maximum"]).heure??1;
      int minuteMax = Time.fromMap(duration["maximum"]).minute??30;
      int heureMin = Time.fromMap(duration["minimum"]).heure??0;
      int minuteMin = Time.fromMap(duration["minimum"]).minute??0;

      maxDuration = heureMax*60 + minuteMax;
      minDuration = heureMin*60 + minuteMin;
    }


    super.initState();
  }



  final Widget _widget = Padding(
    padding: EdgeInsets.only(top: getProportionateScreenHeight(30)),
    child: TextField(
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: "Entrer votre service demandé ..",
        hintStyle: const TextStyle(fontSize: 18),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.green, ),
          borderRadius: BorderRadius.circular(25),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.white70, ),
          borderRadius: BorderRadius.circular(25),
        ),
        filled: true,
        fillColor: Colors.white
      ),
    ),
  );


  @override
  Widget build(BuildContext context) {

    checkedBox["titre"] = widget.title;
    checkedBox["prix"] = "$_price DT";

    if(widget.title != "Autres") {
      averageDuration = ((maxDuration + minDuration)/2).floor();
      checkedBox["duree"] = "$averageDuration min";

    }



    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      child: Material(
        color: const Color(0x00ffffff),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          onTap: () {
            setState(() {
              _checkboxConditions = !_checkboxConditions;
            });

            if (_checkboxConditions) {

              if(widget.title=="Autres"){
                widget.onChangeWidget!(_widget, true);
              }else {
                widget.addToServices!(_price, averageDuration);
                widget.listCheckedOperations!(_checkboxConditions, checkedBox);
              }

            } else {
              if(widget.title=="Autres"){
                widget.onChangeWidget!(Container(), false);
              }else {
                widget.subtractFromServices!(_price, averageDuration);
                widget.listCheckedOperations!(_checkboxConditions, checkedBox);
              }
            }
          },
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 12, bottom: 12, right: 16),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 24, left: 24),
              width: 24,
              height: 24,
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white,
                ),
                child: Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    side: const BorderSide(
                        width: 0.5, color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    activeColor: Colors.green,
                    checkColor: DarkBlueColor,
                    value: _checkboxConditions,
                    onChanged: (bool? isChecked) {

                      if (isChecked!) {
                        if(widget.title=="Autres"){
                          widget.onChangeWidget!(_widget, true);
                        }else {
                          widget.addToServices!(_price, averageDuration);
                          widget.listCheckedOperations!(true, checkedBox);

                        }
                      } else {

                        if(widget.title=="Autres"){
                          widget.onChangeWidget!(Container(), false);
                        }else {
                          widget.subtractFromServices!(_price, averageDuration);
                          widget.listCheckedOperations!(false, checkedBox);

                        }

                      }
                      setState(() {
                        _checkboxConditions = !_checkboxConditions;
                      });
                    },
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}