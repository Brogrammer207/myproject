import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/screens/widgets/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _fetchImages() async {
    List<String> imageUrls = [];
    QuerySnapshot snapshot = await _firestore.collection('images').get();
    for (var doc in snapshot.docs) {
      imageUrls.add(doc['url']);
    }
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.05),
      body: FutureBuilder<List<String>>(
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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageZoomPage(
                        imageUrls: imageUrls,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ImageZoomPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  ImageZoomPage({required this.imageUrls, required this.initialIndex});

  Future<void> _downloadImage(BuildContext context, String url) async {
    // Request storage permissions
    if (Platform.isAndroid) {
      if (!await Permission.manageExternalStorage.isGranted) {
        var result = await Permission.manageExternalStorage.request();
        if (!result.isGranted) {
          _showPermissionError(context);
          return;
        }
      }
    } else if (!await Permission.photos.isGranted) {
      var result = await Permission.photos.request();
      if (!result.isGranted) {
        _showPermissionError(context);
        return;
      }
    }

    try {
      // Download the image
      Dio dio = Dio();
      final tempDirectory = await getTemporaryDirectory();
      final filePath = "${tempDirectory.path}/${url.split('/').last}";

      // Download the image file to temporary directory
      await dio.download(url, filePath);

      // Save the image to the gallery
      final asset = await PhotoManager.editor.saveImage(
        File(filePath).readAsBytesSync(), filename: 'Borawar Oil',
      );

      if (asset != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to gallery')),
        );
        showToast("Image saved to gallery");
      } else {
        throw Exception("Failed to save image to gallery");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download image: $e')),
      );
    }
  }

  void _showPermissionError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Storage permission is required to download images.')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              final currentImageUrl = imageUrls[initialIndex];
              _downloadImage(context, currentImageUrl);
            },
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrls[index]),
            // minScale: PhotoViewComputedScale.covered,
            // maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        pageController: PageController(initialPage: initialIndex),
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}
