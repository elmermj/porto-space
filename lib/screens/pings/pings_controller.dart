import 'package:get/get.dart';

class PingsController extends GetxController{
  RxBool activePing = false.obs;

  setPing(){
    if(activePing.value){
      activePing = false.obs;
      update();
      print(activePing);
    }else{
      activePing = true.obs;
      update();
      print(activePing);
    }
  }
}