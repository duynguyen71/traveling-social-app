import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/screens/story/story_full_screen.dart';
import 'package:traveling_social_app/view_model/post_viewmodel.dart';

class StoriesScrollScreen extends StatefulWidget {
  const StoriesScrollScreen({Key? key, this.initialIndex = 0})
      : super(key: key);

  final int initialIndex;

  @override
  _StoriesScrollScreenState createState() => _StoriesScrollScreenState();
}

class _StoriesScrollScreenState extends State<StoriesScrollScreen>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _listController;

  late PostViewModel _postViewModel;

  @override
  void initState() {
    super.initState();
    _postViewModel = context.read<PostViewModel>();
    _listController = ScrollController(
        initialScrollOffset: _postViewModel.currentStoryIndex *
            MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
                .size
                .height);
  }

  late DragStartDetails startVerticalDragDetails;
  late DragUpdateDetails updateVerticalDragDetails;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        var currentStoryIndex = context.read<PostViewModel>().currentStoryIndex;
        double dx = updateVerticalDragDetails.globalPosition.dx -
            startVerticalDragDetails.globalPosition.dx;
        double dy = updateVerticalDragDetails.globalPosition.dy -
            startVerticalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity!;

        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        //Swiping UP
        int i = currentStoryIndex;
        var stories = context.read<PostViewModel>().stories;
        if (velocity < 0) {
          if (i < (stories.length - 1)) {
            print('swip up');
            i = i + 1;
            _listController.animateTo(
                double.parse((i * size.height).toString()),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInToLinear);
            context.read<PostViewModel>().setCurrentStoryIndex = i;
          }
        }
        //SWIPING DOWN
        if (velocity > 0) {
          if (i >= 1) {
            print('swip down');
            i = i - 1;
            _listController.animateTo(
                double.parse((i * size.height).toString()),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInToLinear);
            context.read<PostViewModel>().setCurrentStoryIndex = i;
          }
        }
      },
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            controller: _listController,
            itemBuilder: (context, index) {
              return StoryFullScreen(
                post: context.read<PostViewModel>().stories[index],
              );
            },
            itemCount: context.read<PostViewModel>().stories.length),
      ),
    );
  }

  @override
  void dispose() {
    _postViewModel.setCurrentStoryIndex = 0;
    _listController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
