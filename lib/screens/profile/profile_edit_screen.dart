import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/components.dart';
import 'package:porto_space/misc/constants.dart';
import 'package:porto_space/models/supports.dart';
import 'package:porto_space/screens/profile/profile_controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rive/rive.dart';

class ProfileEditScreen extends GetView<ProfileController> {
  
  final bool isNew;

  @override
  final ProfileController controller;

  ProfileEditScreen({required this.isNew, Key? key})
    : controller = Get.put(ProfileController(isNew: isNew)),
      super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: isNew? const Text("Create Your Profile"):const Text("Edit Profile"),
        elevation: 0,
        centerTitle: true,
        shadowColor: Colors.white,
        actions: [
          MaterialButton(
            onPressed: ()async {controller.submitChanges(isNew: isNew);},
            child: const Text(
              "Save",
              style: TextStyle(color: Color.fromARGB(255, 60, 167, 255),  fontSize: 16),
            )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0,36,0,36),
              child: Icon(Icons.add_a_photo, size: 75,),
            ),        
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Text("${controller.user.email}", style: TextStyle(fontSize: Constants.textSL),),
            ),
            Components().textFieldItem(
              isDate: false,
              labelText: "Name: ",
              validator: controller.isLoading.value,
              controller: controller.textEditName
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Unemployed: '),
                  controller.occupation.value=='Unemployed'?
                  Obx(()=>Checkbox(
                    value: controller.current.value, 
                    onChanged: (value){
                      controller.current.value = value!;
                      controller.toggleUnemployed(current: controller.current.value);
                    }
                  ),)
                  :
                  Obx(()=>Checkbox(
                    value: controller.current.value, 
                    onChanged: (value){
                      controller.current.value = value!;
                      controller.toggleUnemployed(current: controller.current.value);
                    }
                  ),)
              ],
            ),
            Obx(()=>
            controller.current.value?SizedBox():Column(
              children: [
                Components().textFieldItem(
                  isDate: false,
                  labelText: "Occupation: ",
                  validator: controller.isLoading.value,
                  controller: controller.textEditOccupation
                ),
                Components().textFieldItem(
                  isDate: false,
                  labelText: "Company: ",
                  validator: controller.isLoading.value,
                  controller: controller.textEditCurrentCompany
                ),
              ],
            ),),
            Obx(()=>Components().textFieldItem(
              isDate: true,
              labelText: "Birthdate: ",
              onTap: ()=> controller.selectDate(context),
              validator: controller.isLoading.value,
              textResult: "${controller.selectedDate?.value.toLocal().toString().split(' ')[0] ?? controller.dob}"
            )),
            Components().textTypeAheadField<City>(
              labelText: "City:",
              controller: controller.textEditCity,
              validator: controller.isLoading.value,
              margin: EdgeInsets.only(bottom: (MediaQuery.of(context).viewInsets.bottom)*1.5,),
              suggestionsCallback: (query) => controller.searchCity(query),
              itemBuilder: (context, City city) => ListTile(
                title: Text('${city.cityName}, ${city.countryName}'),
                autofocus: true,
              ), 
              onSuggestionSelected: (City city) {
                controller.textEditCity.text = '${city.cityName}, ${city.countryName}';
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: isNew?
      Obx(() => 
        controller.isLoading.value? Container(
          height: height*0.1,
          width: width*0.8,
          color: Colors.white,
          child: const RiveAnimation.asset('assets/animation/tristructure - loading.riv'),
        ):Container(
          height: height*0.1,
          width: width*0.8,
          color: Colors.white,
        )
      )
      :
      Obx(() => 
        controller.isLoading.value? Container(
          height: 36,
          width: width*0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 7,
                blurRadius: 7
              )
            ]
          ),
          child: const RiveAnimation.asset('assets/animation/tristructure - loading.riv'),
        ):Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 7,
                blurRadius: 7
              )
            ]
          ),
          height: 36,
          child: Center(
            child: GestureDetector(
              onTap: (){
                showDialog(
                  context: context, 
                  builder: (context)=> AlertDialog(
                    actionsPadding: const EdgeInsets.fromLTRB(2,0,2,8),
                    insetPadding: const EdgeInsets.all(4),
                    contentPadding: const EdgeInsets.all(4),
                    title: const Text('Confirm Delete?', textAlign: TextAlign.center,),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      MaterialButton(
                        onPressed: ()=> Navigator.of(context).pop(),
                        child: const Text('Cancel', textAlign: TextAlign.center,),
                      ),
                      MaterialButton(
                        onPressed: ()=> controller.eraseAccount(),
                        child: const Text('Yes', textAlign: TextAlign.center,),
                      ),
                    ],
                  )
                );
              },
              child:Text('Delete Account',
                textAlign: TextAlign.center,
                style: TextStyle(color: lightColorScheme.error, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ),
      )
    );
  }
}