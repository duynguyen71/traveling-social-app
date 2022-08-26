import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import 'package:traveling_social_app/dto/attachment_dto.dart';
import 'package:traveling_social_app/my_theme.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_gallery_view.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_image_container.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_tags.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_title.dart';
import 'package:traveling_social_app/screens/profile/components/icon_with_text.dart';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';

import '../../../bloc/review/creation_review_cubit.dart';
import '../../../constants/api_constants.dart';
import '../../../constants/app_theme_constants.dart';
import 'cover_image_container.dart';

class EditorReview extends StatefulWidget {
  const EditorReview({Key? key, required this.controller}) : super(key: key);
  final quill.QuillController controller;

  @override
  State<EditorReview> createState() => _EditorReviewState();
}

class _EditorReviewState extends State<EditorReview> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var post = context.read<CreateReviewPostCubit>().state.post;
    return DraggableScrollableSheet(
      initialChildSize: .9,
      minChildSize: 0.6,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedIconButton(
                      onClick: () => Navigator.pop(context),
                      icon: Icons.close,
                      size: 30),
                ),
              ),
              // COVER IMAGE
              CoverImageContainer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: kReviewPostBorderRadius,
                    color: Colors.grey.shade200,
                    image: post.coverPhoto == null
                        ? null
                        : DecorationImage(
                            image: post.coverPhoto?.id == null
                                ? FileImage(
                                    File(post.coverPhoto!.path!),
                                  )
                                : NetworkImage(
                                        '$imageUrl${post.coverPhoto?.name}')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            onError: (_, stack) {
                              context
                                  .read<CreateReviewPostCubit>()
                                  .updateReviewPost(coverImage: null);
                            }),
                  ),
                ),
              ),

              //, Post title
              ReviewPostTitle(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  title: post.title.toString()),
              // aditional infomation
              Row(
                children: [
                  IconTextButton(
                      text: '${post.numOfParticipant}',
                      icon: Icon(
                        Icons.group,
                        color: Colors.black54,
                      )),
                  const SizedBox(width: 10),
                  IconTextButton(
                      text: '${post.cost}',
                      icon: Icon(
                        Icons.monetization_on,
                        color: Colors.black54,
                      )),
                  const SizedBox(width: 10),
                  IconTextButton(
                      text: '${post.totalDay} days',
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.black54,
                      )),
                ],
              ),
              // post content
              quill.QuillEditor.basic(
                controller: widget.controller,
                readOnly: true, // true for view only mode
              ),
              // post images
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Images: ',
                  style: MyTheme.heading2,
                ),
              ),
              // Tags
              ReviewPostTags(
                tags: post.tags,
                onTap: (tag) {},
              ),
              // Images
              SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: post.images.length,
                    itemBuilder: (BuildContext context, int index) {
                      var image = post.images[index];
                      return ReviewPostImageContainer(
                          onErr: () {},
                          image: image,
                          onRemove: () {},
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ReviewPostGalleryView(
                                initialIndex: index,
                              ),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          });
                    },
                  )),
              SizedBox(
                height: size.height * .2,
              ),
            ],
          ),
        );
      },
    );
  }
}
