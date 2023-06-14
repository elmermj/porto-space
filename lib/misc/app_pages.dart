
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porto_space/middleware/route_welcome.dart';
import '../screens/welcome/welcome_index.dart' as welcome;
import '../screens/entrance/entrance_index.dart' as entrance;
import '../screens/profile/profile_index.dart' as profile;
import '../screens/home/home_index.dart' as home;

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const ENTRANCE = AppRoutes.ENTRANCE;
  static const HOME = AppRoutes.HOME;
  static const HOME_SEARCH_RESULT = AppRoutes.HOME_SEARCH_RESULT;
  static const HOME_ABOUT_ME = AppRoutes.HOME_ABOUT_ME;
  static const PROFILE_EDIT = AppRoutes.PROFILE_EDIT;
  static const APPLICATION = AppRoutes.APPLICATION;
  static const PROJECT = AppRoutes.PROJECT;
  static final RouteObserver<Route> observer = RouteObserver();

  static final List<GetPage> routes = [
    GetPage(
      name: INITIAL, 
      page: ()=> welcome.WelcomeScreen(),
      binding: welcome.WelcomeBinding(),
      middlewares: [
        RouteWelcomeMiddleware(priority: 1)
      ]
    ),

    GetPage(
      name: ENTRANCE, 
      page: ()=> entrance.EntranceScreen(),
      binding: entrance.EntranceBinding(),
    ),

    GetPage(
      name: HOME, 
      page: ()=> home.HomeScreen(),
      binding: home.HomeBinding(),
    ),

    GetPage(
      name: HOME_SEARCH_RESULT, 
      page: ()=> const home.HomeSearchResultScreen(),
      binding: home.HomeBinding(),
    ),

    GetPage(
      name: HOME_ABOUT_ME, 
      page: ()=> home.AboutMeSubScreen(),
      binding: home.HomeBinding(),
    ),

    GetPage(
      name: PROFILE_EDIT, 
      page: ()=> profile.ProfileEditScreen(isNew: false,),
      binding: entrance.EntranceBinding(),
    ),

  ];
}

class AppRoutes{
  static const INITIAL = '/';
  static const ENTRANCE = '/entrance';
  static const NOT_FOUND = '/not_found';
  static const APPLICATION = '/application';
  static const HOME = '/home';
  static const HOME_SEARCH_RESULT = '/home_search_result';
  static const HOME_ABOUT_ME = '/home_about_me';
  static const PROFILE_EDIT = '/profile_edit';
  static const PROJECT = '/project';
}