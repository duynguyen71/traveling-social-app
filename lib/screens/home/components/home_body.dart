import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/home/components/add_story_card.dart';
import 'package:traveling_social_app/screens/home/components/custom_tab_title.dart';
import 'package:traveling_social_app/screens/home/components/home_stories.dart';
import 'package:traveling_social_app/screens/home/components/post_entry.dart';
import 'package:traveling_social_app/screens/home/components/search_section.dart';
import 'package:traveling_social_app/screens/story/story_card.dart';
import 'package:traveling_social_app/screens/home/components/trending_post.dart';
import 'package:traveling_social_app/screens/story/stories_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/post_viewmodel.dart';
import 'package:traveling_social_app/widgets/heading_with_icon.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      // reverse: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SEARCH SECTION
          const SearchSection(),
          const SizedBox(
            height: 10,
          ),
          //TAB BAR
          Align(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: size.width * .8,
              decoration: BoxDecoration(boxShadow: [kDefaultShadow]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTabTitle(
                    iconData: Icons.explore,
                    label: "Explore",
                    onTap: () {
                      // Timer(Duration(milliseconds: 500), () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => ExploreScreen()));
                      // });
                    },
                    // count: '',
                  ),
                  CustomTabTitle(
                    iconData: Icons.message,
                    label: "Messages",
                    onTap: () {
                      // Timer(Duration(milliseconds: 500), () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => InBoxScreen()));
                      // });
                    },
                    // count: "2",
                  ),
                  CustomTabTitle(
                    iconData: Icons.reviews,
                    label: "Blog",
                    onTap: () {
                      // Timer(Duration(milliseconds: 500), () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => BlogScreen()));
                      // });
                    },
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              child: Divider(
                color: kPrimaryColor.withOpacity(.8),
              ),
              width: size.width * .8,
            ),
          ),
          //STORY

          const HomeStories(),
          //  Trending

          //POSTS
          Column(
            // mainAxisSize: MainAxisSize.max,
            children: [],
          ),
          //TRENDING POST
          Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                const HeadingWithIcon(
                    icon: Icons.trending_up, title: "Trending post"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TrendingPost(),
                    TrendingPost(),
                    TrendingPost(),
                    TrendingPost(),
                    TrendingPost(),
                    TrendingPost(),
                    TrendingPost(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
