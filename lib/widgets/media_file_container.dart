import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';

class MediaFileContainer extends StatelessWidget {
  const MediaFileContainer(
      {Key? key,
      required this.ratio,
      required this.file,
      required this.boxFit,
      required this.height,
      required this.onClick,
      required this.width,
      required this.modifiedFile})
      : super(key: key);

  final double ratio;
  final File file;
  final BoxFit boxFit;
  final double? height;
  final double? width;
  final Function onClick;
  final Function? modifiedFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      constraints: const BoxConstraints(minWidth: 100),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(.1)),
      child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // child: Image.file(
                //   file,
                //   height: height,
                //   fit: boxFit,
                //   width: width,
                child: CachedNetworkImage(
                  imageUrl: '',
                  placeholder: (context, url) =>
                    const  Center(child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => Image.file(
                    file,
                    height: height,
                    fit: boxFit,
                    width: width,
                  ),
                )),
            Positioned(
              bottom: 10,
              left: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RoundedIconButton(onClick: () {}, icon: Icons.description),
                  const SizedBox(width: 10),
                  RoundedIconButton(
                    onClick: () async {
                      CroppedFile? croppedFile = await ImageCropper().cropImage(
                        sourcePath: file.path,
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
                        ],
                        compressQuality: 70,
                        uiSettings: [
                          AndroidUiSettings(
                              toolbarTitle: 'Cropper',
                              toolbarColor: Colors.deepOrange,
                              toolbarWidgetColor: Colors.white,
                              initAspectRatio: CropAspectRatioPreset.original,
                              lockAspectRatio: false),
                          IOSUiSettings(
                            title: 'Cropper',
                          ),
                        ],
                      );
                      if (croppedFile != null) {
                        File file = File(croppedFile.path);
                        modifiedFile != null ? modifiedFile!(file) : null;
                      }
                    },
                    icon: Icons.brush_outlined,
                  ),
                ],
              ),
            ),
            //CLOSE BUTTON
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.5),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                  onPressed: () => onClick(),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            )
          ],
          clipBehavior: Clip.hardEdge),
    );
  }
}
