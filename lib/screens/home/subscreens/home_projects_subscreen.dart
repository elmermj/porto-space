import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porto_space/components/components_index.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/components.dart';
import 'package:porto_space/misc/constants.dart';
import 'package:porto_space/screens/home/home_controller.dart';

class ProjectsSubScreen extends GetView<HomeController>{
  final projectKey = GlobalKey<FormState>();

  @override
  final HomeController controller = Get.put(HomeController());

  ProjectsSubScreen({super.key});


  showProjects({
    required BuildContext context,
    required double height,
    required double width
  }){
    showCupertinoDialog(
      barrierDismissible: true,
      context: context, 
      builder: (context)=>BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Material(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                width: width-(kToolbarHeight/2),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height-(kToolbarHeight*2),
                ),
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
                child: Form(
                  key: controller.projectKey,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      Components().cEduDialogTitle(title: "Enter Your Project"),
                      ProfileIcon50(name: controller.name),
                      CTextFormField1(
                        hintText: "Project name",
                        labelText: "Project Name",
                        onSaved: (input)=> controller.projectName = input!,
                      ),
                      CTextFormField2(
                        hintText: "Brief description about your project",
                        labelText: "Project Description",
                        onSaved: (input)=> controller.projectDescription = input!,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'As Project Author', style: TextStyle(fontSize: Constants.textSL),
                          ),
                          Obx(()=>Checkbox(
                            value: controller.isAuthor.value, 
                            onChanged: (value){
                              controller.isAuthor.value = value!;
                              controller.toggleAuthor(isAuthor: controller.isAuthor.value);
                            }
                          ),)
                        ],
                      ),
                      Obx(() => 
                        controller.isAuthor.value?
                        const SizedBox():
                        Column(
                          children: [
                            CTextFormField1(
                              hintText: "Project's author's name",
                              labelText: "Project's Author",
                              initialValue: controller.projectAuthor,
                              onSaved: (input)=> controller.projectAuthor = input!,
                            ),
                            CTextFormField1(
                              hintText: "Your role in this project",
                              labelText: "Your Project Role",
                              initialValue: controller.projectRole,
                              onSaved: (input)=> controller.projectRole = input!,
                            ),
                          ],
                        )
                      ),
                      CTextFormField1(
                        hintText: "Number of project members",
                        labelText: "Member Count",
                        keyboardType: TextInputType.number,
                        onSaved: (input)=> controller.memberCount = input!,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,2,8,2),
                        child: Row(children: [
                          Expanded(flex: 7,
                            child: TextField(
                              decoration: InputDecoration(                                  
                                hintStyle: TextStyle(
                                  fontSize: Constants.textM
                                ),
                                labelStyle: TextStyle(
                                  fontSize: Constants.textM
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(12,1,12,1),
                                hintText: 'For example: Marketing, Business Development, Engineering, etc',
                                filled: true,
                                labelText: 'Project Keywords',
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(6)),                      
                                ),
                                fillColor: lightColorScheme.onPrimary
                              ),
                              style: TextStyle(
                                fontSize: Constants.textM
                              ),
                              textInputAction: TextInputAction.go,
                              onSubmitted: (string)=>controller.addProjectKeyword(
                                keywords: string
                              ),
                              controller: controller.addMemberEditText,
                            )
                          ),
                          Expanded(flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: ()=>controller.addProjectKeyword(
                                keywords: controller.addMemberEditText.text
                              ),
                            )
                          )
                        ],),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Project Status : ', style: TextStyle(fontSize: Constants.textM),),
                            Obx(()=> Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: controller.color.value,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  controller.projectStatus, 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Constants.textM, fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: SingleChildScrollView(
                          clipBehavior: Clip.antiAlias,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Obx(
                            ()=> Row(
                              children: [
                                SearchBarTextButton(
                                  buttonName: 'Initial',
                                  color: controller.selectedProjectStage.value == ProjectStages.initial
                                          ? lightColorScheme.primary
                                          : lightColorScheme.secondary,
                                  onPressed: () => controller.setProjectButton(ProjectStages.initial),
                                ),
                                SearchBarTextButton(
                                  buttonName: 'In Progress',
                                  color: controller.selectedProjectStage.value == ProjectStages.inProgress
                                          ? lightColorScheme.primary
                                          : lightColorScheme.secondary,
                                  onPressed: ()=>controller.setProjectButton(ProjectStages.inProgress),
                                ),
                                SearchBarTextButton(
                                  buttonName: 'On Pause',
                                  color: controller.selectedProjectStage.value == ProjectStages.onPause
                                          ? lightColorScheme.primary
                                          : lightColorScheme.secondary,
                                  onPressed: ()=>controller.setProjectButton(ProjectStages.onPause),
                                ),
                                SearchBarTextButton(
                                  buttonName: 'Completed',
                                  color: controller.selectedProjectStage.value == ProjectStages.completed
                                          ? lightColorScheme.primary
                                          : lightColorScheme.secondary,
                                  onPressed: ()=>controller.setProjectButton(ProjectStages.completed),
                                ),
                                SearchBarTextButton(
                                  buttonName: 'Cancelled',
                                  color: controller.selectedProjectStage.value == ProjectStages.cancelled
                                          ? lightColorScheme.primary
                                          : lightColorScheme.secondary,
                                  onPressed: ()=>controller.setProjectButton(ProjectStages.cancelled),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: Constants.standardInset,
                        child: Text('Project Keywords:',style: TextStyle(fontSize: Constants.textS),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Obx(() => 
                          SizedBox(
                            height: 30,
                            child: ListView.builder(
                              itemCount: controller.projectKeywords.length,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index){
                                var keyword = controller.projectKeywords[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        keyword+' ', style: TextStyle(fontSize: Constants.textS),
                                      ),
                                      GestureDetector(
                                        onTap: ()=>controller.removeProjectKeyword(index: index),
                                        child: const Icon(Icons.close, size: 15,),
                                      )
                                    ],
                                  ),
                                );
                              }
                            ),
                          )
                        ),
                      ),
                      MaterialButton(
                        onPressed: (){

                          controller.createProjectItem();
                          Get.back();
                          
                        },
                        child: const Text('Create Project'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final controller = Get.find<HomeController>(); 
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: kTextTabBarHeight,
              // color: Colors.red,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Projects", style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Constants.textL
                      ),),
                      IconButton(
                        onPressed: ()=>showProjects(context: context, height: height, width: width), 
                        icon: const Icon(Icons.add, size: 18,)
                      ),
                    ],
                  ),
                ]
              ),
            ),
            controller.projectList.isEmpty?
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text(controller.projectEmptyWarning)),
            )
            :
            Obx(()=>
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.projectListItems.length,
                itemBuilder: (context, index){

                  var item =controller.projectListItems[index];
                  String day = item.timeCreated!.toDate().toUtc().day.toString();
                  int monthIndex = item.timeCreated!.toDate().toUtc().month;
                  String year = item.timeCreated!.toDate().toUtc().year.toString();

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: lightColorScheme.primary
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(15))
                        ),
                        child: ExpansionTile(
                          clipBehavior: Clip.antiAlias,
                          trailing: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(style: BorderStyle.none),
                                color: Constants().determineColor(projectStatus: item.projectStatus!),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                item.projectStatus!, 
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Constants.textS, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide.none,
                          ),
                          collapsedShape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide.none,
                          ),
                          title: Text(
                            item.projectName!,
                            style: TextStyle(
                              fontSize: Constants.textSL, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          children: [
                            Padding(
                              padding: Constants.standardInset,
                              child: ProfileIcon50(name: "${controller.name!} as Project Author")
                            ),
                            Container(
                              width: double.infinity,
                              padding: Constants.startParagraphInset,
                              child: Text('Description', 
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: Constants.textM,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: Constants.standardInset,
                              child: Text(item.projectDescription!, 
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: Constants.textM,
                                ),
                              ),
                            ),
                            Padding(
                              padding: Constants.standardInset,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text('Date Created', 
                                      style: TextStyle(
                                        fontSize: Constants.textM,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text("$day ${months[monthIndex-1]} $year", 
                                      style: TextStyle(
                                        fontSize: Constants.textM,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: Constants.standardInset,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Member Count', 
                                    style: TextStyle(
                                      fontSize: Constants.textM,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(item.memberCount.toString(), 
                                    style: TextStyle(
                                      fontSize: Constants.textM,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: Constants.standardInset,
                              child: Wrap(
                                spacing: 5,
                                children: [
                                  for(String keyword in item.projectKeywords!)
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      '$keyword ', style: TextStyle(fontSize: Constants.textS),
                                    ),
                                  )
                                  
                              ],)
                            ),
                            MaterialButton(
                              onPressed: ()=>controller.openProjectPage(
                                projectData: item,
                                projectId: item.projectId!
                              ),
                              child: Padding(
                                padding: Constants.standardInset,
                                child: Text('Open Project Space', 
                                  style: TextStyle(
                                    fontSize: Constants.textM,
                                    fontWeight: FontWeight.bold,
                                    color: lightColorScheme.primary
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
            const SizedBox(height: kBottomNavigationBarHeight+(kBottomNavigationBarHeight*0.15),width: double.infinity,)
          ],
        ),
      ),
    );
  }
}
