import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/story_viewmodel.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:traveling_social_app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  List<XFile> images = [];
  final _imagePicker = ImagePicker();
  final _captionController = TextEditingController();
  bool _isLoading = false;

  _handlePickImage(ImageSource source) async {
    XFile? file = await _imagePicker.pickImage(source: source);
    if (file != null) _addImage(file);
  }

  _addImage(XFile image) {
    setState(() {
      images.add(image);
    });
  }

  _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  Future<void> _handlePostStory() async {
    ApplicationUtility.hideKeyboard();
    String caption = _captionController.text.toString();
    if (caption.isEmpty && images.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    UserService userService = UserService();
    var story = await userService.createStory(<String, dynamic>{
      "caption": caption,
      "type": 0,
    }, images);
    context.read<StoryViewModel>().addStory(story);
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    var userViewModel = context.read<UserViewModel>();
    _captionController.text =
        "User: ${userViewModel.user!.username.toString()}" +
            userViewModel.user!.id.toString() +
            " post at " +
            DateTime
                .now()
                .millisecondsSinceEpoch
                .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
                            GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: (16 / 9),
                              shrinkWrap: true,
                              children: List.generate(images.length, (index) {
                                XFile? file = images.asMap()[index];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(File(file!.path)),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () async =>
                                      await _handlePickImage(
                                          ImageSource.camera),
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                        size: 25,
                                        color: Colors.lightBlue,
                                      )),
                                  const SizedBox(width: 20),
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () async =>
                                          _handlePickImage(ImageSource.gallery),
                                      icon: const Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 25,
                                        color: Colors.lightBlue,
                                      ))
                                ],
                              ),
                            ),
                            //IMAGE PICKER
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
