import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic("dix3jqg7w", 'aqox8ip4', cache: false);

  Future<String?> uploadAudio(File file) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file.path,
            resourceType: CloudinaryResourceType.Auto), // Changed here
      );
      return response.secureUrl;
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }
}
