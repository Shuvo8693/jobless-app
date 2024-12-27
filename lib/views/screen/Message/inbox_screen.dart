
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobless/controllers/message_controller/send_message_controller.dart';
import 'package:jobless/controllers/message_controller/web_socket_controller.dart';
import 'package:jobless/controllers/profile_controller/profile_controller.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/date_time_formation/data_age_formation.dart';
import 'package:jobless/utils/date_time_formation/difference_formation.dart';
import 'package:jobless/views/base/casess_network_image.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/style.dart';
import '../../base/custom_text_field.dart';
import 'model/chat_list_model.dart';
import 'model/get_message_model.dart';

class MessageInboxScreen extends StatefulWidget {
  const MessageInboxScreen({super.key});

  @override
  State<MessageInboxScreen> createState() => _MessageInboxScreenState();
}

class _MessageInboxScreenState extends State<MessageInboxScreen> {

  final TextEditingController _msgCtrl=TextEditingController();
 final WebSocketController _webSocketController = Get.put(WebSocketController());
 final ProfileController _profileController=Get.put(ProfileController());
 late final SendMessageController _sendMessageController ;
  OtherParticipant? otherParticipants;
  final List<String> menuOptions = [/*'Delete Message',*/ 'View Profile'];
  DataAgeFormation dataAgeFormation=DataAgeFormation();
  DifferenceFormation differenceFormation=DifferenceFormation();
  final ScrollController _scrollController=ScrollController();

  var receiverId = "";
  var senderId = "";
  var receiverName = "";
  var receiverImage = "";
  var receiverRole = "";
  var currentUserId = "";
  var participantChatId = "";
  RxBool isLoading=false.obs;

  @override
  void initState() {
    super.initState();
    getAuthorId();
    getParticipants();

    _sendMessageController=Get.put(SendMessageController(webSocketController: _webSocketController),tag: 'personal_message');
    WidgetsBinding.instance.addPostFrameCallback((__)async{
     await fetchChatHistory();
     if(otherParticipants?.id!.isNotEmpty==true){
       await _profileController.fetchProfile(otherParticipants?.id);
     }
    });
   socketScrollToBottom();

  }


