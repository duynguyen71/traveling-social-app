import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

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

  static Future<PaletteGenerator?> getPaletteGenerator(String image) async {
    if (image != null) {
      return await PaletteGenerator.fromImageProvider(
        Image.network(image).image,
      );
    }
    return null;
  }
}
