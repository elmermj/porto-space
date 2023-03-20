import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/constants.dart';
import 'package:porto_space/screens/pings/pings_index.dart';
import 'package:rive/rive.dart' as rive;

class PingsScreen extends GetView<PingsController> {
  PingsScreen({super.key});

  @override
  final PingsController controller = Get.put(PingsController());


  _switch(BuildContext context){
     Obx(()=> CupertinoSwitch(
      value: controller.activePing.value, 
      onChanged: (value){
        if(controller.activePing.value){
          controller.activePing.toggle();
          print(controller.activePing);
        }else{
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (context){
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Material(
                      type: MaterialType.card,
                      borderOnForeground: false,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        width: MediaQuery.of(context).size.width-(kToolbarHeight*1.5),
                        child: ListView(
                          padding: Constants.standardInset,
                          shrinkWrap: true,
                          children: [
                            Text("Confirm Active Location Ping?", style: TextStyle(fontSize: Constants.textSL), textAlign: TextAlign.center,),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                              TextButton(child: Text("No", style: TextStyle(fontSize: Constants.textM), textAlign: TextAlign.center,), onPressed: (){Get.back();},),
                              TextButton(onPressed: (){
                                controller.activePing.toggle();
                                print(controller.activePing);
                                Get.back();
                              }, child: Text("Yes", style: TextStyle(fontSize: Constants.textM), textAlign: TextAlign.center,))
                            ],)
                          ]
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          );
        }
      }
    ),);
  }

  _buildAppBar(BuildContext context){
    return Container(
      height: kToolbarHeight,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: ()=> Get.back(),
              icon: const Icon(LucideIcons.chevronLeft),
            ),
          ),
          const Expanded(
            flex: 3,
            child: Text(
              "Ping Nearby",
              style: TextStyle(
                fontFamily: "Unbounded",
                fontSize: 24
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox()
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
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
              )
            ),
            _buildAppBar(context),
            Container(
              padding: Constants.standardInset,
              margin: const EdgeInsets.only(top: kToolbarHeight),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: kToolbarHeight*3,
                      padding: Constants.standardInset,
                      child: const rive.RiveAnimation.asset('assets/animation/location_icon.riv', fit: BoxFit.fitHeight,),
                    ),
                    Container(
                      padding: Constants.standardInset,
                      child: Text(
                        "Other users will notice your presence once they ping and you're in their search radius.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: Constants.textM),
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Name', textAlign: TextAlign.start, style: TextStyle(fontSize: Constants.textM),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Distance', textAlign: TextAlign.center, style: TextStyle(fontSize: Constants.textM),
                        ),
                      )
                    ],)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(kToolbarHeight),
        child: Obx(()=>
          controller.activePing.value? Container(
            height: kToolbarHeight,
            width: kToolbarHeight,
            color: Colors.transparent,
            child: const rive.RiveAnimation.asset(
              'assets/animation/pulse.riv',
            ),
          ):GestureDetector(
            onTap: () {controller.activePing.toggle(); pingSound(); timerActive(); }, 
            child: Container(
              height: kToolbarHeight,
              color: Colors.transparent,
              child: const Center(
                child: Text(
                  '   Ping   ', textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        )
      )
    );
  }

  timerActive(){
    return Timer(
      const Duration(seconds: 5), 
      () { controller.activePing.toggle(); }
    );
  }

  pingSound(){
    return const AppleNotificationSound(critical: true);
  }
}