import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:traveling_social_app/widgets/rounded_icon_button.dart';

import '../../../constants/api_constants.dart';
import '../../../models/Review_post_attachment.dart';

class ReviewPostAttachmentScrollView extends StatefulWidget {
  const ReviewPostAttachmentScrollView(
      {Key? key, this.initialIndex = 0, required this.attachments})
      : super(key: key);

  final int initialIndex;
  final List<ReviewPostAttachment> attachments;

  @override
  State<ReviewPostAttachmentScrollView> createState() =>
      _ReviewPostAttachmentState();

  static Route route() => MaterialPageRoute(
      builder: (_) => const ReviewPostAttachmentScrollView(
            attachments: [],
          ));
}

class _ReviewPostAttachmentState extends State<ReviewPostAttachmentScrollView> {
  @override
  void initState() {
    super.initState();
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

  List<ReviewPostAttachment> get attachments => widget.attachments;

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
            var att = widget.attachments[index];
            return Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: '$imageUrl${att.image!.name}',
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
                          if (index >= attachments.length - 1) return;
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
                        child: Text(
                            '${_currentScrollIndex + 1}/${attachments.length}')),
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
          itemCount: attachments.length,
        ));
  }

  Future<void> jumpTo(int i, Size size) async {
    await _scrollController.animateTo(
        double.parse(((i) * size.width).toString()),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInToLinear);
  }
}
