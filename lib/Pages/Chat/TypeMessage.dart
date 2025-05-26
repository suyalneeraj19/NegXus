import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Model/UserModel.dart';
import '../../Controller/ChatController.dart';
import '../../Pages/Widgets/ImagePickerBottomSheet.dart';
import '../../Controller/ImagePicker.dart';
import '../../Config/Images.dart';

class TypeMessage extends StatefulWidget {
  final UserModel userModel;
  final TextEditingController messageController;

  const TypeMessage({super.key, required this.userModel, required this.messageController});

  @override
  State<TypeMessage> createState() => _TypeMessageState();
}

class _TypeMessageState extends State<TypeMessage> {
  final ChatController chatController = Get.find();
  final ImagePickerController imagePickerController = Get.put(ImagePickerController());

  final RxString message = "".obs;
  final RxString videoPath = "".obs; // Track video path

  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String _audioPath = "";

  Future<void> _startRecording() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) return;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(const RecordConfig(), path: path);

    setState(() {
      _isRecording = true;
      _audioPath = path;
    });
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    setState(() => _isRecording = false);

    if (path != null && File(path).existsSync()) {
      await chatController.sendMessage(
        widget.userModel.id!,
        "",
        widget.userModel,
        audioPath: path,
      );
    }

    setState(() => _audioPath = "");
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              controller: widget.messageController,
              onChanged: (value) => message.value = value,
              decoration: const InputDecoration(
                filled: false,
                hintText: "Type message ...",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(() => (chatController.selectedImagePath.value.isEmpty && videoPath.value.isEmpty)
              ? InkWell(
                  onTap: () {
                    ImagePickerBottomSheet(
                      context,
                      chatController.selectedImagePath,
                      videoPath,
                      imagePickerController,
                    );
                  },
                  child: SvgPicture.asset(AssetsImage.gallerySVG, width: 30, height: 30),
                )
              : const SizedBox()),
          const SizedBox(width: 10),
          Obx(() => (message.value.isNotEmpty || chatController.selectedImagePath.value.isNotEmpty || videoPath.value.isNotEmpty)
              ? InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    chatController.sendMessage(
                      widget.userModel.id!,
                      widget.messageController.text,
                      widget.userModel,
                      videoPath: videoPath.value,
                    );
                    widget.messageController.clear();
                    message.value = "";
                    videoPath.value = "";
                  },
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: chatController.isLoading.value
                        ? const CircularProgressIndicator()
                        : SvgPicture.asset(AssetsImage.sendSVG, width: 25),
                  ),
                )
              : GestureDetector(
                  onLongPress: _startRecording,
                  onLongPressUp: _stopRecording,
                  child: Icon(
                    _isRecording ? Icons.mic : Icons.mic_none,
                    color: _isRecording ? Colors.red : Colors.grey,
                  ),
                )),
        ],
      ),
    );
  }
}
