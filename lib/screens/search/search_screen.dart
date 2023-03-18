import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/components.dart';
import 'package:porto_space/misc/constants.dart';
import 'package:porto_space/screens/entrance/entrance_screen.dart';
import 'package:porto_space/screens/profile/profile_edit_screen.dart';
import 'package:porto_space/screens/search/search_controller.dart';
import 'package:rive/rive.dart';

class SearchScreen extends GetView<SearchController> with PreferredSizeWidget{
  SearchScreen({super.key});
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(20);

  
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        width: 150,
        child: Container(
          height: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Components().drawerItem(
                text: 'Edit Profile',
                icon:  Icons.settings,
                onTap: ()=>Get.to(()=>ProfileEditScreen(isNew: false,))
              ),
              Components().drawerItem(
                text: 'Log Out',
                icon: Icons.logout_rounded,
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Get.offAll(EntranceScreen());
                },
              )
            ]
          ),
        )
      ),
      appBar: AppBar(
        title: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Obx(()
            =>searchController.isSearchActive.value?
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: TextField(
                textInputAction: TextInputAction.go,
                controller: searchController.searchTextController,
                decoration: const InputDecoration(
                  hintText: 'Search the exact term (case sensitive)',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 12)
                ),
                onSubmitted:(value) => searchController.search(searchController.searchTextController.text),
              ),
            ):
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: RiveAnimation.asset('assets/animation/tristructure.riv',)
                  ),
                  Text(" Porto|Space",
                    style: TextStyle(
                      fontFamily: "Unbounded",
                      fontSize: 24
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
        actions: [IconButton(
          icon: Obx(()=>
            searchController.isSearchActive.value ? 
            const Icon(Icons.close)
            :const Icon(Icons.search)
          ),
          onPressed: () {
            searchController.searchTextController.clear();
            searchController.isSearchActive.toggle();
            Get.back();
            searchController.selectedButton.value == SearchButton.people;
            controller.update();
          },
        ),],
        bottom: PreferredSize(
          preferredSize: preferredSize,
          child: Obx(()=>
            searchController.isSearchActive.value?
            Row(children: [
              Expanded(
                flex: 4,
                child: Row(children: [
                  Components().searchBarTextButton(
                    buttonName: 'People',
                    color: searchController.selectedButton.value == SearchButton.people
                            ? lightColorScheme.primary
                            : lightColorScheme.secondary,
                    onPressed: (){searchController.setSelectedButton(SearchButton.people);},
                  ),
                  Components().searchBarTextButton(
                    buttonName: 'Occupations',
                    color: searchController.selectedButton.value == SearchButton.occupations
                            ? lightColorScheme.primary
                            : lightColorScheme.secondary,
                    onPressed: (){searchController.setSelectedButton(SearchButton.occupations);},
                  ),
                  Components().searchBarTextButton(
                    buttonName: 'Interests',
                    color: searchController.selectedButton.value == SearchButton.interests
                            ? lightColorScheme.primary
                            : lightColorScheme.secondary,
                    onPressed: (){searchController.setSelectedButton(SearchButton.interests);},
                  ),
                ],),
              ),
              Expanded(
                flex: 1,
                child: Components().searchBarTextButton(
                  buttonName: 'Search',
                  color: searchController.searchTextController.text != ''
                      ? lightColorScheme.primary
                      : lightColorScheme.secondary,
                  onPressed: (){}
                ),
              )
            ],
          ):const SizedBox()
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          ()=>Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: 
            searchController.searchResults.isNotEmpty?
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Search result for '${searchController.searchWarning.value}'",
                    style: TextStyle(color: lightColorScheme.primary),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchController.searchResults.length,
                  itemBuilder: (context, index){
                    QueryDocumentSnapshot<Map<String, dynamic>> result = searchController.searchResults[index];
                    List<String> resultIdToList= [];
                    List<String> resultNameToList = [];
                    resultIdToList.add(result.id);
                    resultNameToList.add(result['name']);
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: Constants.borderSideSoft
                        )
                      ),
                      child: ListTile(
                        leading: Text('Index \n   $index'),
                        title: Text('${result['name']}', style: TextStyle(fontSize: Constants.textSL),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${result['occupation']} at ${result['currentCompany']}', 
                              style: TextStyle(fontSize: Constants.textM), textAlign: TextAlign.start),
                            Text('Currently lives in ${result['city']}', 
                              style: TextStyle(fontSize: Constants.textM), textAlign: TextAlign.start,),                              
                            Text('ID : ${result.id}', 
                              style: TextStyle(fontSize: Constants.textM), textAlign: TextAlign.start,),
                          ],
                        ),
                        trailing: GestureDetector(
                          onTap:
                          //  (){},
                          ()=> searchController.openConversation(
                              userId: searchController.user.uid, 
                              othersId: resultIdToList,
                              othersName: resultNameToList
                          ),
                          child: const Icon(Icons.message_rounded),
                        )
                      ),
                    );
                  }
                ),
              ],
            ):
            Center(
              child: Obx(() => searchController.searchWarning.value=="" || searchController.isSearchActive.value==false ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.search_rounded, size: 82,),
                    Text('Search Something', textAlign: TextAlign.center,),
                  ],
                ):
                Text("No result for '${searchController.searchWarning.value}'", textAlign: TextAlign.center,)
              )
            )
          ),
        ),
      ),
    );
  }

  List<Map<String,dynamic>?>? dummydata = [
    {
      'name': 'ass',
      'age':19
    },
    {
      'name': 'qwr',
      'city': 'medan'
    },
    {
      'name': 'poi'
    },
    {
      'name': '2ffa'
    },
  ];
}