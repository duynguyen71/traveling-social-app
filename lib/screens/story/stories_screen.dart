import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/screens/story/stories_scroll_screen.dart';
import 'package:traveling_social_app/screens/story/story_card.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/post_viewmodel.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {

  @override
  void initState() {
    context.read<PostViewModel>().fetchStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          elevation: 1,
          backgroundColor: kPrimaryLightColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          splashColor: kPrimaryColor,
        ),
        // body: GridView(gridDelegate: gridDelegate),
        body: Container(
          width: size.width,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          child: CustomScrollView(
            slivers: [
              const SliverPadding(padding: EdgeInsets.only(top: 10)),
              Consumer<PostViewModel>(builder: (context, value, child) {
                List<Post> stories = value.stories;
                return stories.isNotEmpty
                    ? SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return StoryCard(
                            key: Key(index.toString()),
                            story: stories[index],
                            onClick: () {
                              ApplicationUtility.navigateToScreen(
                                  context, const StoriesScrollScreen());
                            },
                          );
                        }, childCount: stories.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          // childAspectRatio: 9/16,
                          childAspectRatio: 10 / 14,
                        ),
                      )
                    : const SliverToBoxAdapter(child: SizedBox.shrink());
              }),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      // elevation: 0,
      elevation: .5,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.black26,
        iconSize: 24.0,
      ),
    );
  }
}
