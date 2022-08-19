import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/components/action_list_column.dart';
import 'package:concessionaire_auto/screens/profile/profile_screen.dart';
import 'package:concessionaire_auto/utils/constants.dart';
import 'package:concessionaire_auto/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../management_data/management_data_screen.dart';
import '../../search_car/search_car_screen.dart';
import '../../sign_in/sign_in_screen.dart';


class Body extends StatefulWidget {

  Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final user = FirebaseAuth.instance.currentUser;
  String name = "";
  String phone = "";
  String connectText = "Se connecter";
  late List<Color> _backgroundColor;
  final Color? _iconColor = Colors.white;
  final Color? _textColor = const Color.fromRGBO(253, 211, 4, 1);

  final List<Color> _actionContainerColor = actionContainerColorBlue;
  Color? _borderContainer = const Color.fromRGBO(63, 124, 190, 1.0);
  bool colorSwitched = false;
  var logoImage;


  void getUserData() async {
    String userId = user?.uid??"";

    if(userId.isNotEmpty) {
      connectText = "Se déconnecter";
      FirebaseFirestore.instance.collection("user").doc(user!.uid).get().then((value) {
        if (value.data()!.containsKey("name")) {
          setState(() {
            name = value["name"];
          });
        }
        if (value.data()!.containsKey("phone") && value["phone"]!=null) {
          setState(() {
            phone = "+216 ${value["phone"]}";
          });
        }
      });
    }
  }


  void changeTheme() async {
    if (colorSwitched) {
      setState(() {
        logoImage = 'assets/images/ennakl_logo.png';
        _backgroundColor = backgroundColorDark;
      });
    } else {
      setState(() {
        logoImage = 'assets/images/ennakl_logo.png';
        _backgroundColor = backgroundColorLight;
      });
    }
  }


  @override
  void initState() {
    changeTheme();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.3, 0.5, 0.8],
                colors: _backgroundColor)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            /*Image.asset(
                logoImage,
                fit: BoxFit.contain,
                height: SizeConfig.screenHeight*0.2,
                width: SizeConfig.screenWidth*0.6,
              ),*/
            Image.asset(
              "assets/images/ennakl_logo.png",
              fit: BoxFit.contain,
              height: SizeConfig.screenHeight*0.4,
              width: SizeConfig.screenWidth*0.8,
            ),
            Container(
              height: SizeConfig.screenHeight*0.5,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                  color: _borderContainer,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 5, right: 5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.05, 0.1, 0.35, 0.8],
                          colors: _actionContainerColor)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        splashColor: kPrimaryColor,
                        //focusColor: DarkBlueColor,
                        //hoverColor: DarkBlueColor,
                        //highlightColor: borderContainer,
                        onLongPress: () {
                          if (colorSwitched) {
                            colorSwitched = false;
                          } else {
                            colorSwitched = true;
                          }
                          changeTheme();
                        },
                        child: Container(
                          height: getProportionateScreenHeight(80),
                          padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
                          child: Center(
                            child: ListView(
                              children: <Widget>[
                                Text(
                                  name,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: _textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                Text(
                                  phone,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: _iconColor, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Divider(height: 0.5, color: Colors.grey,),

                      Table(
                        border: TableBorder.symmetric(
                          inside: const BorderSide(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 0.5),
                        ),
                        children: [
                          TableRow(children: [
                            ActionList(iconPath: 'assets/images/ic_add_appointment.png', desc: 'Nouveau rendez-vous', iconColor: _iconColor,
                              press: () => Navigator.pushReplacementNamed(context, SearchCarScreen.routeName),
                            ),

                            ActionList(iconPath: 'assets/images/ic_check_appointment.png', desc: 'Consulter les rendez-vous', iconColor: _iconColor,
                              press: () => Navigator.pushReplacementNamed(context, ManagementDataScreen.routeName),),
                          ]),
                          TableRow(children: [
                            ActionList(iconPath: 'assets/images/ic_user.png', desc: 'Profile', iconColor: _iconColor,
                                press: () => Navigator.pushReplacementNamed(context, ProfileScreen.routeName)),

                            ActionList(iconPath: 'assets/images/logout.png', desc: connectText, iconColor: _iconColor,
                                press: () {
                                  FirebaseAuth.instance.signOut();
                                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                                  Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => true);
                                }
                            ),
                          ])
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),

      /*GestureDetector(
        onLongPress: () {
          if (colorSwitched) {
            colorSwitched = false;
          } else {
            colorSwitched = true;
          }
          changeTheme();
        },
        child:
      ),*/
    );
  }

}