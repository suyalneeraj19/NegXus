import 'package:NegXus/Controller/GroupController.dart';
import 'package:NegXus/Model/GroupModel.dart';
import 'package:NegXus/Pages/Widgets/ImagePickerBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../Config/Images.dart';
import '../../../Controller/ImagePicker.dart';

class GroupTypeMessage extends StatelessWidget {
  final GroupModel groupModel;
  const GroupTypeMessage({super.key, required this.groupModel});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final RxString message = "".obs;
    final RxString videoPath = "".obs;
    final ImagePickerController imagePickerController = Get.put(ImagePickerController());
    final GroupController groupController = Get.put(GroupController());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              onChanged: (value) => message.value = value,
              decoration: const InputDecoration(
                filled: false,
                hintText: "Type message ...",
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(() => groupController.selectedImagePath.value.isEmpty && videoPath.value.isEmpty
              ? InkWell(
                  onTap: () {
                    ImagePickerBottomSheet(
                      context,
                      groupController.selectedImagePath,
                      videoPath,
                      imagePickerController,
                    );
                  },
                  child: SvgPicture.asset(AssetsImage.gallerySVG, width: 30, height: 30),
                )
              : const SizedBox()),
          const SizedBox(width: 10),
          Obx(() => message.value.isNotEmpty || groupController.selectedImagePath.value.isNotEmpty || videoPath.value.isNotEmpty
              ? InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    groupController.sendGroupMessage(
                      messageController.text,
                      groupModel.id!,
                      videoPath: videoPath.value,
                    );
                    messageController.clear();
                    message.value = "";
                    videoPath.value = "";
                  },
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: groupController.isLoading.value
                        ? const CircularProgressIndicator()
                        : SvgPicture.asset(AssetsImage.sendSVG, width: 25),
                  ),
                )
              : SvgPicture.asset(AssetsImage.micSVG, width: 25)),
        ],
      ),
    );
  }
}
