import 'package:flutter/material.dart';

import '../../constants/app_theme_constants.dart';

class ChatController extends StatelessWidget {
  const ChatController({
    Key? key,
    required this.size,
    required this.messageController,
    required this.onSendBtnPressed,
    this.focusNode,
    this.onChange,
    required this.isTextMessageEmpty,
  }) : super(key: key);

  final Size size;
  final TextEditingController messageController;
  final FocusNode? focusNode;
  final Function onSendBtnPressed;
  final Function? onChange;
  final bool isTextMessageEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kChatControllerHeight,
      // constraints: const BoxConstraints(
      //   minHeight: kChatControllerHeight,
      // ),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            alignment: Alignment.center,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onPressed: () {},
            icon: const Icon(
              Icons.face_retouching_natural,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              // constraints: BoxConstraints(
              //   minHeight: kChatControllerHeight,
              // ),
              height: kChatControllerHeight - 10,
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(40)),
              // margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                style: const TextStyle(color: kPrimaryColor),
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.left,
                // minLines: null,
                maxLines: null,
                textInputAction: TextInputAction.next,
                // expands: true,

                onChanged: (string) =>
                    onChange != null ? onChange!(string) : () {},
                focusNode: focusNode,
                controller: messageController,
                decoration: InputDecoration(
                  // isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(.55),
                  ),
                  hintText: "Enter message",
                ),
              ),
            ),
          ),
          IconButton(
            alignment: Alignment.center,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onPressed: () => !isTextMessageEmpty ? onSendBtnPressed() : null,
            icon: Icon(
              Icons.send,
              color: isTextMessageEmpty ? Colors.grey : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
