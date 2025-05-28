import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../Controller/ImagePicker.dart';

Future<dynamic> ImagePickerBottomSheet(
  BuildContext context,
  RxString imagePath,
  RxString videoPath,
  ImagePickerController imagePickerController,
) {
  return Get.bottomSheet(
    Container(
      height: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Camera Image
          InkWell(
            onTap: () async {
              imagePath.value = await imagePickerController.pickImage(ImageSource.camera);
              videoPath.value = "";
              Get.back();
            },
            child: IconContainer(icon: Icons.camera),
          ),
          // Gallery Image
          InkWell(
            onTap: () async {
              imagePath.value = await imagePickerController.pickImage(ImageSource.gallery);
              videoPath.value = "";
              Get.back();
            },
            child: IconContainer(icon: Icons.photo),
          ),
        ],
      ),
    ),
  );
}

class IconContainer extends StatelessWidget {
  final IconData icon;
  const IconContainer({super.key, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, size: 30),
    );
  }
}
