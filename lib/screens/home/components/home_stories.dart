import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/story/stories_screen.dart';
import 'package:traveling_social_app/screens/story/stories_scroll_screen.dart';
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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<PostViewModel>().updateStories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              NotificationListener<ScrollEndNotification>(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      const AddStoryCard(),
                      ...List.generate(
                        stories.length + 1,
                        (index) {
                          if (index == stories.length) {
                            return const SizedBox(
                                width: 100,
                                child: CupertinoActivityIndicator());
                          }
                          return StoryCard(
                            story: stories[index],
                            onClick: () {
                              context.read<PostViewModel>().setCurrentStoryIndex = index;
                              ApplicationUtility.navigateToScreen(
                                context,
                                StoriesScrollScreen(
                                  initialIndex: index,
                                ),
                              );
                            },
                            // key: ValueKey(stories[index].id),
                          );
                        },
                        // growable: true,
                      ),
                    ],
                  ),
                ),
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if (metrics.atEdge) {
                    bool isTop = metrics.pixels == 0;
                    if (isTop) {
                    } else {
                      // context.read<PostViewModel>().updateStories();
                    }
                  }
                  return true;
                },
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
