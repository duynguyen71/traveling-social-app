import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/create_story/create_story_screen.dart';
import 'package:traveling_social_app/screens/story/stories_scroll_screen.dart';
import 'package:traveling_social_app/screens/story/story_card.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/story_view_model.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ApplicationUtility.navigateToScreen(
                context, const CreateStoryScreen());
          },
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
              // Consumer<StoryViewModel>(builder: (context, value, child) {
              //   var stories = value.stories;
              //   return SliverGrid(
              //     delegate: SliverChildListDelegate(
              //       stories
              //           .map(
              //             (e) => StoryCard(
              //               story: e,
              //               onClick: () => Navigator.push(
              //                   context, StoriesScrollScreen.route()),
              //               key: ValueKey(e.id),
              //             ),
              //           )
              //           .toList(),
              //     ),
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 3,
              //       mainAxisSpacing: 10,
              //       crossAxisSpacing: 10,
              //       // childAspectRatio: 9/16,
              //       childAspectRatio: 10 / 14,
              //     ),
              //   );
              // }),
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
