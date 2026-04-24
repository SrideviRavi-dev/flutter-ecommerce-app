// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:myapp/features/shop/controllers/image_uploader/image_uploader.dart';
import 'package:myapp/services/firestore_service/firestore_services.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryNameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String categoryName = categoryNameController.text;
                addCategoryWithImage(categoryName);
              },
              child: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }

 
  Future<void> addCategoryWithImage(String categoryName) async {
    final uploader = ImageUploader();
    final firestoreService = FirestoreService();

    // Specify the type as 'categories' for the image upload
    String? imageUrl = await uploader.uploadImage('categories');
    
    if (imageUrl != null) {
      await firestoreService.addCategory(categoryName, imageUrl);
      print('Category added with image URL: $imageUrl');
    } else {
      print('No image selected.');
    }
  }
}
