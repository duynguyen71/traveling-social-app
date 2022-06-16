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
  }) : super(key: key);

  final Size size;
  final TextEditingController messageController;
  final FocusNode? focusNode;
  final Function onSendBtnPressed;
  final Function? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 56,
      constraints: const BoxConstraints(
        minHeight: 56,
      ),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: size.width * .8,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (string) =>
                    onChange != null ? onChange!(string) : () {},
                focusNode: focusNode,
                controller: messageController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  // border: InputBorder.none,
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
            onPressed: () {},
            icon: const Icon(
              Icons.face_retouching_natural,
              color: Colors.white,
            ),
          ),
          IconButton(
            alignment: Alignment.center,
            onPressed: () => onSendBtnPressed(),
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
