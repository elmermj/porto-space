import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:porto_space/misc/app_pages.dart';
import 'package:porto_space/store/store.dart';

class RouteWelcomeMiddleware extends GetMiddleware{
  @override
  int? priority = 0;

  RouteWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route){
    print(ConfigStore.to.isFirstOpen);

    if(ConfigStore.to.isFirstOpen==false){
      return null;
    }else if (UserStore.to.isLogin == true){
      return const RouteSettings(name: AppRoutes.HOME);
    }else{
      return const RouteSettings(name: AppRoutes.ENTRANCE);
    }
  }
}