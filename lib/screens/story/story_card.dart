import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/Post.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:palette_generator/palette_generator.dart';

class StoryCard extends StatefulWidget {
  const StoryCard({Key? key, this.image, required this.story, required this.onClick}) : super(key: key);

  final String? image;
  final Post story;
  final Function onClick;

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  late PaletteGenerator paletteGenerator;
  List<String> images = [
    'https://images.pexels.com/photos/4101555/pexels-photo-4101555.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/4507967/pexels-photo-4507967.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/4101555/pexels-photo-4101555.jpeg?auto=compress&cs=tinysrgb&w=600',
  ];
  int _selectedIndex = 1;
  String? _currentImg;

  @override
  void initState() {
    _getItemAtCurrentIndex();
    super.initState();
  }

  _getItemAtCurrentIndex() {
    Map<int, String> map = images.asMap();
    for (var idx in map.keys) {
      // print('idx: $idx --> ${map[idx]}');
      if (idx == _selectedIndex) {
        setState(() {
          _currentImg = map[idx];
        });
        return map[idx];
      }
    }
    return null;
  }

  Future<PaletteGenerator?> _updatePaletteGenerator() async {
    if (_currentImg != null) {
      paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.network(_currentImg!).image,
      );
      return paletteGenerator;
    }
    return null;
  }

  nextImage() {
    if (_selectedIndex < images.length - 1) {
      setState(() {
        _selectedIndex += 1;
      });
      _getItemAtCurrentIndex();
    }
  }

  prevImages() {
    if (images.length > 1 && _selectedIndex != 0) {
      setState(() {
        _selectedIndex -= 1;
      });
      _getItemAtCurrentIndex();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // width: size.width * 0.3,
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
            FutureBuilder<PaletteGenerator?>(
                future: _updatePaletteGenerator(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var colors = snapshot.data?.colors.toList();
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kPrimaryLightColor.withOpacity(.5),
                          // color: colors?.first != null
                          //     ? colors!.first
                          //     : Colors.black26,
                          width: 1,
                        ),

                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        gradient: LinearGradient(
                          colors: (colors != null && colors.isNotEmpty)
                              ? colors
                              : [Colors.black87, Colors.black54],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => widget.onClick(),
                          splashColor: kPrimaryColor.withOpacity(.5),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(
                                    'https://images.pexels.com/photos/15286/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Material(
                    color: Colors.black12,
                    child: Container(),
                  );
                }),
            const Positioned(
              bottom: 10,
              right: 10,
              child: UserAvatar(size: 25),
            ),
          ],
        ),
      ),
    );
  }
}
