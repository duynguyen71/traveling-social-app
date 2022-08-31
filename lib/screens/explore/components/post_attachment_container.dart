import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

import '../../../constants/api_constants.dart';
import '../../../models/attachment.dart';

class PostAttachmentContainer extends StatefulWidget {
  const PostAttachmentContainer({Key? key, required this.attachments})
      : super(key: key);

  @override
  State<PostAttachmentContainer> createState() =>
      _PostAttachmentContainerState();

  final List<Attachment> attachments;
}

class _PostAttachmentContainerState extends State<PostAttachmentContainer>
    with AutomaticKeepAliveClientMixin {
  int _attachmentIndex = 0;

  List<Attachment> get attachments => widget.attachments;

  set attachmentIndex(i) => setState(() => _attachmentIndex = i);

  double? _displayRatio;

  @override
  void initState() {
    super.initState();
    _getDisplayRadio();
  }

  _getDisplayRadio() async {
    if (!mounted) {
      return;
    }
    if (attachments.asMap().containsKey(0)) {
      var ratio = await ApplicationUtility.getRatio(attachments[0].name);
      if (ratio != null && ratio < 0.8) {
        setState(() {
          _displayRatio = .8;
        });
      } else {
        setState(() {
          _displayRatio = ratio;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_displayRatio == null) {
      return const SizedBox.shrink();
    } else {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: _displayRatio!,
            child: PageView.builder(
              allowImplicitScrolling: true,
              onPageChanged: (index) {
                setState(() => _attachmentIndex = index);
              },
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '$imageUrl${attachments[index].name}',
                  alignment: Alignment.center,
                  placeholder: (context, url) {
                    return AspectRatio(
                      child: Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                      aspectRatio: _displayRatio!,
                    );
                  },
                  errorWidget: (context, url, error) => const SizedBox.shrink(),
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: attachments.length,
            ),
          ),
          attachments.length <= 1
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(attachments.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: AnimatedScale(
                        scale: _attachmentIndex == index ? 1.75 : 1,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _attachmentIndex == index
                                ? Colors.grey.shade400
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 4,
                          width: 4,
                        ),
                      ),
                    );
                  }),
                )
        ],
      );
    }
    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     //CONTENTS
    //     _displayRatio != null
    //         ? AspectRatio(
    //             aspectRatio: _displayRatio!,
    //             child: CachedNetworkImage(
    //               // fit: BoxFit.fitWidth,
    //               fit: BoxFit.cover,
    //               imageUrl: '$imageUrl${attachments[_attachmentIndex].name}',
    //               placeholder: (context, url) {
    //                 return AspectRatio(
    //                   child: Container(
    //                     color: Colors.grey.shade100,
    //                     child: const Center(
    //                       child: CupertinoActivityIndicator(),
    //                     ),
    //                   ),
    //                   aspectRatio: _displayRatio!,
    //                 );
    //               },
    //               errorWidget: (context, url, error) => const SizedBox.shrink(),
    //             ),
    //           )
    //         : const SizedBox.shrink(),
    //     attachments.length > 1
    //         ? Positioned(
    //             child: RoundedIconButton(
    //               onClick: () {
    //                 if (_attachmentIndex < attachments.length - 1) {
    //                   attachmentIndex = _attachmentIndex + 1;
    //                 }
    //               },
    //               icon: Icons.arrow_forward_ios,
    //               iconColor:
    //                   _attachmentIndex < 1 ? Colors.black12 : Colors.white,
    //               size: 20,
    //             ),
    //             right: 10,
    //           )
    //         : const SizedBox.shrink(),
    //     attachments.length > 1
    //         ? Positioned(
    //             child: RoundedIconButton(
    //               onClick: () {
    //                 if (_attachmentIndex >= 1) {
    //                   attachmentIndex = _attachmentIndex - 1;
    //                 }
    //               },
    //               icon: Icons.arrow_back_ios,
    //               iconColor: _attachmentIndex <= (attachments.length - 1)
    //                   ? Colors.black12
    //                   : Colors.white,
    //               size: 20,
    //             ),
    //             left: 10,
    //           )
    //         : const SizedBox.shrink(),
    //     attachments.length > 1
    //         ? Positioned(
    //             right: 10,
    //             top: 10,
    //             child: Container(
    //               padding:
    //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //               decoration: BoxDecoration(
    //                 color: Colors.black87.withOpacity(.3),
    //                 borderRadius: BorderRadius.circular(20),
    //               ),
    //               child: RichText(
    //                 text: TextSpan(children: [
    //                   TextSpan(text: '${_attachmentIndex + 1}'),
    //                   TextSpan(text: ' / ${attachments.length}')
    //                 ], style: const TextStyle(color: Colors.white)),
    //               ),
    //             ),
    //           )
    //         : const SizedBox.shrink()
    //   ],
    // );
  }

  @override
  bool get wantKeepAlive => true;
}
