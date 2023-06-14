import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/constants.dart';
import 'package:porto_space/screens/home/home_controller.dart';
import 'package:porto_space/screens/search/search_controller.dart' as s;

class ConversationListScreen extends GetView<HomeController> {
  ConversationListScreen({super.key});
  // final Stream<List<ConvoPreview>> convoList;


  final s.SearchController searchController = Get.put(s.SearchController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    // debugPrint(homeController.convoList.length);
    return Container(
      height: double.infinity,
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
      child: SafeArea(
        child: Column(
          children: [
            Obx((){
              if(homeController.convoList.isEmpty){return const Center(child: Text('No conversation'),);}
              else{
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: homeController.convoList.length,
                  itemBuilder: (context, index) {
                    final item = homeController.convoList[index];
                    var indexMonth = item.timeStamp.month;
                    String mmm = months[indexMonth-1];
                    return GestureDetector(
                      onTap: () => homeController.openConversation(
                        othersName: item.othersName,
                        othersId: item.othersId,
                        convoId: item.convoId,
                        lastMessageId: item.lastMessageId
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: Constants.borderSideSoft,
                          ),
                          gradient: (item.newMessage && item.senderId != homeController.user.uid)? const RadialGradient(
                            colors: [ Color.fromARGB(255, 181, 255, 194),Color.fromRGBO(255, 255, 255, 0)],
                            center: Alignment.centerLeft,
                            radius: 10,
                            stops: [0.1, 0.5],
                            tileMode: TileMode.decal
                          ):null
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: item.othersName.length,
                                      shrinkWrap: false,
                                      itemBuilder: (context, index) {
                                        final len = item.othersName.length;
                                        return index != len - 1
                                        ? Text(
                                          "${item.othersName[index]}, ",
                                          style:
                                            TextStyle(fontSize: Constants.textM),
                                        )
                                        : Text(
                                          item.othersName[index],
                                          style:
                                            TextStyle(fontSize: Constants.textSL),
                                        );
                                      },
                                    ),
                                  ),
                                  (item.newMessage && item.senderId != homeController.user.uid)?
                                  Text("New Message - ${item.lastMessage}",
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: Constants.textM,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ):Text(
                                    item.lastMessage,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Constants.textM,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("${item.timeStamp.hour.toString().padLeft(2,"0")}:${item.timeStamp.minute.toString().padLeft(2,"0")}"),
                                  Text(
                                    item.timeStamp.day==DateTime.now().day?
                                    'Today'
                                    :item.timeStamp.day==DateTime.now().day-1?
                                    'Yesterday'
                                    :"${item.timeStamp.day} $mmm ${item.timeStamp.year}",
                                    style: TextStyle(
                                      fontSize: Constants.textM
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
            const SizedBox(height: kBottomNavigationBarHeight+(kBottomNavigationBarHeight*0.15),width: double.infinity,)
          ],
        ),
        
      ),
    );
  }
}