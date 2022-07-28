import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/story/stories_screen.dart';
import 'package:traveling_social_app/screens/story/stories_scroll_screen.dart';
import 'package:traveling_social_app/screens/story/story_card.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/story_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeStories extends StatefulWidget {
  const HomeStories({Key? key}) : super(key: key);

  @override
  State<HomeStories> createState() => _HomeStoriesState();
}

class _HomeStoriesState extends State<HomeStories>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (context.read<StoryViewModel>().stories.isEmpty) {
      context.read<StoryViewModel>().fetchStories(pageSize: 5);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!context.read<StoryViewModel>().isLoading) {
          print("LOAD MORE STORIES");
          context.read<StoryViewModel>().updateStories();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Consumer<StoryViewModel>(
        builder: (context, value, child) {
          var stories = value.stories;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 180,
                child: Consumer<StoryViewModel>(
                  builder: (context, value, child) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (index == value.stories.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child: CupertinoActivityIndicator(),
                            ),
                          );
                        }
                        return StoryCard(
                            key: ValueKey(value.stories.elementAt(index).id),
                            story: value.stories.elementAt(index),
                            onClick: () {
                              context
                                  .read<StoryViewModel>()
                                  .setCurrentStoryIndex = index;
                              ApplicationUtility.navigateToScreen(
                                  context, const StoriesScrollScreen());
                            });
                      },
                      itemCount: value.stories.length + 1,
                      scrollDirection: Axis.horizontal,
                    );
                  },
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.showMore,
                                style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                  // decoration: TextDecoration.underline,
                                  // decorationThickness: 4,
                                ),
                              ),
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

  @override
  bool get wantKeepAlive => true;
}
