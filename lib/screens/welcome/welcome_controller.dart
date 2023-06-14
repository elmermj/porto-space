import 'package:get/get.dart';
import 'package:porto_space/screens/entrance/entrance_index.dart';

class WelcomeController extends GetxController {
    final state = WelcomeState();
    WelcomeController();
    changePage(int index) async {
      state.index.value = index;
    }

    handleSignIn() async {
      // await ConfigStore.to.saveAlreadyOpen();
      Get.off(EntranceScreen());
    }

}

class WelcomeState {
  var index = 0.obs;
}

class WelcomeBinding extends Bindings{
  
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }

}