import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:traveling_social_app/models/post_content.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

class StoryCard extends StatefulWidget {
  const StoryCard({Key? key, required this.story, required this.onClick})
      : super(key: key);

  final Post story;
  final Function onClick;

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard>
    with AutomaticKeepAliveClientMixin {
  String? _imageName;
  double? _displayRatio;
  List<Color> _colors = [
    Colors.black38,
    Colors.black87,
  ];

  @override
  void initState() {
    super.initState();
    print('init state story card: ${widget.story.id}');
    _imageName =
        (contents.asMap().containsKey(0) ? contents[0].attachment?.name : null);
    if (_imageName != null) {
      _getImageRatio();
    }
  }

  _getImageRatio() async {
    var ratio = await ApplicationUtility.getRatio(_imageName);
    setState(() {
      _displayRatio = ratio;
    });
  }

  _getColors() async {
    var paletteGenerator =
        await ApplicationUtility.getPaletteGenerator(_imageName);
    if (paletteGenerator == null) return;
    var colors = paletteGenerator.colors;
    setState(() {
      _colors = [...colors];
    });
  }

  List<Content> get contents => widget.story.contents ?? [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onClick(),
          child: Ink(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(colors: _colors, radius: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: _displayRatio != null
                            ? DecorationImage(
                                fit: (_displayRatio! > 1)
                                    ? BoxFit.fitWidth
                                    : BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    '$imageUrl$_imageName'),
                              )
                            : null,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: (widget.story.caption.toString().isNotEmpty &&
                              _imageName == null)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  widget.story.caption.toString(),
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : const SizedBox.expand(),
                    ),
                  ),
                  //AVT
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: UserAvatar(
                      size: 25,
                      avt: '${widget.story.user!.avt}',
                      onTap: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
