import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveling_social_app/bloc/review/creation_review_cubit.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/dto/attachment_dto.dart';
import 'package:traveling_social_app/my_theme.dart';
import 'package:traveling_social_app/screens/create_review/components/cover_image_container.dart';
import 'package:traveling_social_app/screens/create_review/components/day_cost_input_dialog.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_gallery_view.dart';
import 'package:traveling_social_app/screens/create_review/pick_tags_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/my_outline_button.dart';
import 'package:traveling_social_app/widgets/my_text_icon_button.dart';
import 'package:traveling_social_app/widgets/tap_effect_widget.dart';
import '../../../services/post_service.dart';
import 'review_post_image_container.dart';

class ReviewPostEditor extends StatefulWidget {
  const ReviewPostEditor(
      {Key? key,
      required this.controller,
      required this.titleController,
      required this.tagController})
      : super(key: key);
  final quill.QuillController controller;
  final TextEditingController titleController;
  final TextEditingController tagController;

  @override
  State<ReviewPostEditor> createState() => _ReviewPostEditorState();
}

class _ReviewPostEditorState extends State<ReviewPostEditor> {
  final ImagePicker _imagePicker = ImagePicker();

  final ImageCropper _imageCropper = ImageCropper();

  _addToReviewImageGallery(String? path, int pos) {
    try {
      context
          .read<CreateReviewPostCubit>()
          .updateStatus(ReviewPostStatus.loadingCoverImage);
      CreateReviewPostCubit bloc = context.read<CreateReviewPostCubit>();
      if (path == null) return;
      var images = [...bloc.state.post.images];
      images.add(AttachmentDto(path: path, pos: pos));
      bloc.updateReviewPost(images: images);
    } on Exception catch (e) {
    } finally {
      context
          .read<CreateReviewPostCubit>()
          .updateStatus(ReviewPostStatus.success);
    }
  }

  _removeImageFromGallery(int index) {
    var images = [...context.read<CreateReviewPostCubit>().state.post.images];
    images.removeAt(index);
    context.read<CreateReviewPostCubit>().updateReviewPost(images: images);
  }

  Future<String?> _compress(File? file, {int quality = 50}) async {
    if (file == null) {
      return null;
    }
    File? compressed =
        await ApplicationUtility.compressImage(file.path, quality: quality);
    if (compressed != null) {
      return compressed.path;
    }
    return null;
  }

