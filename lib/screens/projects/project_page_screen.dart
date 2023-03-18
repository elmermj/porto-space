import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/misc_index.dart';
import 'package:porto_space/models/project_item.dart';
import 'package:porto_space/screens/projects/projects_controller.dart';

class ProjectPageScreen extends GetView<ProjectsController>{
  final ProjectItem projectData;
  final String projectId;
  
  @override
  final ProjectsController controller = Get.put(ProjectsController());

  ProjectPageScreen({required this.projectData, required this.projectId, super.key,});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    qrCodeModal(){
      showCupertinoDialog(
        barrierDismissible: true,
        context: context, 
        builder: (context){
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Material( 
                  type: MaterialType.card,                 
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width-(kToolbarHeight/2),
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
                  )
                )
              )
            )
          );
        }
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.portoWhite,
        leading: IconButton(
          onPressed: ()=>Get.back(), 
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: lightColorScheme.onSurfaceVariant,)),
        title: const Text('Project'),
        actions: [
          IconButton(
            onPressed: () =>controller.tweenAnimate(),
            icon: Icon(Icons.more_vert_rounded, color: lightColorScheme.onSurfaceVariant,)
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: Constants.linearGradientBackground
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: kBottomNavigationBarHeight+Constants.textXL,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 12,height: 8,),
                        Expanded(child: Container(height: 0.5,color: lightColorScheme.onSurfaceVariant)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text("Invite", style: TextStyle(fontSize: Constants.textM),)),
                        Expanded(child: Container(height: 0.5,color: lightColorScheme.onSurfaceVariant)),
                        const SizedBox(width: 12,height: 8,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: ()=>qrCodeModal(), 
                            icon: Column(
                              children: [
                                const Icon(Icons.qr_code_outlined),
                                Text("QR", style: TextStyle(fontSize: Constants.textS),)
                              ],
                            )
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: (){}, 
                            icon: Column(
                              children: [
                                Icon(Icons.person, color: lightColorScheme.onSurfaceVariant),
                                Text("PortoSpace", style: TextStyle(fontSize: Constants.textS))
                              ],
                            )
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: (){}, 
                            icon: Column(
                              children: [
                                Icon(Icons.link, color: lightColorScheme.onSurfaceVariant,),
                                Text("Link", style: TextStyle(fontSize: Constants.textS))
                              ],
                            )
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Obx(()=> 
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: controller.slideValue.value), 
                duration: const Duration(milliseconds: 200), 
                builder: (context , val, widget){
                  return Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.translationValues(val*width, 0, 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: height*0.7,
                            maxWidth: width*0.25
                          ),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const SizedBox(height: 16,),
                            itemCount: controller.projectMemberList.length,
                            itemBuilder: (context, index){
                              return Components().profileIcon50(
                                condition: controller.projectMemberList[index].memberId!=controller.user.uid,
                                name: controller.projectMemberList[index].memberName
                              );
                            }
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),

            GestureDetector(
              onHorizontalDragStart:(p0) => controller.tweenAnimate(), 
              child: Obx(()=> Components.tweenAnimatedBody(
                screenWidth: width, 
                offsetTweenValue: controller.tweenEndValue.value, 
                scaleTweenValue: controller.scaleValue.value, 
                matrixTweenValue: controller.scaleRValue.value, 
                body: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)
                  ),
                  child: Container(
                    height: double.infinity,
                    decoration: Constants.linearGradientBackground,
                    child: ListView(
                      shrinkWrap: true,
                      children: const [
                        Center(
                          child: Text("Project Name"),
                        )
                    ],)
                  ),
                )
              ),),
            )
          ],
        ),
      ),
    );

    
  }
  
}