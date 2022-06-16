import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/chat_group_model.dart';
import 'package:traveling_social_app/screens/message/components/group_chat_entry.dart';
import 'package:traveling_social_app/screens/message/public_chat_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';
import 'package:provider/provider.dart';

import '../../view_model/chat_group_view_model.dart';
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
    getChatGroups();
  }

  getChatGroups() async {
    context.read<ChatGroupViewModel>().getChatGroups();
  }

  String getGroupAvt(ChatGroup group) {
    if (group.users.length == 2) {
      User? user = group.users[0];
      if (!context.read<UserViewModel>().equal(user)) {
        return user.avt.toString();
      } else {
        return group.users[1].avt.toString();
      }
    }
    return '';
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
                  )),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.black45)),
              ],
              backgroundColor: Colors.white,
              floating: true,
              snap: true,
              title: Container(
                child: RoundedInputContainer(
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
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: MyDivider(),
              ),
              forceElevated: innerBoxIsScrolled,
            )
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  GroupChatEntry(
                    name: 'My public message channel',
                    onClick: () {
                      ApplicationUtility.navigateToScreen(
                          context, const PublicChatScreen());
                    },
                    avt: '',
                    countMember: 100,
                  ),
                  Consumer<ChatGroupViewModel>(
                    builder: (context, value, child) => Column(
                      children: List.generate(value.chatGroups.length, (index) {
                        ChatGroup group = value.chatGroups[index];
                        return GroupChatEntry(
                          name: group.name.toString(),
                          onClick: () {
                            ApplicationUtility.navigateToScreen(
                              context,
                              ChatScreen(
                                groupId: group.id!,
                                tmpGroupName: group.name.toString(),
                              ),
                            );
                          },
                          avt: getGroupAvt(group),
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
    );
  }
}
