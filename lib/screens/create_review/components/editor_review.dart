import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import 'package:traveling_social_app/my_theme.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_gallery_view.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_image_container.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_title.dart';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';

import '../../../bloc/review/creation_review_cubit.dart';
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // height: size.height * .95,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  // Cover image
                  BlocBuilder<CreateReviewPostCubit, CreateReviewPostState>(
                    builder: (context, state) {
                      return CoverImageContainer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: kReviewPostBorderRadius,
                            color: Colors.grey.shade200,
                            image: state.post.coverImage == null
                                ? null
                                : DecorationImage(
                                    image: FileImage(
                                      File(state.post.coverImage!.path!),
                                    ),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    onError: (_, stack) {
                                      context
                                          .read<CreateReviewPostCubit>()
                                          .updateReviewPost(coverImage: null);
                                    }),
                          ),
                        ),
                      );
                    },
                  ),
                  // Post title
                  ReviewPostTitle(
                      title: context
                          .read<CreateReviewPostCubit>()
                          .state
                          .post
                          .title
                          .toString()),
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
                  SizedBox(
                    height: 140,
                    child: BlocBuilder<CreateReviewPostCubit,
                        CreateReviewPostState>(
                      builder: (context, state) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.post.images.length,
                          itemBuilder: (BuildContext context, int index) {
                            var image = state.post.images[index];
                            return ReviewPostImageContainer(
                                onErr: () {},
                                image: image.file,
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
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * .2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
