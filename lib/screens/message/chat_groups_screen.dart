import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/group.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:traveling_social_app/screens/message/components/group_chat_entry.dart';
import 'package:traveling_social_app/screens/message/create_message_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';

import 'bloc/chat_bloc.dart';
import 'chat_screen.dart';

class ChatGroupsScreen extends StatefulWidget {
  const ChatGroupsScreen({Key? key}) : super(key: key);

  @override
  State<ChatGroupsScreen> createState() => _ChatGroupsScreenState();

  static Route route() =>
      MaterialPageRoute(builder: (_) => const ChatGroupsScreen());
}

class _ChatGroupsScreenState extends State<ChatGroupsScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {});
    }
    if (context.read<ChatBloc>().state.chatGroups.isEmpty) {
      context.read<ChatBloc>().add(const FetchChatGroup());
    }
  }

  String? getGroupAvt(Group group) {
    if (group.users.length == 2) {
      User? user = group.users[0];
      if (context.read<AuthenticationBloc>().state.user.id != user.id) {
        return user.avt;
      } else {
        return group.users[1].avt;
      }
    }
    return null;
  }

  _filterGroups(value) {
    context.read<ChatBloc>().add(Filter(value));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              leading: IconButton(
                padding: const EdgeInsets.only(left: 8.0),
                onPressed: () => Navigator.of(context).pop(),
                alignment: Alignment.center,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Center(
                    child: RoundedIconButton(
                      onClick: () {
                        Navigator.push(context, CreateMessageScreen.route());
                      },
                      icon: Icons.add,
                      size: 30,
                    ),
                  ),
                ),
              ],
              leadingWidth: 20,
              elevation: 0,
              backgroundColor: Colors.white,
              pinned: true,
              centerTitle: true,
              title: RoundedInputContainer(
                color: Colors.grey.shade100,
                child: TextField(
                  // controller: _searchController,
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<ChatBloc>().add(const Filter(null));
                    }
                  },
                  onSubmitted: (value) {
                    _filterGroups(value);
                  },
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Tìm tin nhắn',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    hintStyle: TextStyle(
                      letterSpacing: .5,
                      fontSize: 14,
                      // fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.zero,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: MyDivider(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ChatBloc>().add(const FetchChatGroup());
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      //LOADING
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
                      //
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Text(
                              "Nhắn tin",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  letterSpacing: .6,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<ChatBloc, ChatState>(
                        builder: (context, state) {
                          List<Group> groups = state.filtered;
                          return Column(
                            children: List.generate(
                              groups.length,
                              (index) {
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
                              },
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Text(
                              "Đề xuất",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  letterSpacing: .6,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // NO MESSAGE WIDGET
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: (state.chatGroups.isNotEmpty ||
                            state.status != ChatGroupStatus.success)
                        ? const SizedBox.shrink()
                        : Container(
                            margin: EdgeInsets.only(top: size.height * .2),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: SvgPicture.asset(
                                    'assets/icons/inbox_message.svg',
                                    color: kPrimaryColor.withOpacity(.4),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Không có tin nhắn',
                                    style: TextStyle(
                                        color: kPrimaryColor.withOpacity(.8),
                                        fontSize: 18,
                                        letterSpacing: .8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
