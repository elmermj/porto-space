import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porto_space/components/components_index.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/misc_index.dart';
import 'package:porto_space/screens/entrance/entrance_index.dart';
import 'package:porto_space/screens/home/home_index.dart';
import 'package:porto_space/screens/pings/pings_index.dart';
import 'package:porto_space/screens/profile/profile_index.dart';
import 'package:porto_space/screens/search/search_controller.dart' as s;
import 'package:porto_space/screens/search/search_screen.dart';
import 'package:rive/rive.dart' as rive;

class HomeScreen extends GetView<HomeController>{
  final addEducationkey = GlobalKey<FormState>();
  final editEducationkey = GlobalKey<FormState>();

  @override
  final HomeController controller = Get.put(HomeController());
  final s.SearchController searchController = Get.put(s.SearchController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    Widget homeBody(){
      return Obx(()=>
        controller.isLoading.value||controller.occupation==null? 
        Container(
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
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Loading Data. Please wait'),
              SizedBox(
                height: 90,
                width: 240,
                child: rive.RiveAnimation.asset('assets/animation/tristructure - loading.riv', 
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                )
              )
            ],                
          )
        ):
        SafeArea(
          child: Container(
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
          child: Stack(
            children: [
              Column(     
                mainAxisAlignment: MainAxisAlignment.start,       
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: controller.isUnemployed.value?115:130,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 32, 0, 32),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: lightColorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16)
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(width*0.05, 0, 0, 0),
                          height: 80,
                          width: 80,
                          decoration: const ShapeDecoration(
                            shape: StarBorder.polygon(
                              sides: 6,
                              pointRounding: 0.3,
                            ),
                            color: Colors.black
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 32, 2, 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(flex: 3,child: Container()),
                              Expanded(flex: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Welcome", style: TextStyle(fontSize: Constants.textM,)),
                                    Text("${controller.name}",
                                      style: TextStyle(
                                        fontSize: Constants.textL, 
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis
                                      )
                                    ),
                                    controller.isUnemployed.value?
                                    const SizedBox(): 
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text("${controller.occupation} at ${controller.currentCompany}",
                                        style: const TextStyle(
                                          fontSize: 12, 
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CTabBar(
                    tabs: [
                      Components().cTab(text: 'My Journey',),
                      Components().cTab(text: 'About Me',),
                      Components().cTab(text: 'Achievements',),
                      Components().cTab(text: 'Projects',)]
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Center(child: Text("About Me"),),
                        const MyJourneySubScreen(),
                        AboutMeSubScreen(),
                        const Center(child: Text("Achievements"),),
                        ProjectsSubScreen(),
                      ]
                    ),
                  )
                ],
              ),
              ],
            ),
          ),
        ),
      );
    }

    Widget collaborationsBody(){
      return Container(
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
        child: const Center(
          child: Text('Collaborations')
        ),
      );
    }

    Widget hiddenDrawer(){
      return HiddenDrawer(
        width: 0.2*width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DrawerItem(
              text: 'Edit Profile',
              icon:  Icons.settings,
              onTap: ()=>Get.to(()=>ProfileEditScreen(isNew: false,),
                transition: Transition.rightToLeft)
                ?.whenComplete(() => 
                controller.loadProfile(partial: true)
              ),
            ),
            DrawerItem(
              text: 'Log Out',
              icon: Icons.logout_rounded,
              onTap: (){
                FirebaseAuth.instance.signOut();
                Get.offAll(EntranceScreen());
              },
            )
          ]
        ),
      );
    }

    Widget pageView(){
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20)
        ),
        child: PageView(
          physics:const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          children: [
            homeBody(),
            ConversationListScreen(),
            collaborationsBody()
          ],
        ),
      );
    }

    return GetBuilder<HomeController>(
      init: controller,
      builder: (controller) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor:const Color.fromARGB(255, 251, 255, 255),
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
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                      onSubmitted:(value) {
                        searchController.search(searchController.searchTextController.text);
                        Get.to(()=>SearchScreen());
                      },
                    ),
                  ):
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: rive.RiveAnimation.asset('assets/animation/tristructure.riv',)
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
              leading: IconButton(
                onPressed: ()=>controller.tweenAnimate(), 
                icon: const Icon(Icons.menu)),
              actions: [IconButton(
                icon: Obx(()=>
                  searchController.isSearchActive.value ? 
                  const Icon(Icons.close)
                  :const Icon(Icons.search)
                ),
                onPressed: () {
                  searchController.searchTextController.clear();
                  searchController.isSearchActive.toggle();
                  searchController.selectedButton.value == s.SearchButton.people;
                  controller.update();
                },
              ),],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: Obx(()=>
                  searchController.isSearchActive.value?
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: Row(children: [
                        SearchBarTextButton(
                          buttonName: 'People',
                          color: searchController.selectedButton.value == s.SearchButton.people
                                  ? lightColorScheme.primary
                                  : lightColorScheme.secondary,
                          onPressed: (){searchController.setSelectedButton(s.SearchButton.people);},
                        ),
                        SearchBarTextButton(
                          buttonName: 'Interests',
                          color: searchController.selectedButton.value == s.SearchButton.interests
                                  ? lightColorScheme.primary
                                  : lightColorScheme.secondary,
                          onPressed: (){searchController.setSelectedButton(s.SearchButton.interests);},
                        ),
                      ],),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 24,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                            backgroundColor: Colors.greenAccent
                          ),
                          onPressed: ()=>Get.to(
                            ()=>PingsScreen(),
                            transition: Transition.rightToLeft
                          ), 
                          child: Text(
                            "Pings",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Constants.textM
                            )
                          )
                        ),
                      )
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SearchBarTextButton(
                            buttonName: 'Search',
                            color: searchController.searchTextController.text != ''
                                ? lightColorScheme.primary
                                : lightColorScheme.secondary,
                            onPressed: (){}
                          ),
                        ],
                      ),
                    )
                  ],
                ):const SizedBox()
                ),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: Constants.linearGradientBackground
                ),
                Obx(()=> 
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: controller.slideValue.value), 
                    duration: const Duration(milliseconds: 200), 
                    builder: (context , val, widget){
                      return Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.translationValues(-(val*width), 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: hiddenDrawer()
                        ),
                      );
                    }
                  ),
                ),
                Obx(()=> TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: controller.tweenEndValue.value), 
                  duration: const Duration(milliseconds: 200), 
                  builder: (context , val, widget){
                    return Transform.translate(
                      offset: Offset((val*width), 0),
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: controller.scaleValue.value),
                        duration: const Duration(milliseconds: 200), 
                        builder:(context , scale, widget) {
                          return Transform.scale(
                            scale: scale,
                            child: TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: controller.scaleRValue.value),
                              duration: const Duration(milliseconds: 200), 
                              builder:(context , rotate, widget) {
                                return Transform(
                                  alignment: Alignment.centerRight,
                                  transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  // ..rotateX(-rotate*1.5)
                                  ..rotateY(rotate)
                                  // ..rotateZ(rotate)
                                  ,
                                  child: pageView()
                                );
                              }
                            )
                          );
                        }
                      ),
                    );
                  }
                )),
            ]),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Obx(()=>ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: SizedBox(
                height: kBottomNavigationBarHeight-(kBottomNavigationBarHeight/10),
                width: width*0.9,
                child: BottomNavigationBar(
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: lightColorScheme.primary,
                  enableFeedback: true,
                  selectedFontSize: 12,
                  unselectedFontSize: 10,
                  iconSize: 20,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  items: controller.bottomTabs,
                  currentIndex: controller.page.value,
                  type: BottomNavigationBarType.shifting,
                  onTap: (value) => controller.onPageChanged(value),
                ),
              ),
            )),
          ),
        );
      }
    );
  }
  
  Widget myJourney(){
    return const Center(child: Text("My Journey"),);
  }

  Widget searchRecommendationBox({
    required BuildContext context
  }){
    return Column(
      children: [
        ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) => 
            index==2? GestureDetector(
              onTap: () => Get.to(const HomeSearchResultScreen()),
              child: const Row(
                children: [
                  Text('See more results'),
                  Icon(Icons.arrow_right)
                ],
              ),
            )
            :Text("DATA $index")
        ),
        
      ],
    );
  }
}