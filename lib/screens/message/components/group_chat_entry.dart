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
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(color: Colors.grey.shade100),
      //   ),
      // ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //group name
                        Text(
                          name,
                          style: MyTheme.heading2.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        //lasted message
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .6),
                          child: Text(
                            lastMessage?.message ?? '',
                            style: MyTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
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
