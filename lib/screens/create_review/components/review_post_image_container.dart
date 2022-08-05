import 'dart:io';

import 'package:flutter/material.dart';

import '../../../widgets/rounded_icon_button.dart';

class ReviewPostImageContainer extends StatelessWidget {
  const ReviewPostImageContainer(
      {Key? key,
      required this.onErr,
      required this.image,
      required this.onRemove,
    required  this.onTap})
      : super(key: key);

  final Function onErr;
  final File image;
  final Function onRemove;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          // height: 180,
          // constraints: const BoxConstraints(minHeight: 180),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 180,
                constraints: const BoxConstraints(minHeight: 180),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey.shade200,
                  image: DecorationImage(
                      image: FileImage(
                        image,
                      ),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      onError: (_, stack) {
                        onErr(_, stack);
                      }),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedIconButton(
                      onClick: () => onRemove(),
                      icon: Icons.remove_circle_outline,
                      size: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
