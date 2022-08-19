import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/sign_in/sign_in_screen.dart';
import '../utils/constants.dart';
import '../utils/size_config.dart';


class GoToSignInPage extends StatelessWidget {
  const GoToSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight*0.8995,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/forget_password.png",
            fit: BoxFit.contain,
            height: SizeConfig.screenHeight*0.4,
            width: SizeConfig.screenWidth*0.8,
          ),
          //Image.asset("assets/images/forget_password.png"),
          SizedBox(height: getProportionateScreenHeight(20),),
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => true);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 5, right: 5),
              child: Container(
                width: SizeConfig.screenWidth * 0.95,
                height: SizeConfig.screenHeight * 0.1,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: borderContainer!.withOpacity(0.6),
                        spreadRadius: 3,
                        blurRadius: 9,
                        offset: const Offset(5, 8), // changes position of shadow
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        //topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                        bottomRight: Radius.circular(35)
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.05, 0.1, 0.35, 0.8],
                        colors: actionContainerColorBlue)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Connecter à votre compte ! ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: getProportionateScreenWidth(20),),
                      Icon(
                        Icons.login,
                        color: Colors.white,
                        size: getProportionateScreenWidth(30),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
