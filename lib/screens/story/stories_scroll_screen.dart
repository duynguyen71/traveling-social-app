import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/screens/story/story_full_screen.dart';
import 'package:traveling_social_app/view_model/post_viewmodel.dart';

class StoriesScrollScreen extends StatefulWidget {
  const StoriesScrollScreen({Key? key}) : super(key: key);

  @override
  _StoriesScrollScreenState createState() => _StoriesScrollScreenState();
}

class _StoriesScrollScreenState extends State<StoriesScrollScreen> {
  final _listController = ScrollController();

  late List<Post> stories;
  late PostViewModel _postViewModel;

  @override
  void initState() {
    print('SCROLL SCREEN INIT');
    _postViewModel = context.read<PostViewModel>();
    stories = _postViewModel.stories;
    super.initState();
  }

  late DragStartDetails startVerticalDragDetails;
  late DragUpdateDetails updateVerticalDragDetails;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        var currentStoryIndex = _postViewModel.currentStoryIndex;
        print('CURRENT STORY INDEX $currentStoryIndex');
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
        if (velocity < 0) {
          if (i < (stories.length - 1)) {
            i = i + 1;
            _listController.animateTo(
                double.parse((i * size.height).toString()),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInToLinear);
            _postViewModel.setCurrentStoryIndex = i;
          }
        }
        //SWIPING DOWN
        if (velocity > 0) {
          if (i >= 1) {
            i = i - 1;
            _listController.animateTo(
                double.parse((i * size.height).toString()),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInToLinear);
            _postViewModel.setCurrentStoryIndex = i;
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
                post: stories[_postViewModel.currentStoryIndex],
              );
            },
            itemCount: stories.length),
      ),
    );
  }

  @override
  void dispose() {
    _postViewModel.setCurrentStoryIndex = 0;
    _listController.dispose();
    super.dispose();
  }
}
