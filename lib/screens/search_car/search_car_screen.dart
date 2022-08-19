import 'package:concessionaire_auto/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../components/custom_bottom_nav_bar.dart';
import '../../utils/enums.dart';
import 'components/body.dart';


class SearchCarScreen extends StatelessWidget {
  static String routeName = "/search_car";
  bool? search;

  SearchCarScreen({this.search, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SearchCarBody(search: search,),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.ajouter),
    );
  }
}
