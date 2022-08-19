import 'package:concessionaire_auto/screens/home/components/body.dart';
import 'package:concessionaire_auto/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../components/custom_bottom_nav_bar.dart';
import '../../utils/enums.dart';



class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);


  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
      //bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.acceuil,),
    );
  }
}
