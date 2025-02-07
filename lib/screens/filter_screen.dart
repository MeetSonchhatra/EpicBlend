import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi/lindi.dart';
import 'package:photo_editor/helper/filters.dart';
import 'package:photo_editor/lindi/image_viewholder.dart';
import 'package:photo_editor/model/filter.dart';
import 'package:screenshot/screenshot.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Filter currentFilter;
  late List<Filter> filters;

  late ImageViewHolder imageViewHolder;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = filters[0];
    imageViewHolder = LindiInjector.get<ImageViewHolder>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Filters'),
        actions: [
          IconButton(
              onPressed: () async {
                Uint8List? bytes = await screenshotController.capture();
                imageViewHolder.changeImage(bytes!);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: Center(
        child: LindiBuilder(
          viewModel: imageViewHolder,
          builder: (BuildContext context) {
            if (imageViewHolder.currentImage != null) {
              return Screenshot(
                controller: screenshotController,
                child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(currentFilter.matrix),
                    child: Image.memory(imageViewHolder.currentImage!)),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      // bottomNavigationBar: Container(
      //   width: double.infinity,
      //   height: 120,
      //   color: Colors.black,
      //   child: SafeArea(
      //     child: LindiBuilder(
      //       viewModel: imageViewHolder,
      //     builder: (BuildContext context) {
      //       return ListView.builder(
      //         scrollDirection: Axis.horizontal,
      //         itemCount: filters.length,
      //         itemBuilder: (BuildContext context, int index){
      //           Filter filter = filters[index];
      //           return Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 10),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 SizedBox(
      //                   width: 60,
      //                   height: 60,
      //                   child: FittedBox(
      //                     fit: BoxFit.fill,
      //                     child: InkWell(
      //                       onTap: (){
      //                         setState(() {
      //                           currentFilter = filter;
      //                         });
      //                       },
      //                       child: ColorFiltered(
      //                         colorFilter: ColorFilter.matrix(filter.matrix),
      //                         child: Image.memory(imageViewHolder.currentImage!),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 const SizedBox(height: 5),
      //                 Text(filter.filterName,
      //                   style: const TextStyle(
      //                     color: Colors.white
      //                   ),
      //                 )
      //               ],
      //             ),
      //           );
      //         },
      //       );
      //     }
      //     )
      //   ),
      // ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 120,
        color: Colors.black,
        child: SafeArea(
          child: LindiBuilder(
            viewModel: imageViewHolder,
            builder: (BuildContext context) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (BuildContext context, int index) {
                  Filter filter = filters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12), // Circular edges
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentFilter = filter;
                              });
                            },
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(filter.matrix),
                              child: Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      12), // Circular edges
                                ),
                                child: Image.memory(
                                  imageViewHolder.currentImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 70,
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              color: Colors.black.withOpacity(0.5),
                              child: Text(
                                filter.filterName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
