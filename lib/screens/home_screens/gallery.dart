import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:myproject/helper/helper.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AddGalleryScreen extends StatefulWidget {
  @override
  _AddGalleryScreenState createState() => _AddGalleryScreenState();
}

class _AddGalleryScreenState extends State<AddGalleryScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles;

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles = selectedImages;
      });
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _fetchImages() async {
    List<String> imageUrls = [];
    QuerySnapshot snapshot = await _firestore.collection('images').get();
    for (var doc in snapshot.docs) {
      imageUrls.add(doc['url']);
    }
    return imageUrls;
  }

  Future<void> _uploadImages() async {
    if (_imageFiles == null || _imageFiles!.isEmpty) return;

    for (var image in _imageFiles!) {
      File file = File(image.path);
      try {
        // Upload to Firebase Storage
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('gallery/${image.name}')
            .putFile(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Save to Firestore
        await FirebaseFirestore.instance.collection('images').add({
          'url': downloadUrl,
          'name': image.name,
        });

        // Remove image from the list once uploaded
        setState(() {
          _imageFiles!.remove(image);
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _imageFiles!.removeAt(index);
    });
  }

  Future<void> _deleteRemoteImage(String imageUrl) async {
    try {
      // Get reference to the file on Firebase Storage
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);

      // Delete the file from Firebase Storage
      await ref.delete();

      // Delete the document from Firestore
      final snapshot = await _firestore
          .collection('images')
          .where('url', isEqualTo: imageUrl)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {});
    } catch (e) {
      print('Error deleting image: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker'),
        actions: [
          GestureDetector(
            onTap: _pickImages,
            child: Icon(Icons.add_circle_outline_outlined, size: 30),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _imageFiles != null && _imageFiles!.isNotEmpty
                ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _imageFiles!.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.file(
                      File(_imageFiles![index].path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _deleteImage(index),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
                : FutureBuilder<List<String>>(
              future: _fetchImages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No images found'));
                }

                List<String> imageUrls = snapshot.data!;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    if (_imageFiles != null && _imageFiles!.isNotEmpty) {
                      // Handling for local images
                      return Stack(
                        children: [
                          Image.file(
                            File(_imageFiles![index].path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _deleteImage(index),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Handling for remote images
                      String imageUrl = imageUrls[index];
                      return Stack(
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _deleteRemoteImage(imageUrl),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: (){
              _uploadImages();
              showToast('Image Uploaded');
            },
            child: Text('Upload Images'),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
