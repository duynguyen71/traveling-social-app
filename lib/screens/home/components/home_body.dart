import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/home/components/custom_tab_title.dart';
import 'package:traveling_social_app/screens/home/components/home_stories.dart';
import 'package:traveling_social_app/screens/home/components/search_section.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
            // decoration: BoxDecoration(boxShadow: [kDefaultShadow]),
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

                  },
                ),
                CustomTabTitle(
                  iconData: Icons.reviews,
                  label: "Blog",
                  onTap: () {
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
        //POSTS

        //TRENDING POST
        // Container(
        //   padding: const EdgeInsets.all(5),
        //   child: Column(
        //     children: [
        //       const HeadingWithIcon(
        //           icon: Icons.trending_up, title: "Trending post"),
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: const [
        //           TrendingPost(),
        //           TrendingPost(),
        //           TrendingPost(),
        //           TrendingPost(),
        //           TrendingPost(),
        //           TrendingPost(),
        //           TrendingPost(),
        //         ],
        //       )
        //     ],
        //   ),
        // )
      ],
    );
  }
}
