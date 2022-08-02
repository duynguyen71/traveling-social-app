import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/bloc/story/story_bloc.dart';
import 'package:traveling_social_app/screens/story/story_full_screen.dart';

class StoriesScrollScreen extends StatefulWidget {
  const StoriesScrollScreen({Key? key}) : super(key: key);

  @override
  _StoriesScrollScreenState createState() => _StoriesScrollScreenState();
}

class _StoriesScrollScreenState extends State<StoriesScrollScreen>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _listController;

  @override
  void initState() {
    super.initState();
    // _storyViewModel = context.read<StoryViewModel>();
    int currentStoryIndex = context.read<StoryBloc>().state.currentScrollIndex;
    _listController = ScrollController(
        initialScrollOffset: currentStoryIndex *
            MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .size
                .height);
    _listController.addListener(() {
      var pixels2 = _listController.position.pixels;
      var maxScrollExtent2 = _listController.position.maxScrollExtent;
      if ((maxScrollExtent2 - pixels2) <=
          MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .size
              .height) {
        context.read<StoryBloc>().add(FetchStory());
      }
    });
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
      onVerticalDragEnd: (endDetails) async {
        int currentStoryIndex =
            context.read<StoryBloc>().state.currentScrollIndex;
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
        var stories = context.read<StoryBloc>().state.stories;
        if (velocity < 0) {
          if (i < (stories.length - 1)) {
            i = i + 1;
            _listController.animateTo(
                double.parse((i * size.height).toString()),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInToLinear);
            context.read<StoryBloc>().add(UpdateScrollIndex(i));
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
            context.read<StoryBloc>().add(UpdateScrollIndex(i));
          }
        }
      },
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: BlocBuilder<StoryBloc, StoryState>(
          buildWhen: (previous, current) =>
              current.stories.length > previous.stories.length,
          builder: (context, state) {
            print('build scroll screens');
            return ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                controller: _listController,
                itemBuilder: (context, index) {
                  return StoryFullScreen(
                    post: context
                        .read<StoryBloc>()
                        .state
                        .stories
                        .elementAt(index),
                  );
                },
                itemCount: state.stories.length);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