  /// Function area
  void socketScrollToBottom(){
    _webSocketController.messageData.listen((messageList){
      if(_scrollController.hasClients){
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(microseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> fetchChatHistory() async {
    await _webSocketController.fetchAndListenToChatHistory();
    scrollToBottom();
  }

  getAuthorId()async{
    String authorId =await PrefsHelper.getString('authorId') ;
    senderId=authorId;
    print(senderId);
  }
  getParticipants() {
    OtherParticipant participant = Get.arguments['participant'] as OtherParticipant;
    dynamic chatId = Get.arguments['chatId'];
    print(participant);

    participantChatId = chatId ?? '';
    otherParticipants = participant;
     print(otherParticipants);
    if (chatId !=null) {
      _webSocketController.chatId.value= chatId;
    } else {
      print("Error: chatId is null or empty");
    }
    print("Chat ID: ${_webSocketController.chatId.value}");
  }
///all chat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.arrow_back_ios,size: 22,color: AppColors.textColor,)),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustomNetworkImage(
                        imageUrl: otherParticipants?.image != null
                            ? "${ApiConstants.imageBaseUrl}${otherParticipants?.image}"
                            : 'https://via.placeholder.com/150', // Use a placeholder image URL if null
                        height: 50.h,
                        width: 50.w,
                        boxShape: BoxShape.circle,
                      ),

                      SizedBox(
                        width: 16.w,
                      ),
                      Obx((){
                        return  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${otherParticipants?.fullName}',
                                style: AppStyles.h5()
                            ),
                            _profileController.profile.value.jobLessCategory!=null && _profileController.profile.value.jobLessCategory!.isNotEmpty
                                ? Text(_profileController.profile.value.jobLessCategory!.first,
                              style: AppStyles.h6(
                                  color: AppColors.dark2Color),
                            ) : SizedBox.shrink(),
                          ],
                        );
                      }

                      ),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: PopupMenuButton<String>(
                            icon: SvgPicture.asset(AppIcons.messageMenuIcon),
                            onSelected: (value) {
                              if (value == 'Delete Message') {
                                print('Delete message');
                              } else if (value == 'View Profile') {
                                Get.toNamed(AppRoutes.friendprofileViewcreen,arguments: {'friendID':otherParticipants?.id,'isRemoveCancel':true});
                                print('View profile');
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return menuOptions.map((String option) {
                                return PopupMenuItem<String>(
                                  onTap: (){

                                  },
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: InkWell(
                      //     onTap: (){
                      //
                      //     },
                      //     child: Align(
                      //       alignment: Alignment.centerRight,
                      //         child: SvgPicture.asset(AppIcons.messageMenuIcon)),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            )),
        ///=========== Body message area ==========
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Expanded(
                      child: Obx(() {
                        List<MessageData> messageList = _webSocketController.messageData;
                        if(messageList.isEmpty){
                          return const Center(child: Text('No chat available'));
                        }
                        return ListView.builder(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15) ,
                          controller: _scrollController,
                          itemCount: messageList.length,
                          itemBuilder: (context, index) {
                            var message = messageList[index];
                            if (message.senderId?.id == senderId) {
                              return senderBubble(context, message);
                            } else {
                              return receiverBubble(context, message);
                            }
                          },
                        );
                      }),
                    ),

                  ],
                ),
              ),
            ),

            // GroupedListView<String, DateTime>(
            //   elements: _chatController.chatModelList,
            //   controller: _chatController.scrollController,
            //   padding: EdgeInsets.symmetric(horizontal: 20.w),
            //   order: GroupedListOrder.DESC,
            //   itemComparator: (item1, item2) =>
            //       item1.createdAt!.compareTo(item2.createdAt!),
            //   groupBy: (InboxChatModel message) => DateTime(
            //       message.createdAt!.year,
            //       message.createdAt!.month,
            //       message.createdAt!.day
            //   ),
            //   reverse: true,
            //   shrinkWrap: true,
            //   // physics: const AlwaysScrollableScrollPhysics(),
            //   groupSeparatorBuilder: (DateTime date) {
            //     return const SizedBox();
            //   },
            //   itemBuilder: (context,String id) {
            //     return id == currentUserId
            //         ? senderBubble(context,)
            //         : receiverBubble(context,);
            //   },
            // ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20),
                child: Row(
                  children: [
                    ///>>>>>>>>>>>>>>>>>> Text Field >>>>>>>>>>>>>>>>>>>>
                    Expanded(
                        child: CustomTextField(
                          contentPaddingVertical: 15.h,
                          hintText: 'Sent Massage',
                          controller:_msgCtrl,
                          suffixIcon: InkWell(
                            onTap: ()async{
                             await _sendMessageController.pickImageFromGallery();
                             print(_sendMessageController.filePath.value);
                            },
                            child: Padding(
                              padding: EdgeInsets.all( 12.w),
                              child: SvgPicture.asset(AppIcons.fileIcon,height: 16.h,width: 16.w,),
                            ),
                          ),
                        )),
                    SizedBox(width: 10.w,),

                    ///>>>>>>>>>>>>>>>>>> Sent Message Button >>>>>>>>>>>>>>>>>>>>
                    Obx((){
                      if(_sendMessageController.isLoading.value){
                        return Center(child: CupertinoActivityIndicator());
                      }
                      return  InkWell(
                        onTap: () async {
                          if (participantChatId != null) {
                            try {
                              await _sendMessageController.sendMessage(_msgCtrl.text, _sendMessageController.filePath.value, receiverId, participantChatId,);
                              _msgCtrl.text = '';
                              _sendMessageController.filePath.value = '';
                              scrollToBottom();
                            } catch (e) {
                              Get.snackbar('Error', 'Failed to send message: $e');
                            }
                          }
                        },
                        child: Container(
                          height: 55.h,
                          width: 52.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10).r,
                            border: Border.all(
                                color: Get.theme.primaryColor.withOpacity(0.2)),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppIcons.sentIcon,
                              height: 24.h,
                              width: 24,
                            ),
                          ),
                        ),
                      );
                     }

                    )
                  ],
                ),
              ),
            )
          ],
        ));


  }

  /// Sent Massage bubble
  senderBubble(BuildContext context,MessageData sendMessage) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ChatBubble(
            clipper: ChatBubbleClipper3(
              type: BubbleType.sendBubble,
            ),
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            backGroundColor: AppColors.primaryColor,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.57,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 showMessage(sendMessage), ///====Show message=====
                  Text(DateFormat('hh:mm a').format(sendMessage.createdAt!),
                    // DateFormatHelper.formatTimeHHMM(chatModel.createdAt!),
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 4.w,
        ),
        CustomNetworkImage(
          imageUrl: sendMessage.senderId?.image != null
              ? "${ApiConstants.imageBaseUrl}${sendMessage.senderId?.image}"
              : 'https://via.placeholder.com/150', // Use a placeholder image URL if null
          height: 50.h,
          width: 50.w,
          boxShape: BoxShape.circle,
        ),
      ],
    );
  }

  /// Receive Massage bubble
  receiverBubble(BuildContext context,MessageData receiveMessage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomNetworkImage(
          imageUrl: receiveMessage.senderId?.image != null
              ? "${ApiConstants.imageBaseUrl}${receiveMessage.senderId?.image}"
              : 'https://via.placeholder.com/150', // Use a placeholder image URL if null
          height: 50.h,
          width: 50.w,
          boxShape: BoxShape.circle,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ChatBubble(
            clipper: ChatBubbleClipper3(
              type: BubbleType.receiverBubble,
            ),
            //alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            backGroundColor: const Color(0xff1E66CA).withOpacity(0.10),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.57,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 showMessage(receiveMessage), ///========show message===
                  Text(DateFormat('hh:mm a').format(receiveMessage.createdAt!), style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
Widget showMessage(MessageData responseMessage){
   /* if(responseMessage.content?.messageType=='image' && responseMessage.content?.messageType=='text'){
     return Wrap(children: [
      CustomNetworkImage(
      imageUrl: '${ApiConstants.imageBaseUrl}${responseMessage.content?.message}',
          height: 70,
          width: 100),
       Text('${responseMessage.content?.message}',
         style: const TextStyle(color: Colors.white),
         textAlign: TextAlign.start,
       ),
      ],);

    }else */

  if(responseMessage.content?.messageType=='image'){
     return CustomNetworkImage(
          imageUrl: '${ApiConstants.imageBaseUrl}${responseMessage.content?.message}',
          height: 150,
          width: 150,
       boxShape: BoxShape.rectangle,
     );
    } else if(responseMessage.content?.messageType=='text'){
     return  Text('${responseMessage.content?.message}',
       style: const TextStyle(color: Colors.white),
       textAlign: TextAlign.start,);
    }else{
      return SizedBox.shrink();
    }
  }


}
