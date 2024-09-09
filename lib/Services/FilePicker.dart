import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  File? image;
  try {
    final ImagePicker _picker = ImagePicker();

    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      image = File(file.path);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return image;
}

Future<Uint8List?> pickImageAsByte(ImageSource imageSource) async {
  try {
    final ImagePicker _picker = ImagePicker();

    final XFile? file = await _picker.pickImage(source: imageSource);

    if (file != null) {
      // Convert the image file to Uint8List
      return await File(file.path).readAsBytes();
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null; // Return null if no image is picked or an error occurs
}
