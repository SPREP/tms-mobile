import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(List<File> selectedImages) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  List<File> selectedImages = [];
  List<File> selectedVideos = [];

  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            height: 50,
            width: double.infinity,
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: _getImages,
                  icon: const Icon(Icons.camera),
                  label: const Text('Add Photos'),
                ),
                const Spacer(),
                /*
                TextButton.icon(
                  onPressed: _getImages,
                  icon: const Icon(Icons.video_camera_back),
                  label: const Text('Add Videos'),
                ),
                */
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: GridView.builder(
              itemCount: selectedImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: [
                    Positioned(
                      width: 300,
                      height: 300,
                      child: Image.file(
                        File(selectedImages[index].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImages.removeAt(index);
                            });
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ))
                  ],
                );
              }),
        ),
      ],
    );
  }
/*
  Future _getVideos() async {
    final pickedVideos =
        await imagePicker.pickVideo(source: ImageSource.gallery);
    List<XFile> xfilePick = pickedVideos;

    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
      }

      setState(() {});

      widget.onPickImage(selectedImages);
    }
  }
  */

  Future _getImages() async {
    final pickedImage = await imagePicker.pickMultiImage();
    List<XFile> xfilePick = pickedImage;

    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
      }

      setState(() {});

      widget.onPickImage(selectedImages);
    }
  }
}
