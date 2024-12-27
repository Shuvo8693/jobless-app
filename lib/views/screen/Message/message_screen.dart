import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobless/controllers/message_controller/chat_list_controller.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/utils/date_time_formation/data_age_formation.dart';
import 'package:jobless/utils/date_time_formation/difference_formation.dart';
import 'package:jobless/views/base/bottom_menu..dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/style.dart';
import '../../base/casess_network_image.dart';
import '../../base/custom_text_field.dart';
import 'model/chat_list_model.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  final ChatListController _chatListController = Get.put(ChatListController());
  DataAgeFormation dataAgeFormation=DataAgeFormation();
  DifferenceFormation differenceFormation=DifferenceFormation();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await _chatListController.fetchChatList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomMenu(2),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Message',
              style: AppStyles.h2(
                family: "Schuyler",
              )),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              /// Create Group Button
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.messageGroupCreaateScreen);
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Container(
                      width: 190.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8).r,
                        color: AppColors.primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppIcons.addIcon),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              'Create a new group',
                              style: AppStyles.h5(
                                color: Colors.white,
                                family: "Schuyler",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              /// Friend List

              Expanded(
                child: Obx(() {
                  List<ChatListAttributes> chatList = _chatListController.chatListModel.value.data?.attributes ?? [];
                  if (_chatListController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (chatList == null || chatList.isEmpty) {
                    return const Center(
                        child: Text('Chat participant is empty'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      final chatIndex = chatList[index];
                      if(chatIndex.type=='personal'){
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            Get.toNamed(AppRoutes.messageInboxScreen, arguments: {
                              'participant': chatIndex.otherParticipant,
                              'chatId': chatIndex.sId
                            });
                          },
                          leading: CustomNetworkImage(
                            imageUrl: "${ApiConstants.imageBaseUrl}${chatIndex.otherParticipant?.image}",
                            height: 54.h,
                            width: 54.w,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          title: Text(chatIndex.otherParticipant?.fullName ?? '',
                            style: AppStyles.h5(
                              family: "Schuyler",
                            ),
                          ),
                          subtitle: Row(
                            children: [
                             /* Text('Oke Fine ',
                                  style: AppStyles.h6(
                                    family: "Schuyler",
                                  )),*/
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(DateFormat('hh:mm a').format(chatIndex.createdAt!),
                                  style: AppStyles.h6(
                                    family: "Schuyler",
                                  )),
                            ],
                          ),
                        );
                      }
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          Get.toNamed(AppRoutes.groupInboxScreen, arguments: {
                            'participant': chatIndex.otherParticipant,
                            'chatId': chatIndex.sId,
                            //'groupImage': groupChatIndex.groupImage
                          });
                        },
                        leading: CustomNetworkImage(
                          imageUrl: "${ApiConstants.imageBaseUrl}${chatIndex.otherParticipant?.image}",
                          height: 54.h,
                          width: 54.w,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        title: Text(chatIndex.otherParticipant?.fullName ?? '',
                            style: AppStyles.h5(
                              family: "Schuyler",
                            ),
                        ),
                        subtitle: Row(
                          children: [
                          /*  Text('Oke Fine its group',
                                style: AppStyles.h6(
                                  family: "Schuyler",
                                )),*/
                            SizedBox(
                              width: 8.w
                            ),
                            Text(DateFormat('hh:mm a').format(chatIndex.createdAt!), style: AppStyles.h6(family: "Schuyler",)),
                          ],
                        ),
                      );
                    },
                    /// Group Section
                    /*separatorBuilder: (context, index) {
                      final groupChatIndex = chatList[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          Get.toNamed(AppRoutes.groupInboxScreen, arguments: {
                            'chatListAttributes': groupChatIndex.participants,
                            'chatId': groupChatIndex.id,
                            'groupImage': groupChatIndex.groupImage
                          });
                        },
                        leading:groupChatIndex.groupImage!=null && groupChatIndex.groupImage!.isNotEmpty? CustomNetworkImage(
                          imageUrl: "${ApiConstants.imageBaseUrl}${groupChatIndex.groupImage}",
                          height: 54.h,
                          width: 54.w,
                          borderRadius: BorderRadius.circular(10.r),
                        ):CustomNetworkImage(imageUrl: '', height: 54.h, width: 54.w) ,
                        title: Text('jobless community',
                            style: AppStyles.h5(
                              family: "Schuyler",
                            )),
                        subtitle: Row(
                          children: [
                            Text('Oke Fine ',
                                style: AppStyles.h6(
                                  family: "Schuyler",
                                )),
                            SizedBox(width: 8.w),
                            Text('08:30 Am',
                                style: AppStyles.h6(
                                  family: "Schuyler",
                                )),
                          ],
                        ),
                      );
                    },*/

                  );
                }),
              )
            ],
          ),
        ),
    );
  }
}
