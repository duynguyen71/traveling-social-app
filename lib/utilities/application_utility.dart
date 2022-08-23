import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/widgets/bottom_select_dialog.dart';
import 'dart:math';

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
    // var size = await getFileSize(filePath, 0);
    var mb = getFileSizeInMb(File(filePath));
    print('file length mb: $mb');
    if (mb <= .8) {
      print('ko commpress image');
      return File(filePath);
    }
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitName = filePath.substring(0, (lastIndex));
    final outPath = "${splitName}_out${filePath.substring(lastIndex)}";
    return await FlutterImageCompress.compressAndGetFile(filePath, outPath,
        quality: 50);
  }

  static getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static double getFileSizeInMb(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }

  //get image info
  static Future<ui.Image?> getImageInfo(String? name) async {
    try {
      Completer<ui.Image?> completer = Completer<ui.Image?>();
      var url = '$imageUrl$name';
      NetworkImage(url)
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener(
            (image, synchronousCall) {
              completer.complete(image.image);
            },
            onError: (exception, stackTrace) {
              return;
            },
          ));
      ui.Image? info = await completer.future;
      return info;
    } on Exception catch (e) {
      return null;
    }
  }

  static Future<double?> getRatio(String? name) async {
    var info = await getImageInfo(name);
    if (info == null) return null;
    // return info.height / info.width;
    return info.width / info.height;
  }

  static String? formatDate(String? str,
      {Locale? locale, String formatPattern = "dd-MMM-yyyy"}) {
    try {
      var format = DateFormat(formatPattern, locale?.toString())
          .format(DateTime.parse('$str'));
      return format;
    } catch (e) {
      print('failed to format date: $e');
      return null;
    }
  }
}
