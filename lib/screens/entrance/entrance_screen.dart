import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/misc_index.dart';
import 'package:porto_space/screens/entrance/entrance_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' as rive;



class EntranceScreen extends GetView<EntranceController> {
  final _loginFormKey = GlobalKey<FormState>();  
  final _signupFormKey = GlobalKey<FormState>();
  late String _email, _password, _firstName, _lastName;
  final String title = "Entrance";
  final String appTitle = "Porto Space";

  @override
  final EntranceController controller = Get.put(EntranceController());

  EntranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var maxMobileWidth = 800;

    

    void showSignupForm() async {
      if (kDebugMode) {
        print("show before ${controller.appBar.toString()}");
      }
      controller.showAppBar();
      if (kDebugMode) {
        print("show after ${controller.appBar.toString()}");
      }
      showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
        ),
        context: context, 
        builder: (context){
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: _loginFormKey,
              child: Wrap(
                children: [
                  Center(
                    child: Text(
                      "Create new $appTitle account", 
                      style: const TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 16,
                        // color: Constants().mainTextColor
                      ),
                    ),
                  ),
                  Components().customTextFormField(
                    labelText: "Email", 
                    validator: (input) => input!.contains('@')? 'Please enter a valid email address': null,
                    onSaved: (input) => _email = input!,
                    left: 16, top: 4, right: 16, bottom: 2,
                  ),
                  Components().customTextFormField(
                    labelText: "First Name", 
                    validator: (input) => input!.isEmpty? 'Please enter your first name': null,
                    onSaved: (input) => _firstName = input!,
                    left: 16, top: 4, right: 16, bottom: 2,
                  ),
                  Components().customTextFormField(
                    labelText: "Last Name", 
                    validator: (input) => input!.isEmpty? 'Please enter your last name': null,
                    onSaved: (input) => _lastName = input!,
                    left: 16, top: 4, right: 16, bottom: 2,
                  ),
                  Components().customTextFormField(
                    labelText: "Password", 
                    validator: (input) => input!.length < 6? 'Password must be at least 6 characters': null,
                    onSaved: (input) => _password = input!,
                    obscureText: true,
                    left: 16, top: 4, right: 16, bottom: 2,
                  ),
                  Components().customTextFormField(
                    labelText: "Confirm Password", 
                    validator: (input) => input! ==_password? 'Passwords are not matched': null,
                    obscureText: true,
                    left: 16, top: 4, right: 16, bottom: 2,
                  ),
                  MaterialButton(
                    padding: const EdgeInsets.fromLTRB(16,4,16,16),
                    height: 24,
                    onPressed: signUp,
                    child: const Center(child: Text('Sign Up')),
                  ),
                ],
              ),
            ),
          );
        }
      ).whenComplete(() 
      {
        if (kDebugMode) {
          print("show before ${controller.appBar}");
        }
        controller.hideAppBar();
        if (kDebugMode) {
          print("show after ${controller.appBar}");
        }
      });
    }

    void showLoginForm()async{
      if (kDebugMode) {
        print("show before ${controller.appBar.toString()}");
      }
      controller.showAppBar();
      if (kDebugMode) {
        print("show after ${controller.appBar.toString()}");
      }
      showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
        ),
        context: context, 
        builder: (context){
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: _loginFormKey,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,16,8,16),
                    child: Center(
                      child: Text(
                        "Login to $appTitle", 
                        style: const TextStyle(
                          fontWeight: FontWeight.w600, 
                          fontSize: 16,
                          // color: Constants().mainTextColor
                        ),
                      ),
                    ),
                  ),
                  Components().customTextFormField(
                    labelText: "Email", 
                    validator: (input) => input!.contains('@')? 'Please enter a valid email address': null,
                    onSaved: (input) => _email = input!,
                    left: 16, top: 4, right: 16, bottom: 2,
                  ),
                  Components().customTextFormField(
                    labelText: "Password", 
                    validator: (input) => input!.length < 6? 'Password must be at least 6 characters': null,
                    onSaved: (input) => _password = input!,
                    obscureText: true,
                    left: 16, top: 4, right: 16, bottom: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8,4,8,16),
                    child: MaterialButton(
                      height: 24,
                      onPressed: login,
                      child: const Center(child: Text('Login')),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ).whenComplete(() 
        {
          if (kDebugMode) {
            print("show before ${controller.appBar.toString()}");
          }
          controller.hideAppBar();
          if (kDebugMode) {
            print("show after ${controller.appBar.toString()}");
          }
        }
      );
    }

    return LayoutBuilder(
      builder:(context, constraints) {
        return constraints.maxWidth>maxMobileWidth?
        Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(title: const Text('Desktop')),
          body: SafeArea(
            minimum: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    color: const Color.fromARGB(255, 136, 136, 136),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(top: height*0.2, left: 16, right: 16),
                          // width: width*0.9,
                          child: Form(
                            key: _loginFormKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8,0,8,16),
                                  child: Center(child: Text("Login to $appTitle", style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (input) => input!.contains('@')
                                        ? 'Please enter a valid email address'
                                        : null,
                                    onSaved: (input) => _email = input!,
                                    decoration: const InputDecoration(
                                      labelText: 'Email', 
                                      border: InputBorder.none,
                                      fillColor: Colors.white
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (input) => input!.length < 6
                                        ? 'Password must be at least 6 characters'
                                        : null,
                                    onSaved: (input) => _password = input!,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      border: InputBorder.none,
                                      fillColor: Colors.white,
                                    ),
                                    obscureText: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8,16,8,8),
                                  child: MaterialButton(
                                    height: 40,
                                    onPressed: login,
                                    child: const Center(child: Text('Login')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: width*0.6,
                          constraints: BoxConstraints.tight(const Size.fromWidth(200)),
                          child: MaterialButton(
                            onPressed: login,
                            height: height*0.1,
                            child: Row(
                              children: const [
                                Expanded(
                                  flex: 3,
                                  child: Text("Login with Google", textAlign: TextAlign.center,),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Image(image: AssetImage("assets/icons/google_g_icon.png"))
                                  // Image.asset("assets/icons/google_g_icon.png", fit: BoxFit.contain,)
                                  // SvgPicture.asset(
                                  //   'assets/icons/google_g_icon.svg',
                                  //   fit: BoxFit.contain,
                                  // )
                                )
                              ],
                            )
                          ),
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: height *0.1,
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(text: "Don't have an account? "),
                                  TextSpan(text: "Sign up here",
                                    style: const TextStyle(color: Color.fromARGB(255, 60, 167, 255)),
                                    recognizer: TapGestureRecognizer()
                                    ..onTap = showSignupForm
                                  )
                                ]
                              )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        :
        GetBuilder<EntranceController>(
          builder: (controller) {
            return Scaffold(
              appBar: controller.appBar==true?
                AppBar(title: const Text("Porto|Space",
                  style: TextStyle(
                    fontFamily: "Unbounded",
                    fontSize: 24
                  ),
                ),):null,
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 251, 255, 255),
                      lightColorScheme.secondaryContainer
                    ],
                    begin: const FractionalOffset(0, 0),
                    end: const FractionalOffset(0, 1.0),
                    stops: const [0.5, 1.0],
                    tileMode: TileMode.clamp),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: controller.appBar==true?const Text(" "): Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: rive.RiveAnimation.asset(
                                'assets/animation/tristructure.riv',
                              ),
                            ),
                            Text(" Porto|Space",
                              style: TextStyle(
                                fontFamily: "Unbounded",
                                fontSize: 24
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:Obx(()=>MaterialButton(
                        onPressed: controller.signInWithGoogle,
                        child: controller.isLoading.value?
                        const SizedBox(
                          height: 48,
                          child: rive.RiveAnimation.asset(
                            'assets/animation/tristructure.riv',
                          ),
                        ):
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Login via Google  ", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
                            Image(image: AssetImage("assets/icons/google_g_icon.png"), height: 24, fit: BoxFit.contain,),
                          ],
                        )
                      )),
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    );  
  }

  // void googleLogin(){
  //   if (_loginFormKey.currentState!.validate()) {
  //     _loginFormKey.currentState!.save();
  //     FirebaseAuth.instance.signInWithCredential(
  //       AuthCredential(providerId: providerId, signInMethod: signInMethod)
  //     ) signInWithEmailAndPassword(
  //       email: _email, password: _password
  //     );
  //   }
  // }

  void login(){
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email, password: _password
      );
    }
  }

  void signUp() {
    if (_signupFormKey.currentState!.validate()) {
      _signupFormKey.currentState!.save();
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email, password: _password
      );
    }
  }
}  



