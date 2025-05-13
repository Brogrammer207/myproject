import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:myproject/screens/widgets/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:http/http.dart';


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
    if (Platform.isAndroid) {
      if (!await Permission.manageExternalStorage.isGranted) {
        var result = await Permission.manageExternalStorage.request();
        if (!result.isGranted) {
          _showPermissionError(context);
          return;
        }
      }
    } else if (Platform.isIOS) {
      if (!await Permission.photosAddOnly.isGranted) {
        var result = await Permission.photosAddOnly.request();
        if (!result.isGranted) {
          _showPermissionError(context);
          return;
        }
      }
    }

    try {
      Dio dio = Dio();
      final tempDirectory = await getTemporaryDirectory();
      final filePath = "${tempDirectory.path}/${url.split('/').last}";

      // Download image to temporary directory
      await dio.download(url, filePath);

      // Save image to gallery (use different methods for Android and iOS)
      if (Platform.isIOS) {
        final result = await ImageGallerySaver.saveFile(filePath);
        if (result['isSuccess'] == true) {
          showToast("Image saved to gallery");
        } else {
          throw Exception("Failed to save image to gallery");
        }
      } else {
        final asset = await PhotoManager.editor.saveImage(
          File(filePath).readAsBytesSync(), filename: 'Borawar Oil',
        );

        if (asset != null) {
          showToast("Image saved to gallery");
        } else {
          throw Exception("Failed to save image to gallery");
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download image: $e')),
      );
    }
  }
  downloadImage(String imageUrl, context) async {
    try {
      String devicePathToSaveImage = "";
      var time = DateTime.now().microsecondsSinceEpoch;
      if (Platform.isAndroid) {
        devicePathToSaveImage = "/storage/emulated/0/Download/image-$time.jpg";
      } else {
        var downloadDirectoryPath = await getApplicationDocumentsDirectory();
        devicePathToSaveImage = "${downloadDirectoryPath.path}/image-$time.jpg";
      }

      File file = File(devicePathToSaveImage);
      print('File path: $devicePathToSaveImage');
      // Make the HTTP GET request
      var res = await get(Uri.parse(imageUrl));
      if (res.statusCode == 200) {
        // Save the image
        await file.writeAsBytes(res.bodyBytes);
        await ImageGallerySaver.saveFile(devicePathToSaveImage);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Yay! Downloading Completed'),
        ));
      }
    } catch (error) {
      print("Error: $error");
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
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset('assets/images/back.png'),
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              final currentImageUrl = imageUrls[initialIndex];
              downloadImage(currentImageUrl,context);
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
