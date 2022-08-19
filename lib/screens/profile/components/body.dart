import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/components/go_to_sign_in_page.dart';
import 'package:concessionaire_auto/models/user_model.dart';
import 'package:concessionaire_auto/screens/profile/components/header.dart';
import 'package:concessionaire_auto/utils/constants.dart';
import 'package:concessionaire_auto/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/action_list_row.dart';
import '../../management_data/management_data_screen.dart';
import '../../search_car/search_car_screen.dart';
import '../../sign_in/sign_in_screen.dart';


class Body extends StatefulWidget {

  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final user = FirebaseAuth.instance.currentUser;
  String name="";
  UserModel userModel = UserModel();
  bool _isLoggedIn = false;

  late List<Color> _backgroundColor;
  final Color? _iconColor = Colors.white;
  final Color? _textColor = const Color.fromRGBO(253, 211, 4, 1);
  Color? _textColor2 = const Color.fromRGBO(47, 75, 110, 1);

  final Color? _borderContainer = const Color.fromRGBO(63, 124, 190, 1.0);
  bool colorSwitched = false;
  var logoImage;


  void getUserData() async {
    if(user!.uid.isNotEmpty) {
      _isLoggedIn = true;
      FirebaseFirestore.instance.collection("user").doc(user!.uid).get().then((value) {
        if (value.data()!.containsKey("name")) {
          setState(() {
            //name = value["name"];
            // writting all the values
            userModel.id = user!.uid;
            userModel.name = value['name'];
            userModel.email = value['email'];
            userModel.password = value['password'];
            userModel.phone = value['phone'];
          });
          print("name ${value["name"]}");
          print("user model $userModel");
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

    return (_isLoggedIn)
      ?
      SafeArea(
      child: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.3, 0.5, 0.8],
                colors: _backgroundColor)),
        child: Stack(
          //mainAxisSize: MainAxisSize.max,
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Positioned(
                top: getProportionateScreenHeight(160),
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight*0.7,
                  decoration: BoxDecoration(
                      color: _borderContainer,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(35)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.05, 0.1, 0.35, 0.8],
                          colors: actionContainerColorBlue)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const Divider(height: 0.5, color: Colors.transparent,),

                      ActionList(iconPath: 'assets/images/ic_add_appointment.png', desc: 'Nouveau rendez-vous', iconColor: _iconColor,
                        press: () => Navigator.pushReplacementNamed(context, SearchCarScreen.routeName),),

                      const Divider(height: 0.5, color: Colors.grey,),

                      ActionList(iconPath: 'assets/images/ic_help.png', desc: 'Contacter l\'administration', iconColor: _iconColor,
                        press: () => {}),

                      const Divider(height: 0.5, color: Colors.grey,),

                      ActionList(iconPath: 'assets/images/ic_user.png', desc: 'Modifier mes coordonnées', iconColor: _iconColor,
                          press: () {}),

                      const Divider(height: 0.5, color: Colors.grey,),

                      ActionList(iconPath: 'assets/images/logout.png', desc: "Se déconnecter", iconColor: _iconColor,
                          press: () {
                            FirebaseAuth.instance.signOut();
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                            Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => true);
                          }
                      ),
                    ],
                  ),
                ),
            ),
            Positioned(
              bottom: 500, right: 50, top: 0, left: 0,
              child: GestureDetector(
                  onLongPress: () {
                    if (colorSwitched) {
                      colorSwitched = false;
                    } else {
                      colorSwitched = true;
                    }
                    changeTheme();
                  },
                  child: Header(userModel: userModel, borderContainer: _textColor2),
              ),
            ),
          ],
        ),
      ),

    )
        :
      const GoToSignInPage();
  }

}