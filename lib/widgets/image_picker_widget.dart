import 'package:firs_mini_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// pickImage(ImageSource source) async {
//   final ImagePicker _imagePicker = ImagePicker();
//   XFile? _file = await _imagePicker.pickImage(source: source);

//   if (_file != null) {
//     return await _file.readAsBytes();
//   }
//   print('No image Selected');
// }
class ImagePickerWidget extends StatefulWidget {
  final File? initialImage;
  final Function(File?) onImageSelected;

  const ImagePickerWidget(
      {this.initialImage, required this.onImageSelected, super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.initialImage;
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final returnedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (returnedImage == null) return;

      setState(() {
        selectedImage = File(returnedImage.path);
      });
      widget.onImageSelected(selectedImage);
      // widget.selectedImage
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  // Future _pickImageFromCamera() async {
  //   final returnImage =
  //       await ImagePicker().pickImage(source: ImageSource.camera);

  //   if (returnImage == null) return;
  //   setState(() {
  //     selectedImage = File(returnImage.path);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        selectedImage != null
            ? CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(selectedImage!),
              )
            : CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey[600],
                )),
        Positioned(
          bottom: -10,
          left: 60,
          child: IconButton(
            onPressed: () {
              _pickImageFromGallery();
            },
            icon: const Icon(Icons.add_a_photo),
          ),
        ),
      ],
    );
  }
}
