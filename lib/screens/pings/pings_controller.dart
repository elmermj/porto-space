import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PingsController extends GetxController{
  RxBool activePing = false.obs;

  setPing(){
    if(activePing.value){
      activePing = false.obs;
      update();
      debugPrint(activePing.toString());
    }else{
      activePing = true.obs;
      update();
      debugPrint(activePing.toString());
    }
  }
}