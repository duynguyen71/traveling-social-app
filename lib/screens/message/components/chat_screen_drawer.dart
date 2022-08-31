import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/models/chat_group_detail.dart';
import 'package:traveling_social_app/screens/profile/components/icon_with_text.dart';

import '../../../authentication/bloc/authentication_bloc.dart';
import '../../../widgets/user_avt.dart';
import '../../profile/profile_screen.dart';

class ChatScreenDrawer extends StatefulWidget {
  const ChatScreenDrawer({
    Key? key,
    this.chatGroupDetail,
    required this.addMember,
    required this.leaveGroup, required this.changeName,
  }) : super(key: key);
  final ChatGroupDetail? chatGroupDetail;
  final Function addMember;
  final Function leaveGroup;
  final Function changeName;

  @override
  State<ChatScreenDrawer> createState() => _ChatScreenDrawerState();
}

class _ChatScreenDrawerState extends State<ChatScreenDrawer> {
  @override
  Widget build(BuildContext context) {
    var currentUsername =
        context.read<AuthenticationBloc>().state.user.username;
    return SafeArea(
      child: Drawer(
        child: widget.chatGroupDetail == null
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border(
                          bottom: BorderSide(color: Colors.white),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                      child: IconTextButton(
                        onTap: () => widget.changeName(),
                        text: 'Đổi tên',
                        icon: Icon(Icons.edit),
                      )),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border(
                          bottom: BorderSide(color: Colors.white),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                      child: IconTextButton(
                        onTap: () => widget.addMember(),
                        text: 'Thêm thành viên',
                        icon: Icon(Icons.group_add),
                      )),
                  Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                      child: IconTextButton(
                        text: 'Thành viên',
                        icon: Icon(Icons.group),
                      )),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var users = widget.chatGroupDetail!.users ;
                        var user = users[index];
                        var username = user.username;
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context, ProfileScreen.route(user.id!)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade100))),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Row(
                              children: [
                                UserAvatar(
                                  size: 40,
                                  avt: user.avt,
                                  onTap: () => Navigator.push(
                                    context,
                                    ProfileScreen.route(user.id!),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                        '${currentUsername == username ? "Bạn" : username}')),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: widget.chatGroupDetail!.users.length ,
                    ),
                  ),
                  Container(
                      color: Colors.black12,
                      padding: EdgeInsets.all(8.0),
                      child: IconTextButton(
                        onTap: () => widget.leaveGroup(),
                        text: 'Rời nhóm',
                        icon: Icon(Icons.logout),
                      ))
                ],
              ),
      ),
    );
  }
}
