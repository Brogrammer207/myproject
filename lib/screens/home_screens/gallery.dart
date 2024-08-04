import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:myproject/helper/helper.dart';

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
                : Center(child: Text('No images selected')),
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
