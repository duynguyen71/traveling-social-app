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
    this.onSubmitted,
    required this.isTextMessageEmpty,
  }) : super(key: key);

  final Size size;
  final TextEditingController messageController;
  final FocusNode? focusNode;
  final Function onSendBtnPressed;
  final Function(String str)? onChange;
  final Function(String value)? onSubmitted;
  final bool isTextMessageEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
          color: kPrimaryColor,
          border: Border(
            top: BorderSide(color: kPrimaryLightColor, width: 1),
          )),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              constraints: const BoxConstraints(maxHeight: 200),
              child: TextField(
                style: const TextStyle(color: kPrimaryColor, fontSize: 14),
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.left,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: onSubmitted,
                onChanged: onChange,
                focusNode: focusNode,
                controller: messageController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  isCollapsed: true,
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.all(8.0),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(.55),
                    fontSize: 14,
                  ),
                  hintText: "Enter message",
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextButton(
              onPressed: () => isTextMessageEmpty ? null : onSendBtnPressed(),
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size.fromRadius(10),
              ),
              child: Icon(
                Icons.send,
                color: isTextMessageEmpty ? Colors.grey : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
