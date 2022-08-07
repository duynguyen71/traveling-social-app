import 'package:flutter/material.dart';
import 'package:traveling_social_app/bloc/story/story_bloc.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:traveling_social_app/widgets/popup_menu_item.dart';
import 'package:provider/provider.dart';

class StoryContextMenu extends StatelessWidget {
  const StoryContextMenu(
      {Key? key,
      required this.isCurrentUser,
      required this.user,
      required this.storyId})
      : super(key: key);

  final bool isCurrentUser;
  final User user;
  final int storyId;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Container(
        height: 36,
        width: 48,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.more_horiz, color: Colors.white),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      color: Colors.grey.shade100,
      itemBuilder: (context) {
        return isCurrentUser
            ? const <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'DELETE',
                  child: MyPopupMenuItem(
                      title: 'DELETE', iconData: Icons.visibility_off),
                ),
              ]
            : <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'FOLLOW',
                  child:
                      MyPopupMenuItem(title: 'Follow ', iconData: Icons.person),
                ),
                const PopupMenuItem<String>(
                  value: 'LOVE',
                  child: MyPopupMenuItem(title: 'Love', iconData: Icons.person),
                ),
              ];
      },
      onSelected: (string) {
        switch (string) {
          case "DELETE":
            {
              //TODO: remove story
              context.read<StoryBloc>().add(RemoveStory(storyId));
              break;
            }
        }
      },
      padding: EdgeInsets.zero,
      elevation: 0,
    );
  }
}
