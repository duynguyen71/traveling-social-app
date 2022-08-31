

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/bloc/review/creation_review_cubit.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';

import '../../../dto/attachment_dto.dart';

class ReviewPostGalleryView extends StatefulWidget {
  const ReviewPostGalleryView({Key? key, this.initialIndex = 0})
      : super(key: key);

  final int initialIndex;

  @override
  State<ReviewPostGalleryView> createState() => _ReviewPostGalleryViewState();

  static Route route() =>
      MaterialPageRoute(builder: (_) => const ReviewPostGalleryView());
}

class _ReviewPostGalleryViewState extends State<ReviewPostGalleryView> {
  List<AttachmentDto> images = [];

  @override
  void initState() {
    super.initState();
    var copy = context.read<CreateReviewPostCubit>().state.post.images;
    copy.removeWhere((element) => element.status == 0);
    setState(() {
      images = copy;
    });
    var initialIndex = widget.initialIndex;
    _scrollController = ScrollController(
        initialScrollOffset: initialIndex *
            MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .size
                .width);
    currentScrollIndex = initialIndex;
  }

  late ScrollController _scrollController;

  int _currentScrollIndex = 0;

  set currentScrollIndex(int i) => setState(() => _currentScrollIndex = i);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black87.withOpacity(.8),
      width: MediaQuery.of(context).size.width,
      height: size.height,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // var images = state.post.images;
          var attachment = images[index];
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        image: attachment.id == null
                            ? FileImage(
                                attachment.file,
                              )
                            : NetworkImage('$imageUrl${attachment.name}')
                                as ImageProvider,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                        onError: (_, stack) {}),
                  ),
                ),
                Positioned(
                    child: RoundedIconButton(
                      onClick: () async {
                        if (index <= 0) return;
                        var i = index - 1;
                        await jumpTo(i, size);
                        currentScrollIndex = i;
                      },
                      icon: Icons.arrow_back_ios,
                      size: 25,
                    ),
                    left: 10),
                Positioned(
                  child: RoundedIconButton(
                      onClick: () async {
                        if (index >= images.length - 1) return;
                        var i = index + 1;
                        await jumpTo(i, size);
                        currentScrollIndex = i;
                      },
                      icon: Icons.arrow_forward_ios,
                      size: 25),
                  right: 10,
                ),
                Positioned(
                  bottom: 10,
                  child: OutlinedButton(
                      onPressed: () {},
                      child:
                          Text('${_currentScrollIndex + 1}/${images.length}')),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedIconButton(
                        onClick: () {
                          Navigator.pop(context);
                        },
                        icon: Icons.close,
                        size: 25),
                  ),
                  top: 20,
                  right: 10,
                )
              ],
            ),
          );
        },
        itemCount: images.length,
      ),
    );
  }

  Future<void> jumpTo(int i, Size size) async {
    await _scrollController.animateTo(
        double.parse(((i) * size.width).toString()),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInToLinear);
  }
}
