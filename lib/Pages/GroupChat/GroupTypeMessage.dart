import 'dart:io';
import 'package:NegXus/Controller/GroupController.dart';
import 'package:NegXus/Model/GroupModel.dart';
import 'package:NegXus/Pages/Widgets/ImagePickerBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Config/Images.dart';
import '../../../Controller/ImagePicker.dart';

class GroupTypeMessage extends StatefulWidget {
  final GroupModel groupModel;
  const GroupTypeMessage({super.key, required this.groupModel});

  @override
  State<GroupTypeMessage> createState() => _GroupTypeMessageState();
}

class _GroupTypeMessageState extends State<GroupTypeMessage> {
  final TextEditingController messageController = TextEditingController();
  final RxString message = "".obs;
  final RxString videoPath = "".obs;
  final ImagePickerController imagePickerController = Get.put(ImagePickerController());
  final GroupController groupController = Get.put(GroupController());

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
      await groupController.sendGroupMessage(
        "",
        widget.groupModel.id!,
        audioPath: path, // Pass the actual audio file path here
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording failed. Please try again.')),
      );
    }

    setState(() => _audioPath = "");
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
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
                border: InputBorder.none,
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
                  onTap: () async {
                    await groupController.sendGroupMessage(
                      messageController.text,
                      widget.groupModel.id!,
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
              : GestureDetector(
                  onLongPress: _startRecording,
                  onLongPressUp: _stopRecording,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.redAccent.withOpacity(0.2) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mic,
                      color: _isRecording ? Colors.red : Colors.black,
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
