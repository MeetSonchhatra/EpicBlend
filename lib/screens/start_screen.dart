import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindi/lindi.dart';
import 'package:photo_editor/helper/app_image_picker.dart';
import 'package:photo_editor/lindi/image_viewholder.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late ImageViewHolder imageViewHolder;

  @override
  void initState() {
    imageViewHolder = LindiInjector.get<ImageViewHolder>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/images/wallpaper_1.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            const Expanded(
              child: Center(
                  // child: Text(
                  //   "Epic Blend",
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 30,
                  //     fontStyle: FontStyle.italic,
                  //     fontWeight: FontWeight.bold,
                  //     letterSpacing: 5,
                  //   ),
                  // ),
                  ),
            ),
            // Expanded(
            //   child: Container(),
            // ),
            Expanded(
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      AppImagePicker(source: ImageSource.gallery).pick(
                          onPick: (File? image) {
                        imageViewHolder.changeImageFile(image!);
                        Navigator.of(context).pushReplacementNamed('/home');
                      });
                    },
                    child: const Text("Gallery"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AppImagePicker(source: ImageSource.camera).pick(
                          onPick: (File? image) {
                        imageViewHolder.changeImageFile(image!);
                        Navigator.of(context).pushReplacementNamed('/home');
                      });
                    },
                    child: const Text("Camera"),
                  )
                ],
              )),
            )
          ],
        )
      ],
    ));
  }
}
