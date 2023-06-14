import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:porto_space/misc/app_pages.dart';
import 'package:porto_space/store/store.dart';

class RouteWelcomeMiddleware extends GetMiddleware{
  int? priority = 0;

  @override
  RouteWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route){
    debugPrint(ConfigStore.to.isFirstOpen.toString());

    if(ConfigStore.to.isFirstOpen==false){
      return null;
    }else if (UserStore.to.isLogin == true){
      return const RouteSettings(name: AppRoutes.HOME);
    }else{
      return const RouteSettings(name: AppRoutes.ENTRANCE);
    }
  }
}