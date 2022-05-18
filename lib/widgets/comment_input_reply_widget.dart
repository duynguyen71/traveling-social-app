import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/models/User.dart';

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
      required this.replyUser,
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
  final User? replyUser;
  final String? message;
  final Function onClose;
  final bool showReplyUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                  text:
                                      'Reply to ${replyUser!.username.toString()}: ',style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),),
                              TextSpan(
                                text: ' ${message.toString()}',
                                style: const TextStyle(
                                            color: Colors.black54,
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
                  onChanged: (text) => onChange(text),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
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
        ),
      ],
    );
  }
}
