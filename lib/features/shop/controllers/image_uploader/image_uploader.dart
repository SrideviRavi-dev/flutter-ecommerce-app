import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUploader {
  Future<String?> uploadImage(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = pickedFile.name;

      // Create a reference to the storage based on the type
      Reference ref = FirebaseStorage.instance.ref().child('$type/$fileName');

      // Upload the image
      await ref.putFile(imageFile);

      // Get the download URL
      String downloadURL = await ref.getDownloadURL();
      return downloadURL; // Return the download URL
    } else {
      return null;
    }
  }
}
