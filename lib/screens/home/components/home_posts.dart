import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/screens/home/components/post_entry.dart';
import 'package:traveling_social_app/screens/story/story_card.dart';
import 'package:traveling_social_app/view_model/story_viewmodel.dart';

class HomePost extends StatefulWidget {
  const HomePost({Key? key}) : super(key: key);

  @override
  State<HomePost> createState() => _HomePostState();
}

class _HomePostState extends State<HomePost> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      print('duy');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryViewModel>(
      builder: (context, value, child) {
        // return Column(
        //   children: [
        //     ...List.generate(value.stories.length + 1, (index) {
        //       if (index == value.stories.length) {
        //         return const CupertinoActivityIndicator();
        //       }
        //       return PostEntry(
        //         post: value.stories[index],
        //         key: ValueKey(value.stories[index].id),
        //       );
        //     })
        //   ],
        // );
        return SliverList(delegate: SliverChildBuilderDelegate(
                (context, index) => PostEntry(post: value.stories[index]),
            childCount: value.stories.length
        ),);
      },
    );
  }
}
