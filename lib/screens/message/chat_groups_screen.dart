import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/group.dart';
import 'package:traveling_social_app/screens/message/components/group_chat_entry.dart';
import 'package:traveling_social_app/screens/message/public_chat_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';
import 'package:provider/provider.dart';

import '../../view_model/chat_room_view_model.dart';
import 'chat_screen.dart';

import 'package:traveling_social_app/models/user.dart';

class ChatGroupsScreen extends StatefulWidget {
  const ChatGroupsScreen({Key? key}) : super(key: key);

  @override
  State<ChatGroupsScreen> createState() => _ChatGroupsScreenState();
}

class _ChatGroupsScreenState extends State<ChatGroupsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatRoomViewModel>().getChatGroups();
  }

  String? getGroupAvt(Group group) {
    if (group.users.length == 2) {
      User? user = group.users[0];
      if (!context.read<UserViewModel>().equal(user)) {
        return user.avt.toString();
      } else {
        return group.users[1].avt.toString();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black87,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.black45),),
              ],
              backgroundColor: Colors.white,
              floating: true,
              snap: true,
              title: RoundedInputContainer(
                color: Colors.grey.shade100,
                child: TextField(
                  controller: TextEditingController(),
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.zero,
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: MyDivider(),
              ),
              forceElevated: innerBoxIsScrolled,
            )
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            print("REFRESH GROUP CHAT");
         await   context.read<ChatRoomViewModel>().refresh();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Consumer<ChatRoomViewModel>(
                      builder: (context, value, child) => Visibility(
                        visible: value.isLoading,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(kDefaultPadding),
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                      ),
                    ),
                    GroupChatEntry(
                      name: 'My public message channel',
                      onClick: () {
                        ApplicationUtility.navigateToScreen(
                            context, const PublicChatScreen());
                      },
                      avt: null,
                      countMember: 100,
                    ),
                    Consumer<ChatRoomViewModel>(
                      builder: (context, value, child) => Column(
                        children:
                            List.generate(value.chatGroups.length, (index) {
                          Group group = value.chatGroups[index];
                          String? groupName;
                          String? groupAvt;
                          if (group.users.length == 2) {
                            User? user = group.users[0];
                            if (!context.read<UserViewModel>().equal(user)) {
                              groupAvt = user.avt;
                              groupName = user.username;
                            } else {
                              groupAvt = group.users[1].avt;
                              groupName = group.users[1].username;
                            }
                          } else {
                            groupName = group.name;
                          }
                          return GroupChatEntry(
                            name: groupName.toString(),
                            lastMessage: group.lastMessage,
                            onClick: () {
                              ApplicationUtility.navigateToScreen(
                                context,
                                ChatScreen(
                                  groupId: group.id!,
                                  tmpGroupName: groupName,
                                ),
                              );
                            },
                            avt: groupAvt,
                            countMember: group.users.length,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
