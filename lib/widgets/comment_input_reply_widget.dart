import 'package:flutter/material.dart';

class CommentInputReplyWidget extends StatelessWidget {
  const CommentInputReplyWidget(
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
      required this.onChange,
      required this.replyUsername,
      required this.onClose,
      required this.showReplyUser,
      this.message})
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
  final String? replyUsername;
  final String? message;
  final Function onClose;
  final bool showReplyUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? Colors.grey.shade100,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      alignment: Alignment.center,
      // height: 65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          showReplyUser
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withOpacity(.2),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  alignment: Alignment.centerLeft,
                  width: size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: size.width * .7,
                          constraints: BoxConstraints(
                            maxWidth: size.width * .7,
                          ),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Reply to $replyUsername: ',
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: ' ${message.toString()}',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => onClose(),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Container(
            // constraints: const BoxConstraints(maxHeight: 60),
            alignment: Alignment.center,
            width: size.width,
            decoration: BoxDecoration(
                color: bgColor ?? Colors.grey.shade100,
                borderRadius: borderRadius),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: false,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autofocus: false,
                      minLines: 1,
                      onChanged: (text) => onChange(text),
                      focusNode: focusNode,
                      controller: controller,
                      style: TextStyle(
                          color: placeHolderColor ?? Colors.black87,
                          fontSize: 14),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: inputBorderRadius ??
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              width: 1,
                              color: inputBorderColor ?? Colors.white),
                        ),
                        isCollapsed: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              width: 1,
                              color: inputBorderColor ?? Colors.white),
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        hintStyle: TextStyle(
                            color: placeHolderColor ?? Colors.black54,
                            fontSize: 14),
                        hintText: placeHolderText ?? "Type in your text",
                        fillColor: inputBgColor ?? Colors.white,
                      ),
                    ),
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
          ),
        ],
      ),
    );
  }
}
