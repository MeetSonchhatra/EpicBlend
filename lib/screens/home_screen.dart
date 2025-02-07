import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lindi/lindi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_editor/lindi/image_viewholder.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    List<String> routes = [
      '/crop', // Crop
      '/filter', // Filter
      '/adjust', // Adjust
      '/fit', // Fit
      '/tint', // Tint
      '/blur', // Blur
      '/sticker', // Sticker
      '/text', // Text
      '/draw' // Draw
    ];

    if (index < routes.length) {
      Navigator.of(context).pushNamed(routes[index]);
    }
  }

  late ImageViewHolder imageViewHolder;

  @override
  void initState() {
    imageViewHolder = LindiInjector.get<ImageViewHolder>();
    super.initState();
  }

  _savePhoto() async {
    final result = await ImageGallerySaver.saveImage(
        imageViewHolder.currentImage!,
        quality: 100,
        name: "${DateTime.now().millisecondsSinceEpoch}");
    if (!mounted) return false;
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Image saved to Gallery'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong!'),
      ));
    }
  }

  _sharePhoto() async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/shared_image.png');
    await file.writeAsBytes(imageViewHolder.currentImage!);

    XFile xfile = XFile(file.path);

    Share.shareXFiles([xfile], text: "Check out this image!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EpicBlend"),
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        actions: [
          TextButton(
            onPressed: _savePhoto,
            child: const Text('Save'),
          ),
          // PopupMenuButton<String>(
          //   onSelected: (value) {
          //     if (value == 'share') {
          //       _sharePhoto();
          //     }
          //   },
          //   itemBuilder: (context) => [
          //     const PopupMenuItem(
          //       value: 'share',
          //       child: Text('Share'),
          //     ),
          //   ],
          // ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _sharePhoto();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: LindiBuilder(
              viewModel: imageViewHolder,
              builder: (BuildContext context) {
                if (imageViewHolder.currentImage != null) {
                  return Image.memory(
                    imageViewHolder.currentImage!,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.black),
              child: LindiBuilder(
                  viewModel: imageViewHolder,
                  builder: (context) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            imageViewHolder.undo();
                          },
                          icon: Icon(Icons.undo,
                              color: imageViewHolder.canUndo
                                  ? Colors.white
                                  : Colors.white10),
                        ),
                        IconButton(
                          onPressed: () {
                            imageViewHolder.redo();
                          },
                          icon: Icon(Icons.redo,
                              color: imageViewHolder.canRedo
                                  ? Colors.white
                                  : Colors.white10),
                        ),
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20), // To create floating effect
        child: PhysicalModel(
          color: Colors.transparent, // Needed for shadow effect
          elevation: 8, // Adds a floating shadow
          borderRadius: BorderRadius.circular(40),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40), // Rounded edges
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20), // Space on sides
              padding: EdgeInsets.symmetric(horizontal: 15), // Inner padding
              decoration: BoxDecoration(
                color: Color(0xFF003915),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4), // Shadow below
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(9, (index) {
                    List<IconData> icons = [
                      Ionicons.crop,
                      Ionicons.color_filter,
                      Ionicons.options_outline,
                      Ionicons.cash_outline,
                      Ionicons.contract_outline,
                      Icons.blur_circular,
                      Ionicons.happy_outline,
                      Ionicons.text_outline,
                      Ionicons.pencil
                    ];
                    List<String> labels = [
                      'Crop',
                      'Filter',
                      'Adjust',
                      'Fit',
                      'Tint',
                      'Blur',
                      'Sticker',
                      'Text',
                      'Draw'
                    ];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0), // Space between items
                      child: GestureDetector(
                        onTap: () => _onItemTapped(index),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icons[index],
                              color: _selectedIndex == index
                                  ? Colors.blue
                                  : Colors.white,
                              size: 20,
                            ),
                            Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: _selectedIndex == index
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
