import 'package:concessionaire_auto/screens/management_data/management_data_screen.dart';
import 'package:concessionaire_auto/screens/profile/profile_screen.dart';
import 'package:concessionaire_auto/screens/search_car/search_car_screen.dart';
import 'package:flutter/widgets.dart';

import '../screens/appointment_place/appointment_place_screen.dart';
import '../screens/complete_profile/complete_profile_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/otp/otp_screen.dart';
import '../screens/sign_in/sign_in_screen.dart';
import '../screens/sign_up/sign_up_screen.dart';




final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  SearchCarScreen.routeName: (context) => SearchCarScreen(),
  AppointmentPlaceScreen.routeName: (context) => AppointmentPlaceScreen(),
  ManagementDataScreen.routeName: (context) => const ManagementDataScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
};