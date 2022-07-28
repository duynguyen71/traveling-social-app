import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
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
import 'bloc/chat_bloc.dart';
import 'chat_screen.dart';

import 'package:traveling_social_app/models/user.dart';

class ChatGroupsScreen extends StatefulWidget {
  const ChatGroupsScreen({Key? key}) : super(key: key);

  @override
  State<ChatGroupsScreen> createState() => _ChatGroupsScreenState();

  static Route route() => MaterialPageRoute(builder: (_) => const ChatGroupsScreen());
}

class _ChatGroupsScreenState extends State<ChatGroupsScreen> {
  @override
  void initState() {
    if (mounted) {
      setState(() {});
    }
    context.read<ChatBloc>().add(FetchChatGroup());
    super.initState();
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              sliver: SliverAppBar(
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
                    icon: const Icon(Icons.edit, color: Colors.black45),
                  ),
                ],

                backgroundColor: Colors.white,
                // floating: true,
                pinned: true,
                // snap: true,
                centerTitle: true,
                title: RoundedInputContainer(
                  color: Colors.grey.shade100,
                  child: TextField(
                    controller: TextEditingController(),
                    textAlign: TextAlign.left,
                    onSubmitted: (value) {
                      print('on submitted');
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search in chat',
                        hintStyle: TextStyle(
                          letterSpacing: .5,
                          fontSize: 14,
                          // fontStyle: FontStyle.italic
                        )),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.zero,
                ),
                // bottom: const PreferredSize(
                //   preferredSize: Size.fromHeight(10),
                // child: MyDivider(),
                // ),
                forceElevated: innerBoxIsScrolled,
              ),
            )
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {},
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: ((context, state) => Visibility(
                            visible: state.status == ChatGroupStatus.loading,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(kDefaultPadding),
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                          )),
                    ),
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        List<Group> groups = state.chatGroups;
                        return Column(
                          children: List.generate(groups.length, (index) {
                            Group group = groups[index];
                            String? groupName;
                            String? groupAvt;
                            if (group.users.length == 2) {
                              User? user = group.users[0];
                              if (context
                                      .read<AuthenticationBloc>()
                                      .state
                                      .user
                                      .id !=
                                  user.id) {
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
                              isUserActive: true,
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
                        );
                      },
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
