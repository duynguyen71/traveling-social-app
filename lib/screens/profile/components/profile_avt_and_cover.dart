import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_event.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_state.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/bottom_select_dialog.dart';
import 'package:traveling_social_app/widgets/current_user_avt.dart';

import '../../../constants/api_constants.dart';
import '../../../constants/app_theme_constants.dart';

import 'button_edit_profile.dart';

class ProfileAvtAndCover extends StatefulWidget {
  const ProfileAvtAndCover({Key? key}) : super(key: key);

  @override
  State<ProfileAvtAndCover> createState() => _ProfileAvtAndCoverState();
}

class _ProfileAvtAndCoverState extends State<ProfileAvtAndCover> {
  late List<BottomDialogItem> _bottomDialogItems;
  late List<BottomDialogItem> _backgroundPhotoBottomDialogItems;
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _bottomDialogItems = [
      BottomDialogItem(title: 'View photo', onClick: () {}),
      BottomDialogItem(
          title: 'New photo from gallery', onClick: () => _changeAvtPhoto()),
    ];
    _backgroundPhotoBottomDialogItems = [
      BottomDialogItem(
          title: 'New photo from gallery', onClick: () => _changeBgPhoto()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * .4,
      width: double.infinity,
      child: Stack(
        children: [
          SizedBox(
            height: (size.height * .4 - 80),
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                ApplicationUtility.showBottomDialog(
                    context, _backgroundPhotoBottomDialogItems);
              },
              //BACKGROUND
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      return CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: '$imageUrl${state.user.background}',
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/home_bg.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )),
            ),
          ),
          //CURRENT USER AVT
          Positioned(
            bottom: 0,
            left: kDefaultPadding,
            child: CurrentUserAvt(
              onTap: () {
                ApplicationUtility.showModelBottomDialog(
                  context,
                  MyBottomDialog(
                    items: _bottomDialogItems,
                  ),
                );
              },
              size: 150,
            ),
          ),
          Positioned(
            bottom: 0,
            right: kDefaultPadding / 2,
            child: Container(
              constraints: const BoxConstraints(minWidth: 130),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 40,
              child: const ButtonEditProfile(),
            ),
          ),
        ],
      ),
    );
  }

  Future<File?> _pickImageFromGallery(
      {required CropStyle cropStyle,
      required List<CropAspectRatioPreset> presets}) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? file =
          await ApplicationUtility.compressImage(pickedFile.path, quality: 70);
      if (file == null) {
        return null;
      }
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        cropStyle: cropStyle,
        aspectRatioPresets: presets,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            cropFrameColor: Colors.transparent,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    }
    return null;
  }

  //change avatar photo
  _changeAvtPhoto() async {
    File? croppedFile = await _pickImageFromGallery(
        cropStyle: CropStyle.circle, presets: [CropAspectRatioPreset.square]);
    if (croppedFile != null) {
      await _userService.updateAvt(file: File(croppedFile.path));
      context.read<AuthenticationBloc>().add(UserInfoChanged());
    }
  }

  _changeBgPhoto() async {
    File? croppedFile = await _pickImageFromGallery(
        cropStyle: CropStyle.rectangle,
        presets: [CropAspectRatioPreset.ratio16x9]);
    if (croppedFile != null) {
      await _userService.updateBackground(file: File(croppedFile.path));
      context.read<AuthenticationBloc>().add(UserInfoChanged());
    }
  }
}
