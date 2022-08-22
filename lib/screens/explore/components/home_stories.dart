import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/bloc/story/story_bloc.dart';
import 'package:traveling_social_app/screens/story/stories_scroll_screen.dart';
import 'package:traveling_social_app/screens/story/story_card.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

class HomeStories extends StatefulWidget {
  const HomeStories({Key? key}) : super(key: key);

  @override
  State<HomeStories> createState() => _HomeStoriesState();
}

class _HomeStoriesState extends State<HomeStories>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<StoryBloc>().add(const FetchStory());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: Colors.grey.shade200),
                bottom: BorderSide(color: Colors.grey.shade200))),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, state) {
            var stories = state.stories;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: size.height*.35,
                  constraints: BoxConstraints(
                    minHeight: size.height*.35
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (_) {
                      if (_.metrics.pixels == _.metrics.maxScrollExtent) {
                        context.read<StoryBloc>().add(const FetchStory());
                        return true;
                      }
                      return false;
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == stories.length) {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: state.status == StoryStateStatus.fetching
                                  ? const CupertinoActivityIndicator()
                                  : const SizedBox.shrink(),
                            ),
                          );
                        }
                        var story = stories.elementAt(index);
                        return StoryCard(
                            key: ValueKey(story.id),
                            story: story,
                            onClick: () {
                              context
                                  .read<StoryBloc>()
                                  .add(UpdateScrollIndex(index));
                              ApplicationUtility.navigateToScreen(
                                  context, const StoriesScrollScreen());
                            });
                      },
                      itemCount: stories.length + 1,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
