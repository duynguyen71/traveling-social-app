import 'dart:async';

import 'package:flutter/material.dart';

class AttachmentUtility {
  /// Calculating image dimension
  static Future<Size> calculateImageDimension(String? imageUrl) async {
    if (imageUrl == null) {
      return const Size.fromHeight(0.0);
    }
    Completer<Size> completer = Completer();
    Image image = Image.network(imageUrl);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }
}
