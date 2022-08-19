import 'package:concessionaire_auto/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomRadio extends StatefulWidget {

  List? listHeure;
  Function(String)? onChange;
  bool? isRow;
  CustomRadio({
    this.listHeure,
    this.onChange,
    this.isRow = false,
    Key? key
  }) : super(key: key);

  @override
  createState() {
    return CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  late List<RadioModel> sampleData = [];


  @override
  void initState() {
    for(int index=0; index<widget.listHeure!.length; index++){
      sampleData.add(RadioModel(false, "$index", widget.listHeure![index]));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isRow == false) ?
      Column(
      children: [
        for(int index=0; index<widget.listHeure!.length; index++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: getProportionateScreenHeight(5)),
            child: Container(
              //height: (_currentDay=="initial")?SizeConfig.screenHeight*0.6 : SizeConfig.screenHeight*0.7,
                height: SizeConfig.screenHeight*0.08,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.05, 0.1, 0.5, 0.9],
                        colors: actionContainerColorBlue)),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      if(sampleData[index].isSelected == true){
                        sampleData[index].isSelected = false;
                        widget.onChange!("initial");
                      }else {
                        for (var element in sampleData) {
                          element.isSelected = false;
                        }
                        sampleData[index].isSelected = true;
                        widget.onChange!(sampleData[index].text);
                      }
                    });
                  },
                  child: RadioItem(sampleData[index]),
                )
            ),
          )
      ],
    )
    :
      Row(
      children: [
        for(int index=0; index<widget.listHeure!.length; index++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: getProportionateScreenHeight(5)),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if(sampleData[index].isSelected == true){
                    sampleData[index].isSelected = false;
                    widget.onChange!("initial");
                  }else {
                    for (var element in sampleData) {
                      element.isSelected = false;
                    }
                    sampleData[index].isSelected = true;
                    widget.onChange!(sampleData[index].text);
                  }
                });
              },
              child: RadioItem(sampleData[index]),
            )
          )
      ],
    )
    ;
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Row(
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(width: getProportionateScreenWidth(10),),
          Container(
            height: getProportionateScreenHeight(18),
            width: getProportionateScreenHeight(18),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: _item.isSelected
                  ? Container(
                decoration: BoxDecoration(
                  color: _item.isSelected
                      ? Colors.white
                      : Colors.transparent,
                  border: Border.all(
                      width: 1.5,
                      color: _item.isSelected
                          ? Colors.blue
                          : Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                ),
              )
                  : Container()
            ),
            decoration: BoxDecoration(
              color: _item.isSelected
                  ? Colors.white
                  : Colors.transparent,
              border: Border.all(
                  width: 1.5,
                  color: _item.isSelected
                      ? Colors.blue
                      : Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(35)),
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(20),),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Text(
              _item.text,
              style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(18)),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}