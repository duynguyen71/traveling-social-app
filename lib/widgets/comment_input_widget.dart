import 'package:flutter/material.dart';


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
      this.controller, this.focusNode})
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .1,
      constraints: const BoxConstraints(maxHeight: 80),
      alignment: Alignment.center,
      width: size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: bgColor ?? Colors.grey.shade100,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(.1),
              width: 1,
            ),
          ),
          borderRadius: borderRadius),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: controller,
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
                  hintStyle:
                      TextStyle(color: placeHolderColor ?? Colors.black54),
                  hintText: placeHolderText ?? "Type in your text",
                  fillColor: inputBgColor ?? Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.send,
              color: sendBtnColor ?? Colors.black12,
            ),
            onPressed: () => onSendButtonClick(),
          ),
        ],
      ),
    );
  }
}
