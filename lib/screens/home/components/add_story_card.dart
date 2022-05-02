import 'dart:async';

import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/create_story/create_story_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

class AddStoryCard extends StatelessWidget {
  const AddStoryCard({Key? key}) : super(key: key);

  _handleAddStory(BuildContext context) {
    ApplicationUtility.navigateToScreen(context, const CreateStoryScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      constraints: const BoxConstraints(
        minHeight: 180,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.all(5),
      color: Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: kPrimaryLightColor.withOpacity(.2),
          onTap: () {
            Timer(const Duration(milliseconds: 500),
                () => _handleAddStory(context));
          },
          child: Ink(
            color: Colors.black12,
            child: AspectRatio(
              aspectRatio: 9 / 16,
              // aspectRatio: 9 / 14,
              // aspectRatio: 10 / 14,
              // aspectRatio:1.91/1,
              //BUTTON ADD STORY
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: const Icon(Icons.add, color: kPrimaryLightColor,size: 26,),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
