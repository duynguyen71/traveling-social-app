import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/story_view_model.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';
import 'package:traveling_social_app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../widgets/media_file_container.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final List<File> _pickedFiles = [];
  final _imagePicker = ImagePicker();
  final _captionController = TextEditingController();
  bool _isLoading = false;

  final int _compressQuality = 10;

  _getImageFromCamera() async {
    XFile? file = await _imagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      File? compressed = await ApplicationUtility.compressImage(file.path,
          quality: _compressQuality);
      if (compressed != null) {
        setState(() {
          _pickedFiles.add(compressed);
        });
      }
    }
  }

  _getImagesFromGallery() async {
    List<XFile>? files = await _imagePicker.pickMultiImage();
    if (files != null) {
      for (int i = 0; i < files.length; i++) {
        File? compressed = await ApplicationUtility.compressImage(files[i].path,
            quality: _compressQuality);
        if (compressed != null) {
          setState(() {
            _pickedFiles.add(compressed);
          });
        }
      }
    }
  }

  Future<void> _handlePostStory() async {
    ApplicationUtility.hideKeyboard();
    String caption = _captionController.text.toString();
    if (caption.isEmpty && _pickedFiles.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    UserService userService = UserService();
    var story = await userService.createStory(<String, dynamic>{
      "caption": caption,
      "type": 0,
    }, _pickedFiles);
    context.read<StoryViewModel>().addStory(story);
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    var authBloc = context.read<AuthenticationBloc>().state;
    _captionController.text = "User: ${authBloc.user.username.toString()}" +
        authBloc.user.id.toString() +
        " post at " +
        DateTime.now().millisecondsSinceEpoch.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 1),
              child: Divider(
                color: kPrimaryColor.withOpacity(.2),
                height: 1,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
            ),
            title: const Text(
              "Create Story",
              textAlign: TextAlign.center,
            ),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 18),
            actions: [
              TextButton(
                  onPressed: () async => _handlePostStory(),
                  child: const Text("Post"))
            ],
          ),
          body: Center(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: size.height,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                  hintText: "caption...",
                                  border: InputBorder.none),
                              controller: _captionController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            ),
                            const SizedBox(height: 10),
                            //MEDIA FILES
                            _pickedFiles.isNotEmpty
                                ? SizedBox(
                                    height: 180,
                                    child: ReorderableListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      onReorder: ((oldIndex, newIndex) {
                                        if (newIndex > oldIndex) {
                                          newIndex = newIndex - 1;
                                        }
                                        final element =
                                            _pickedFiles.removeAt(oldIndex);
                                        _pickedFiles.insert(newIndex, element);
                                      }),
                                      itemBuilder: (context, index) {
                                        return MediaFileContainer(
                                          key: ValueKey(_pickedFiles[index]),
                                          ratio: 16 / 9,
                                          boxFit: BoxFit.fitHeight,
                                          file: _pickedFiles[index],
                                          height: 180,
                                          onClick: () {
                                            setState(() {
                                              _pickedFiles.removeAt(index);
                                            });
                                          },
                                          width: null,
                                          modifiedFile: (File f) {
                                            setState(() {
                                              _pickedFiles[index] = f;
                                            });
                                          },
                                        );
                                      },
                                      itemCount: _pickedFiles.length,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //PICK FROM CAMERA
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _getImageFromCamera(),
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      size: 25,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  //PICK FROM GALLERY
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _getImagesFromGallery(),
                                    icon: const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 25,
                                      color: Colors.lightBlue,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        LoadingWidget(isLoading: _isLoading)
      ],
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }
}
