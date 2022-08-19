import 'package:concessionaire_auto/screens/management_data/management_data_screen.dart';
import 'package:concessionaire_auto/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/home/home_screen.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../screens/search_car/search_car_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  final MenuState selectedMenu;
  //Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    //required this.onTap,
    required this.selectedMenu,
  }) : super(key: key);


  @override
  _CustomBottomNavBar createState() => _CustomBottomNavBar();
}

class _CustomBottomNavBar extends State<CustomBottomNavBar>{

  @override
  Widget build(BuildContext context) {
    //const Color inActiveIconColor = const Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.home,

                  color: MenuState.acceuil == widget.selectedMenu
                      ? kPrimaryColor
                      : Colors.blueGrey,
                ),
                onPressed: () => MenuState.acceuil == widget.selectedMenu
                    ? {}
                    : Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (BuildContext context) => const HomeScreen(),),),

                    //Navigator.pushNamed(context, HomeScreen.routeName),

              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.plusCircle,
                  color: MenuState.ajouter == widget.selectedMenu
                      ? kPrimaryColor
                      : Colors.blueGrey,
                ),
                  onPressed: () => MenuState.ajouter == widget.selectedMenu
                      ? {}
                      : Navigator.pushReplacement(context, MaterialPageRoute<void>(
                    builder: (BuildContext context) => SearchCarScreen(),
                  ),)
                //onPressed: () => Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
              IconButton(
                  icon: Icon(
                    FontAwesomeIcons.calendarCheck,
                    color: MenuState.calendrier == widget.selectedMenu
                        ? kPrimaryColor
                        : Colors.blueGrey,
                  ),
                  onPressed: () => MenuState.calendrier == widget.selectedMenu
                      ? {}
                      : Navigator.pushReplacement(context, MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ManagementDataScreen(),
                  ),)
                //Navigator.pushNamed(context, SearchCarScreen.routeName),

              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.user,
                  color: MenuState.profile == widget.selectedMenu
                      ? kPrimaryColor
                      : Colors.blueGrey,
                ),
                //onPressed: () {  },
                onPressed: () => MenuState.profile == widget.selectedMenu
                    ? {}
                    :
                Navigator.pushReplacement(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ProfileScreen(),
                ),)
                    //Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
            ],
          )),
    );
  }
}
