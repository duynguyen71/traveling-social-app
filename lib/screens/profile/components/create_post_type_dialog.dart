import 'package:flutter/material.dart';

import '../../../utilities/application_utility.dart';
import '../../create_post/create_post_screen.dart';
import '../../create_story/create_story_screen.dart';
class CreatePostTypeDialog extends StatelessWidget {
  const CreatePostTypeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ApplicationUtility.navigateToScreen(
                              context, const CreatePostScreen());
                        },
                        child: const Text('Create post'))),
                const SizedBox(child: Divider()),
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ApplicationUtility.navigateToScreen(
                              context, const CreateStoryScreen());
                        },
                        child: const Text('Create story')))
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
              Text("Cancel", style: TextStyle(color: Colors.red[300])),
            ),
          )
        ],
      ),
    );
  }
}
