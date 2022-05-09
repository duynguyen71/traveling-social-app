import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/Content.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:palette_generator/palette_generator.dart';

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
  late PaletteGenerator paletteGenerator;
  List<Color>? gradientBgColors;

  String? image;

  @override
  void initState() {
    List<Content>? contents = widget.story.contents;
    if (contents != null && contents.isNotEmpty) {
      image = (contents[0].attachment?.name.toString());
    }
    // _updateGradientBgColors();
    super.initState();
  }

  _updateGradientBgColors() async {
    if (image != null) {
      paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.network(imageUrl + image!).image,
      );
      setState(() {
        gradientBgColors = paletteGenerator.colors.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 180,
      constraints: const BoxConstraints(
        minHeight: 180,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.all(5),
      child: AspectRatio(
        aspectRatio: 9 / 16,
        // aspectRatio: 9 / 14,
        // aspectRatio: 10 / 14,
        // aspectRatio:1.91/1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientBgColors ?? [Colors.black87, Colors.black54],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                border: Border.all(
                  color: kPrimaryLightColor.withOpacity(.5),
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => widget.onClick(),
                  splashColor: kPrimaryColor.withOpacity(.5),
                  //STORY IMAGE
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: image != null
                          ? DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: CachedNetworkImageProvider(
                                image != null
                                    ? (imageUrl + '$image')
                                    : 'https://images.pexels.com/photos/15286/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                              ),
                            )
                          : null,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: (widget.story.caption.toString().isNotEmpty &&
                            image == null)
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
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: UserAvatar(
                size: 25,
                user: widget.story.user!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
