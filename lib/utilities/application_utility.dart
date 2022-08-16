import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/widgets/bottom_select_dialog.dart';

class ApplicationUtility {
  //hide input keyboard
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  //push new screen
  static Future<dynamic> navigateToScreen(
      BuildContext context, Widget screen) async {
    return Navigator.push(context, MaterialPageRoute(builder: (c) => screen));
  }

  static Future<dynamic> pushAndReplace(BuildContext context, Widget screen) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => screen));
  }

  static Future<PaletteGenerator?> getPaletteGenerator(String? image) async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.network('$imageUrl$image').image,
      maximumColorCount: 4,
    );
    return paletteGenerator;
  }

  static Future<dynamic> showModelBottomDialog(
      BuildContext context, Widget widget) async {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      barrierColor: Colors.grey.withOpacity(.2),
      builder: (context) {
        return widget;
      },
      backgroundColor: Colors.transparent,
    );
  }

  static Future<dynamic> showBottomDialog(
      BuildContext context, List<BottomDialogItem> items) async {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.grey.withOpacity(.2),
      builder: (context) {
        return MyBottomDialog(items: items);
      },
      backgroundColor: Colors.transparent,
    );
  }

  static Future<File?> compressImage(String filePath, {int? quality}) async {
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitName = filePath.substring(0, (lastIndex));
    final outPath = "${splitName}_out${filePath.substring(lastIndex)}";
    return await FlutterImageCompress.compressAndGetFile(filePath, outPath,
        quality: quality ?? 75);
  }

  //get image info
  static Future<ui.Image> getImageInfo(String? name) async {
    Completer<ui.Image> completer = Completer<ui.Image>();
    NetworkImage('$imageUrl$name')
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((image, synchronousCall) {
      completer.complete(image.image);
    }));
    ui.Image info = await completer.future;
    return info;
  }

  static Future<double> getRatio(String? name) async {
    var info = await getImageInfo(name);
    // return info.height / info.width;
    return info.width / info.height;
  }
}
