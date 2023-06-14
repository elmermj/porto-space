import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:porto_space/components/components_index.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/components.dart';
import 'package:porto_space/misc/constants.dart';
import 'package:porto_space/screens/home/home_controller.dart';

class AboutMeSubScreen extends GetView<HomeController>{
  final addEducationkey = GlobalKey<FormState>();
  final editEducationkey = GlobalKey<FormState>();
  // final HomeController controller;

  // AboutMeSubScreen(this.controller, {Key? key}) : super(key: key);

@override
  final HomeController controller = Get.put(HomeController());

  AboutMeSubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>(); 
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Brief Description", style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: Constants.textL
                ),),
                IconButton(
                  onPressed: (){controller.activateTextField();}, 
                  icon: const Icon(Icons.edit, size: 18,)
                ),
              ],
            ),
            GestureDetector(
              onDoubleTap: () {
                controller.activateTextField();
              },            
              child: Obx(() => controller.isProfileDescFieldActive.value?
                TextField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  // textfield configuration here
                  onEditingComplete: ()=> controller.saveProfileDesc(),
                  maxLines: null,
                  minLines: null,
                  onSubmitted: (_) => controller.saveProfileDesc(),
                  textCapitalization: TextCapitalization.sentences,
                  controller: controller.textEditProfileDesc,
                  style: TextStyle(
                    fontSize: Constants.textM
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter your profile description', border: InputBorder.none            
                  ),
                  onTapOutside: (event)  {
                    controller.textEditProfileDesc.text = controller.profileDesc!;
                    controller.deactivateTextField();
                  },
                )
                : GestureDetector(
                  onDoubleTap: () => controller.activateTextField(),
                  child: Text(controller.profileDesc!, style: TextStyle(fontSize: Constants.textM),
                  ),
                )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Education History", style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: Constants.textL
                ),),
                IconButton(
                  onPressed: (){
                    showEduDialog(context,
                      title: 'Add',
                      key: addEducationkey,
                      controller: controller,
                      eduLevelOnSaved: (input)=> controller.eduLevel = input,
                      eduInstituteOnSaved: (input)=> controller.eduInstitute = input,
                      fieldOfStudyOnSaved: (input)=> controller.fieldOfStudy = input,
                      eduYearStartOnSaved: (input)=> controller.eduYearStart = input,
                      eduYearStartValidator: (input) {
                        input!.contains(RegExp(r'^\d{4}?$'))?null:'Wrong Year Format';
                        return null;
                      },
                      eduYearEndOnSaved: (input)=> controller.eduYearEnd = input,
                      eduYearEndValidator: (input) {
                        input!.contains(RegExp(r'^\d{4}?$'))?null:'Wrong Year Format';
                        return null;
                      },
                      onGoingChanged:[
                        const Text('Ongoing: '),
                        Obx(()=>Checkbox(
                          value: controller.ongoing.value, 
                          onChanged: (value){
                            controller.ongoing.value = value!;
                            controller.toggleOngoing(ongoing: controller.ongoing.value);
                          }
                        ),)
                      ],
                      onPressed: () {
                        if(addEducationkey.currentState!.validate()){
                          addEducationkey.currentState!.save();
        
                          controller.createEduHistoryItem(DateTime.now().hashCode);
                          
                          Navigator.pop(addEducationkey.currentContext!);
                        }
                      },
                    );
                  }, 
                  icon: const Icon(Icons.add)
                )
              ],
            ),
            Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.education.length,
              itemBuilder: (context, index) 
                => controller.education.isEmpty?
                const Text("There's nothing here.\nMaybe you can consider telling us about your education history?",
                  textAlign: TextAlign.center,
                )
                :
                Slidable(
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context){
                          if (kDebugMode) {
                            debugPrint('Delete!');
                            debugPrint(controller.education[index]['hashCode']);
                          }
                          controller.deleteEduHistoryItem(controller.education[index]['hashCode']);
                        },
                        icon: Icons.delete,
                        label: 'Delete',
                        backgroundColor: lightColorScheme.error,
                      )
                    ]
                  ),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context){
                          if (kDebugMode) {
                            debugPrint('Edit!'); 
                          }
                          showEduDialog(context, 
                            title: 'Edit',
                            key: addEducationkey,
                            controller: controller,
                            eduLevelInitValue: controller.education[index]['eduLevel'],
                            eduLevelOnSaved: (input)=> controller.eduLevel = input,
                            eduInstituteInitValue: controller.education[index]['eduInstitute'],
                            eduInstituteOnSaved: (input)=> controller.eduInstitute = input,
                            fieldOfStudyInitValue: controller.education[index]['fieldOfStudy'],
                            fieldOfStudyOnSaved: (input)=> controller.fieldOfStudy = input,
                            eduYearStartInitValue: controller.education[index]['eduYearStart'],
                            eduYearStartOnSaved: (input)=> controller.eduYearStart = input,
                            eduYearStartValidator: (input) {
                              input!.contains(RegExp(r'^\d{4}?$'))?null:'Wrong Year Format';
                              return null;
                            },
                            eduYearEndInitValue: controller.education[index]['eduYearEnd'],
                            eduYearEndOnSaved: (input)=> controller.eduYearEnd = input,
                            eduYearEndValidator: (input) {
                              input!.contains(RegExp(r'^\d{4}?$'))?null:'Wrong Year Format';
                              return null;
                            },
                            onGoingChanged:[
                              const Text('Ongoing: '),
                              controller.education[index]['eduYearEnd']=='Present'?
                              Obx(()=>Checkbox(
                                value: controller.ongoing.value, 
                                onChanged: (value){
                                  controller.ongoing.value = value!;
                                  controller.toggleOngoing(ongoing: controller.ongoing.value);
                                }
                              ),)
                              :
                              Obx(()=>Checkbox(
                                value: controller.ongoing.value, 
                                onChanged: (value){
                                  controller.ongoing.value = value!;
                                  controller.toggleOngoing(ongoing: controller.ongoing.value);
                                }
                              ),)
                            ],
                            onPressed: () {
                              debugPrint('PRESSED EDIT');
                              if(addEducationkey.currentState!.validate()){
                                addEducationkey.currentState!.save();
                                debugPrint('EDIT STATE SAVED');
      
                                controller.updateEduHistoryItem(controller.education[index]['hashCode']);
                                debugPrint('UPDATE METHOD CALLED');
                                
                                Navigator.pop(addEducationkey.currentContext!);
                              }
                            },
                          );
                        },
                        icon: Icons.edit,
                        label: 'Edit',
                        backgroundColor: lightColorScheme.primary,
                      )
                    ]
                  ),
                  key: Key(index.toString()),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: Constants.borderSideSoft
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(controller.education[index]!['eduInstitute'], style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: Constants.textSL
                          ),),
                        ),
                        Text(controller.education[index]!['eduLevel'] +" in "+controller.education[index]!['fieldOfStudy'], style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: Constants.textS
                        ),),
                        const SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Year of education:", style: TextStyle(fontSize: Constants.textS),),
                            Text(controller.education[index]!['eduYearStart']
                              +" - "+
                              controller.education[index]!['eduYearEnd'], style: TextStyle(fontSize: Constants.textS),
                            ),
                          ],
                        ),
                        const Text('Swipe to edit/delete', style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 10
                        ),),
                      ],
                    ),
                  ),
                )
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Interests", style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: Constants.textL
                ),),
                IconButton(
                  onPressed: ()=>showInterestDialog(context), 
                  icon: Icon(Icons.edit, color: lightColorScheme.onSurfaceVariant, size: 18)
                )
              ],
            ),
            controller.interests.isEmpty?
            Container(
              padding: Constants.standardInset,
              child: Center(
                child: Text('You have no interests', style: TextStyle(
                  fontSize: Constants.textM
                ),)
              ),
            ):
            Container(
              padding: Constants.standardInset,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for(int i = 0; i<controller.interests.length;i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    child: Text(
                      controller.interests[i]+' ', style: TextStyle(fontSize: Constants.textS),
                    ),
                  )
                ],  
              ),
            ),
            const SizedBox(height: kBottomNavigationBarHeight+(kBottomNavigationBarHeight*0.15),width: double.infinity,)
          ],
        ),
      ),
    );
  }

  showInterestDialog(
    BuildContext context,
  ){
    debugPrint("interest : ${controller.interests}");
    debugPrint("New : ${controller.newInterests}");
    controller.newInterests= RxList.from(controller.interests);
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
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        Components().cEduDialogTitle(title: 'Edit Interests'),
                        Container(
                          padding: Constants.standardInset,
                          child: const Text('Your Interests:'),
                        ),
                        Obx(()=>controller.newInterests.isEmpty?
                        Container(
                          padding: Constants.standardInset,
                          child: Center(
                            child: Text('You have no interests', style: TextStyle(
                              fontSize: Constants.textM
                            ),)
                          ),
                        ):
                        Container(
                          padding: Constants.standardInset,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for(int i = 0; i<controller.newInterests.length;i++)
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.newInterests[i]+' ', style: TextStyle(fontSize: Constants.textS),
                                    ),
                                    GestureDetector(
                                      onTap: ()=>controller.removeInterest(index: i),
                                      child: const Icon(Icons.close, size: 15,),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Card(
                                elevation: 0,
                                margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  onEditingComplete: () => controller.addInterest(
                                    interest: controller.textEditInterest.text
                                  ),
                                  onSubmitted: (value)=>controller.addInterest(
                                    interest: value
                                  ),
                                  controller: controller.textEditInterest,
                                  style: TextStyle(
                                    fontSize: Constants.textSL
                                  ),
                                  maxLines: 1,
                                  minLines: 1,
                                  textInputAction: TextInputAction.none,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    hintText: 'What are you interested in?',
                                    filled: true,
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),                      
                                    ),
                                    fillColor: Constants.portoWhite
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () => controller.addInterest(
                                  interest: controller.textEditInterest.text
                                ),
                                child: Icon(Icons.add, size: 30, color: lightColorScheme.primary,),
                              )
                            )
                          ],
                        ),
                        MaterialButton(
                          onPressed: (){
                            controller.submitInterest();
                            Get.back();
                          },
                          child: Text('Done', style: TextStyle(color: lightColorScheme.primary),),
                        )
                      ],
                    ),
                  )
                )
            )
          )
        );
    });
  }

  showEduDialog(
    BuildContext context, 
    {int? hashCode, 
    String? title,
    Key? key,
    HomeController? controller,
    dynamic eduLevelInitValue,
    Function(String?)? eduLevelOnSaved,
    String? Function(String?)? eduLevelValidator,

    dynamic eduInstituteInitValue,
    Function(String?)? eduInstituteOnSaved,
    String? Function(String?)? eduInstituteValidator,

    dynamic fieldOfStudyInitValue,
    Function(String?)? fieldOfStudyOnSaved,
    String? Function(String?)? fieldOfStudyValidator,

    dynamic eduYearStartInitValue,
    Function(String?)? eduYearStartOnSaved,
    String? Function(String?)? eduYearStartValidator,

    dynamic eduYearEndInitValue,
    Function(String?)? eduYearEndOnSaved,
    String? Function(String?)? eduYearEndValidator,

    List<Widget> onGoingChanged = const [],
    required void Function()? onPressed

  })
  {
    return showCupertinoDialog(
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
                    child: Form(
                      key: key,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: [
                          Components().cEduDialogTitle(title: 'Education Details'),
                          CTextFormField1(
                            hintText: 'Ex: Bachelor of Arts, Bachelor of Science, etc',
                            labelText: 'Degree',
                            initialValue: eduLevelInitValue,
                            onSaved: eduLevelOnSaved
                          ),
                          CTextFormField1(
                            hintText: 'Ex: University College London, etc',
                            labelText: 'Institute',
                            initialValue: eduInstituteInitValue,
                            onSaved: eduInstituteOnSaved
                          ),
                          CTextFormField1(
                            hintText: 'Ex: Computer Science, Engineering, etc',
                            labelText: 'Field of Study',
                            initialValue: fieldOfStudyInitValue,
                            onSaved: fieldOfStudyOnSaved
                          ),
                          CTextFormField1(
                            hintText: 'Ex: 2011 (Numerical Only)',
                            labelText: 'Year Start',
                            keyboardType: TextInputType.number,
                            initialValue: eduYearStartInitValue,
                            onSaved: eduYearStartOnSaved,
                            validator: eduYearStartValidator
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: onGoingChanged
                            ),
                          ),
                          Obx(() =>
                            controller!.ongoing.value?
                            const SizedBox():
                            CTextFormField1(
                              hintText: 'Ex: 2015 (Numerical Only)',
                              labelText: 'Year End',
                              keyboardType: TextInputType.number,
                              initialValue: eduYearEndInitValue,
                              onSaved: eduYearEndOnSaved,
                              validator: eduYearEndValidator
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                MaterialButton(
                                  onPressed: onPressed,
                                  child: Text(title!),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
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