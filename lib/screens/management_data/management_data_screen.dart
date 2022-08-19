import 'package:concessionaire_auto/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../components/custom_bottom_nav_bar.dart';
import '../../utils/enums.dart';
import 'components/body.dart';


class ManagementDataScreen extends StatelessWidget {
  static String routeName = "/management_data";

  const ManagementDataScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: ManagementBody(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.calendrier),
    );
  }
}
