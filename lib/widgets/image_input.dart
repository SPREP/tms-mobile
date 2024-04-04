import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput(
      {super.key, this.onPickImage, this.onChooseImage, this.onTakePhoto});

  final void Function(List<File> selectedImages)? onPickImage;
  final void Function(File selectedImage)? onChooseImage;
  final void Function(File takePhoto)? onTakePhoto;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  List<File> selectedImages = [];
  List<File> selectedVideos = [];
  var selectedPhoto;

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
                if (widget.onPickImage != null)
                  TextButton.icon(
                    onPressed: _getImages,
                    icon: const Icon(Icons.camera),
                    label: const Text('Choose Photos'),
                  ),
                if (widget.onChooseImage != null)
                  TextButton.icon(
                    onPressed: _getImage,
                    icon: const Icon(Icons.camera),
                    label: const Text('Choose Photo'),
                  ),
                if (widget.onPickImage == null) Spacer(),
                if (widget.onTakePhoto != null)
                  TextButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Take Photo'),
                  ),
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        if ((widget.onChooseImage != null || widget.onTakePhoto != null) &&
            selectedPhoto != null)
          Container(
            height: 300,
            width: 300,
            child: Stack(
              children: [
                Positioned(
                  child: Image.file(
                    File(selectedPhoto.path),
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPhoto = null;
                        });
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ))
              ],
            ),
          ),
        if (widget.onPickImage != null)
          Container(
            color: Theme.of(context).primaryColor,
            height: 300,
            width: 300,
            child: GridView.builder(
                itemCount: selectedImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        child: Image.file(
                          File(selectedImages[index].path),
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                          height: double.infinity,
                          width: double.infinity,
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
      widget.onPickImage!(selectedImages);
    }
  }

  Future _getImage() async {
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, requestFullMetadata: true);
    if (pickedImage != null) {
      setState(() {});
      selectedPhoto = pickedImage;
      widget.onChooseImage!(File(pickedImage.path));
    }
  }

  Future _takePhoto() async {
    final photo = await imagePicker.pickImage(
        source: ImageSource.camera, requestFullMetadata: true);
    if (photo != null) {
      setState(() {});
      selectedPhoto = photo;
      widget.onTakePhoto!(File(photo.path));
    }
  }
}
