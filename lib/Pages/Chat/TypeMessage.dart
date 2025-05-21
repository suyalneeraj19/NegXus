import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Controller/ChatController.dart';
import 'package:NegXus/Controller/ImagePicker.dart';
import 'package:NegXus/Pages/Widgets/ImagePickerBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Model/UserModel.dart';

class TypeMessage extends StatelessWidget {
  final UserModel userModel;
  final TextEditingController messageController;

  const TypeMessage({super.key, required this.userModel, required this.messageController});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find();
    final ImagePickerController imagePickerController = Get.put(ImagePickerController());
    final RxString message = "".obs;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: messageController,
              onChanged: (value) => message.value = value,
              decoration: const InputDecoration(
                filled: false,
                hintText: "Type message ...",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => message.value != "" || chatController.selectedImagePath.value != ""
                ? InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (messageController.text.isNotEmpty || chatController.selectedImagePath.value.isNotEmpty) {
                        chatController.sendMessage(userModel.id!, messageController.text, userModel);
                        messageController.clear();
                        message.value = "";
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      child: chatController.isLoading.value
                          ? CircularProgressIndicator()
                          : SvgPicture.asset(
                              AssetsImage.sendSVG,
                              width: 25,
                            ),
                    ),
                  )
                : Container(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset(
                      AssetsImage.micSVG,
                      width: 25,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
