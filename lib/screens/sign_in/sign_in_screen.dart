import 'package:concessionaire_auto/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/size_config.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);

    return Scaffold(
      /*
      appBar: AppBar(

        title: Text("Sign In"),
      ),
       */
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return const HomeScreen();
          } else {
            return Body();
          }
        },
      ),
    );
  }
}
