import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/size_config.dart';

class MyGridView extends StatefulWidget {

  List? list;
  Function(String)? onChange;
  final Route? route;
  bool? islittleWhite;

  MyGridView({
    this.list,
    this.onChange,
    this.route,
    this.islittleWhite = false,
    Key? key
  }) : super(key: key);

  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {

  // set an int with value -1 since no card has been selected
  int selectedCard = -1;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.list?.length??2,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 20,
          mainAxisSpacing: 25,
          crossAxisCount: 2,
          childAspectRatio: widget.islittleWhite==true ?
              SizeConfig.screenHeight*0.004
            :
              SizeConfig.screenHeight*0.0015
        ),
        padding: const EdgeInsets.all(25),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.onChange!(widget.list![index]);
                selectedCard = index;
                Navigator.push(context,widget.route!);
              });
            },
            child: widget.islittleWhite == true ?
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                //color: selectedCard == index ? Colors.amber : Colors.white,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.05, 0.1, 0.5, 0.9],
                    colors: selectedCard == index ? backgroundColorDark : backgroundColorLight
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${widget.list![index]}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: DarkBlueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            )
                :
            Card(
              // check if the index is equal to the selected Card integer
              //color: selectedCard == index ? Colors.blue : Colors.amber,
              child: Container(
                width: SizeConfig.screenWidth*0.9,
                height: SizeConfig.screenHeight*0.9,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.05, 0.1, 0.5, 0.9],
                        colors: selectedCard == index ? backgroundColorDark : actionContainerColorBlue
                    )
                ),
                child: Text(
                  '${widget.list![index]}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        });
  }
}