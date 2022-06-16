import 'package:flutter/material.dart';

import '../../../widgets/user_avt.dart';

class GroupChatEntry extends StatelessWidget {
  const GroupChatEntry(
      {Key? key,
      required this.name,
      required this.onClick,
      required this.avt,
      required this.countMember})
      : super(key: key);

  final String name;
  final Function onClick;
  final String avt;
  final int countMember;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade50))),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onClick(),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      UserAvatar(size: 40, avt: avt, onTap: () {}),
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
                      Text(
                        name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'last message',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black54,
                )),
          ),
        ],
      ),
    );
  }
}
