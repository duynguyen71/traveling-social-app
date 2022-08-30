import 'package:flutter/material.dart';

import '../constants/app_theme_constants.dart';

class CommentInputWidget extends StatelessWidget {
  const CommentInputWidget(
      {Key? key,
      required this.onSendButtonClick,
      this.placeHolderText,
      this.inputBorderRadius,
      this.borderRadius,
      this.bgColor,
      this.placeHolderColor,
      this.inputBorderColor,
      this.inputBgColor,
      this.sendBtnColor,
      this.controller,
      this.focusNode,
      required this.onChange})
      : super(key: key);

  final Function onSendButtonClick;
  final String? placeHolderText;
  final BorderRadius? inputBorderRadius;
  final BorderRadius? borderRadius;
  final Color? bgColor,
      placeHolderColor,
      inputBorderColor,
      inputBgColor,
      sendBtnColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: bgColor ?? Colors.grey.shade100,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          borderRadius: borderRadius),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              constraints: const BoxConstraints(maxHeight: 200),
              child: TextField(
                onChanged: (text) => onChange(text),
                focusNode: focusNode,
                controller: controller,
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.left,
                maxLines: null,
                textInputAction: TextInputAction.send,
                style: TextStyle(color: placeHolderColor ?? Colors.black87),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: inputBorderRadius ??
                          const BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          width: 1, color: inputBorderColor ?? Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          width: 1, color: inputBorderColor ?? Colors.white),
                    ),
                    filled: true,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.all(8.0),
                    hintStyle:
                        TextStyle(color: placeHolderColor ?? Colors.black54),
                    hintText: placeHolderText ?? "Type in your text",
                    fillColor: inputBgColor ?? Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.send,
              color: sendBtnColor ?? Colors.black54,
            ),
            onPressed: () => onSendButtonClick(),
          ),
        ],
      ),
    );
  }
}
