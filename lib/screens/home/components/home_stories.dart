import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/story/stories_screen.dart';
import 'package:traveling_social_app/screens/story/story_card.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/post_viewmodel.dart';

import 'add_story_card.dart';

class HomeStories extends StatefulWidget {
  const HomeStories({Key? key}) : super(key: key);

  @override
  State<HomeStories> createState() => _HomeStoriesState();
}

class _HomeStoriesState extends State<HomeStories> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var stories = context.select((PostViewModel p) => p.stories);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(8),
      child: Consumer<PostViewModel>(
        builder: (context, value, child) {
          var stories = value.stories;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const AddStoryCard(),
                    ...stories.map((e) => StoryCard(story: e, onClick: () {}))
                  ],
                ),
              ),
              stories.isNotEmpty && stories.length > 1
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ApplicationUtility.navigateToScreen(
                                context, const StoriesScreen());
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Show more',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
