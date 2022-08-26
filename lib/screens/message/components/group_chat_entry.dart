import 'package:flutter/material.dart';

import '../../../models/message.dart';
import '../../../my_theme.dart';
import '../../../widgets/user_avt.dart';

class GroupChatEntry extends StatelessWidget {
  const GroupChatEntry(
      {Key? key,
      required this.name,
      required this.onClick,
      this.avt,
      required this.countMember,
      this.lastMessage,
      this.isUserActive})
      : super(key: key);

  final String name;
  final Function onClick;
  final String? avt;
  final int countMember;
  final Message? lastMessage;
  final bool? isUserActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onClick(),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        UserAvatar(
                          size: 40,
                          avt: avt,
                          onTap: () {},
                          isActive: isUserActive,
                        ),
                        Visibility(
                          visible: countMember > 2,
                          child: Positioned(
                            child: Container(
                              child: Text(
                                '$countMember',
                                style: const TextStyle(color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            top: 0,
                            right: 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //GROUP NAME
                          Text(
                            name,
                            style: MyTheme.heading2.copyWith(
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          //lasted message
                          Text(
                            lastMessage?.message ?? '',
                            style: MyTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () {},
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
