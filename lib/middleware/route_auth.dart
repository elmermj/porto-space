import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:porto_space/misc/app_pages.dart';
import 'package:porto_space/store/userstore.dart';

/// 检查是否登录
class RouteAuthMiddleware extends GetMiddleware {
  // priority 数字小优先级高
  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (UserStore.to.isLogin || route == AppRoutes.ENTRANCE || route == AppRoutes.INITIAL) {
      return null;
    } else {
      Future.delayed(
          const Duration(seconds: 1), () => Get.snackbar("Processing", "Logging In"));
      return const RouteSettings(name: AppRoutes.ENTRANCE);
    }
  }
}
