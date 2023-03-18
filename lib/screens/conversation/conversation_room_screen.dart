import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/misc_index.dart';
import 'package:porto_space/models/message.dart';
import 'package:porto_space/screens/conversation/conversation_controller.dart';
import 'package:rive/rive.dart'as rive;

class ConversationRoomScreen extends GetView<ConversationController> {
  ConversationRoomScreen({required this.otherName, required this.roomId, required this.otherId, Key? key}) : super(key: key);

  final otherName, otherId, roomId;

  @override
  final ConversationController controller = Get.put(ConversationController());

  @override
  Widget build(BuildContext context) {
    var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    
    appBar(){
      return PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
        child: Obx(()=>
          controller.isLoading.value?
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text('Loading...',
              style: TextStyle(
                fontSize: Constants.textXL, 
                fontWeight: FontWeight.w700
              ),
            ),
          ):
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              blendMode: BlendMode.srcATop,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                height: 76,
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back_ios_rounded, color: lightColorScheme.onSurfaceVariant,)
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        // padding: const EdgeInsets.only(left: 16),
                        height: 40,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.convoCreds.length,
                          shrinkWrap: false,
                          itemBuilder:(context, index) {
                            var name = controller.convoCreds[index].senderName;
                            var len = controller.convoCreds.length;
                            print("ITEM BUILDER: "+name!);
                            return Center(
                              child: Text(index!=len-1?"$name, ":name,
                                style: TextStyle(
                                  fontSize: Constants.textXL, 
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () =>controller.tweenAnimate(),
                        icon: Icon(Icons.more_vert_rounded, color: lightColorScheme.onSurfaceVariant,)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
      );
    }

    body(){
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)
        ),
        child: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 251, 255, 255),
                lightColorScheme.secondaryContainer
              ],
              begin: const FractionalOffset(0, 0),
              end: const FractionalOffset(0, 1.0),
              stops: const [0.5, 1.0],
              tileMode: TileMode.clamp
            ),
          ),
          child: Obx(()=> 
            controller.isLoading.value?
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
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
              ),
            )
            :
            StreamBuilder<List<Message>>(
              stream: controller.messagesStream(roomId),
              builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Loading...'),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: rive.RiveAnimation.asset('assets/animation/tristructure.riv',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        )
                      )
                    ],
                  );
                }
                final docs = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  physics: const ScrollPhysics(),
                  // shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final messageData = docs[index];
                    final senderId = messageData.senderId;
                    final messageContent = messageData.messageContent;
                    final timeStamp = messageData.time;
                    final year = timeStamp.toString().substring(0,4);
                    final month = months[double.parse(timeStamp.toString().substring(5,7)).toInt()-1];
                    final date = timeStamp.toString().substring(8,10);
                    var width = MediaQuery.of(context).size.width;
                    if (messageData.isBlank == true) {
                      return const Text('Start a new conversation');
                    } else {
                      return senderId==controller.user.uid
                      ? Container(
                        padding: index==docs.length-1?const EdgeInsets.only(top: 82): index==0?const EdgeInsets.only(bottom: 82):null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              timeStamp.toString().substring(11,16), style: TextStyle(fontSize: Constants.textS),
                            ),
                            GestureDetector(
                              onLongPress: () => Clipboard.setData(ClipboardData(text: messageContent)),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: width*0.7
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 34, 255, 134),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: const EdgeInsets.only(
                                  top: 8,
                                  right: 8,
                                  left: 4
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      messageContent, maxLines: null, softWrap: true,
                                    ),
                                    
                                    Text("$month $date, $year", style: TextStyle(fontSize: Constants.textMicro),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : Container(
                          padding: index==docs.length-1?const EdgeInsets.only(top: 82): index==0?const EdgeInsets.only(bottom: 82):null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: width*0.7
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: lightColorScheme.primaryContainer,
                                  // const Color.fromARGB(255, 34, 237, 255),
                                  borderRadius: BorderRadius.circular(8)),
                              margin: const EdgeInsets.only(
                                top: 8,
                                left: 8,
                                right: 4
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.getName(senderId: senderId), style:const  TextStyle(fontWeight: FontWeight.bold,),),
                                  Text(messageContent),
                                  Text("$month $date, $year", style: TextStyle(fontSize: Constants.textMicro),)
                                ],
                              ),
                            ),
                            Text(
                              timeStamp.toString().substring(11,16), style: TextStyle(fontSize: Constants.textS),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            )
          ),
        ),
      );
    }
    
    keyboardBar(){
      return Container(
        decoration: BoxDecoration(
          border: Border(top: Constants.borderSideSoft),
          color: Colors.white
        ),
        width: double.infinity,
        // margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                child: TextField(
                  controller: controller.textEditChat,
                  style: TextStyle(
                    fontSize: Constants.textSL
                  ),
                  maxLines: 7,
                  minLines: 1,
                  onChanged: (String text) {
                    // update chat state here
                    controller.updateChatValue(text);
                  },
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    hintText: 'Type something',
                    filled: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8)),                      
                    ),
                    fillColor: lightColorScheme.secondaryContainer
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => controller.addMessage(
                  chatId: roomId,
                  senderId: controller.user.uid,
                  messageContent: controller.textEditChat.text
                ),
                child: Icon(Icons.send_rounded, size: 30, color: lightColorScheme.primary,),
              )
            )
          ],
        )
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: Constants.linearGradientBackgroundChat
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              child: Container(
                height: kToolbarHeight+9,
                width: kToolbarHeight+9,
                margin: const EdgeInsets.only(bottom: kToolbarHeight*1.5, right: 25),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: (){}, 
                      icon: const Icon(Icons.delete_outline, size: 30,)
                    ),
                    Text(
                      'End chat',
                      style: TextStyle(
                        fontSize: Constants.textM
                      ),
                    )
                  ],
                ),
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
                          maxHeight: height*0.5,
                          maxWidth: width*0.25
                        ),
                        margin: const EdgeInsets.only(right: 9),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(height: 16,),
                          itemCount: controller.convoCreds.length,
                          itemBuilder: (context, index){
                            return Components().profileIcon50(
                              condition: controller.convoCreds[index].senderId!=controller.user.uid,
                              name: controller.convoCreds[index].senderName
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
            onHorizontalDragStart: (details) => controller.tweenAnimate(),
            child: Obx(()=> TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: controller.tweenEndValue.value), 
              duration: const Duration(milliseconds: 200), 
              builder: (context , val, widget){
                return Transform.translate(
                  offset: Offset(-(width*val), 0),
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
                              alignment: Alignment.centerLeft,
                              transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              // ..rotateX(-rotate*1.5)
                              ..rotateY(-rotate)
                              // ..rotateZ(rotate)
                              ,
                              child: body()
                            );
                          }
                        )
                      );
                    }
                  ),
                );
              }
            )),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: appBar()
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: keyboardBar(),
          )
        ],
      ),
    );
  }
}