  _pickCoverImage() async {
    try {
      XFile? pickImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickImage == null) {
        return;
      }
      context
          .read<CreateReviewPostCubit>()
          .updateStatus(ReviewPostStatus.loadingCoverImage);
      File? compress =
          await ApplicationUtility.compressImage(pickImage.path, quality: 60);

      var coverImage = const AttachmentDto();
      if (compress == null) {
        coverImage = coverImage.copyWith(path: pickImage.path);
      } else {
        setState(() {
          coverImage = coverImage.copyWith(path: compress.path);
        });
      }
      context
          .read<CreateReviewPostCubit>()
          .updateReviewPost(coverImage: coverImage);
    } on Exception catch (e) {
    } finally {
      context
          .read<CreateReviewPostCubit>()
          .updateStatus(ReviewPostStatus.success);
    }
  }

  Future<String?> _cropImage(String path) async {
    CroppedFile? croppedFile = await _imageCropper.cropImage(
      sourcePath: path,
      cropStyle: CropStyle.rectangle,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      maxHeight: 180,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop image cover',
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true,
          cropFrameColor: Colors.transparent,
        ),
        IOSUiSettings(
          title: 'Crop image cover',
          aspectRatioLockEnabled: true,
          rectHeight: 180,
        ),
      ],
    );
    if (croppedFile == null) {
      return null;
    }
    return croppedFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // COVER IMAGE
        TapEffectWidget(
          onLongPress: _cropAndUpdateCoverImg,
          tap: _pickCoverImage,
          child: BlocBuilder<CreateReviewPostCubit, CreateReviewPostState>(
            builder: (context, state) {
              return CoverImageContainer(
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: kReviewPostBorderRadius,
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
                  child: state.status == ReviewPostStatus.loadingCoverImage
                      ? const CupertinoActivityIndicator()
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              spacing: 10,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              runSpacing: 10,
              children: [
                MyTextIconButton(
                    text: 'Tag',
                    icon: Icons.tag,
                    bgColor: Colors.blueAccent,
                    textColor: Colors.white,
                    onTap: () => Navigator.push(context,
                            PickTagScreen.route(callback: (tagNames) {
                          print(tagNames);
                        }))),
                MyTextIconButton(
                    text: 'Money',
                    icon: Icons.attach_money,
                    bgColor: Colors.orange,
                    textColor: Colors.white,
                    onTap: () {
                      _showCostInputDialog(context);
                    }),
                MyTextIconButton(
                    text: 'Date',
                    icon: Icons.date_range,
                    bgColor: Colors.lightBlueAccent,
                    textColor: Colors.white,
                    onTap: () {}),
              ],
            ),
          ),
        ),

        // Title editing
        Container(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title",
                  style:
                      MyTheme.heading2.copyWith(fontWeight: FontWeight.w600)),
              TextField(
                controller: widget.titleController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Content editor
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: quill.QuillEditor.basic(
            controller: widget.controller,
            readOnly: false, // true for view only mode
          ),
        ),
        // End of editor
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          width: 200.0,
          child:
              MyOutlineButton(onClick: _pickGalleryImages, text: 'Add images'),
        ),
        // IMAGE LIST
        BlocBuilder<CreateReviewPostCubit, CreateReviewPostState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 140,
                  child: ReorderableListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      // show circular when loading new image
                      if (index == state.post.images.length) {
                        return state.status == ReviewPostStatus.loadingImages
                            ? GestureDetector(
                                key: ValueKey(index),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    height: 180,
                                    constraints:
                                        const BoxConstraints(minHeight: 180),
                                    child: const Center(
                                        child: CupertinoActivityIndicator()),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(
                                key: ValueKey(index),
                              );
                      }
                      return ReviewPostImageContainer(
                          key: ValueKey(index),
                          onErr: (_, stack) {
                            var images = [...state.post.images];
                            images.removeAt(index);
                            context
                                .read<CreateReviewPostCubit>()
                                .updateReviewPost(images: images);
                          },
                          onTap: () {
                            _showImageGallery(context, index);
                          },
                          image: state.post.images[index].file,
                          onRemove: () => _removeImageFromGallery(index));
                    },
                    itemCount: state.post.images.length + 1,
                    onReorder: ((oldIndex, newIndex) {
                      if (newIndex > oldIndex) {
                        newIndex = newIndex - 1;
                      }
                      var list = [...state.post.images];
                      var el = list.removeAt(oldIndex);
                      list.insert(newIndex, el);
                      context
                          .read<CreateReviewPostCubit>()
                          .updateReviewPost(images: list);
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${state.post.images.length} images',
                        style: MyTheme.bodyText1.copyWith(
                            color: Colors.black54, fontWeight: FontWeight.w800),
                      )),
                ),
              ],
            );
          },
        ),

        const SizedBox(
          height: 300,
        )
      ],
    );
  }

  void _showCostInputDialog(BuildContext context) {
      showDialog(
      context: context,
      barrierDismissible: true,
       builder: (context) {
         return const Dialog(
           child: DayCostInputDialog(),
           alignment: Alignment.center,
           backgroundColor: Colors.transparent,
           insetPadding: EdgeInsets.zero,
         );
       },
    );
  }

  void _showImageGallery(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ReviewPostGalleryView(
            initialIndex: index,
          );
        },
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  _pickGalleryImages() async {
    try {
      //pick 1 image if gallery images is not empty
      var images = context.read<CreateReviewPostCubit>().state.post.images;
      context
          .read<CreateReviewPostCubit>()
          .updateStatus(ReviewPostStatus.loadingImages);

      if (images.isNotEmpty) {
        XFile? xFile =
            await _imagePicker.pickImage(source: ImageSource.gallery);
        if (xFile == null) return;
        String? path = await _compress(File(xFile.path));
        _addToReviewImageGallery(path, 0);
        return;
      }
      // Pick multiple images
      List<XFile>? xFiles =
          await _imagePicker.pickMultiImage(imageQuality: 100);
      if (xFiles != null && xFiles.isNotEmpty) {
        for (int i = 0; i < xFiles.length; i++) {
          String? path = await _compress(File(xFiles[i].path));
          _addToReviewImageGallery(path, (images.length + 1));
        }
      }
    } on Exception catch (e) {
    } finally {
      context
          .read<CreateReviewPostCubit>()
          .updateStatus(ReviewPostStatus.success);
    }
  }

  // Crop cover image
  _cropAndUpdateCoverImg() async {
    var post = context.read<CreateReviewPostCubit>().state.post;
    if (post.coverImage == null) {
      return;
    }
    String? path = await _cropImage(post.coverImage!.path!);
    if (path != null) {
      context
          .read<CreateReviewPostCubit>()
          .updateReviewPost(coverImage: post.coverImage!.copyWith(path: path));
    }
  }
}
