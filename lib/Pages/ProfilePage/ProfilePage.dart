import 'dart:io';

import 'package:NegXus/Controller/AuthController.dart';
import 'package:NegXus/Controller/ImagePicker.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Pages/Widgets/PrimaryButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary_url_gen/transformation/source/image_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as img;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isEdit = false.obs;
    ProfileController profileController = Get.put(ProfileController());
    TextEditingController name = TextEditingController(text: profileController.currentUser.value.name);
    TextEditingController email = TextEditingController(text: profileController.currentUser.value.email);
    TextEditingController phone = TextEditingController(text: profileController.currentUser.value.phoneNumber);
    TextEditingController about = TextEditingController(text: profileController.currentUser.value.about);
    ImagePickerController imagePickerController = Get.put(ImagePickerController());
    RxString imagePath = "".obs;

    AuthController authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              authController.logoutUser();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              // height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => isEdit.value
                                  ? InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        imagePath.value = await imagePickerController.pickImage(img.ImageSource.gallery);
                                        print("Image Picked" + imagePath.value);
                                      },
                                      child: Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.background,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: imagePath.value == ""
                                            ? Icon(
                                                Icons.add,
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: Image.file(
                                                  File(imagePath.value),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                    )
                                  : Container(
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.background,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: profileController.currentUser.value.profileImage == null ||
                                              profileController.currentUser.value.profileImage == ""
                                          ? Icon(
                                              Icons.image,
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                imageUrl: profileController.currentUser.value.profileImage!,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                              )),
                                    ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Obx(
                          () => TextField(
                            controller: name,
                            enabled: isEdit.value,
                            decoration: InputDecoration(
                              labelText: "Name",
                              prefixIcon: const Icon(Icons.person, color: Colors.white),
                              filled: true,
                              fillColor:
                                  isEdit.value ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(
                          () => TextField(
                            controller: about,
                            enabled: isEdit.value,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "About",
                              prefixIcon: const Icon(Icons.info, color: Colors.white),
                              filled: true,
                              fillColor:
                                  isEdit.value ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: email,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.alternate_email, color: Colors.white),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ),
                        Obx(
                          () => TextField(
                            controller: phone,
                            enabled: isEdit.value,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Phone",
                              prefixIcon: const Icon(Icons.phone, color: Colors.white),
                              filled: true,
                              fillColor:
                                  isEdit.value ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => isEdit.value
                                  ? PrimaryButton(
                                      btnName: "Save",
                                      icon: Icons.save,
                                      ontap: () async {
                                        await profileController.updateProfile(
                                          imagePath: imagePath.value,
                                          name: name.text,
                                          about: about.text,
                                          phoneNumber: phone.text,
                                        );
                                        isEdit.value = false;
                                      },
                                    )
                                  : PrimaryButton(
                                      btnName: "Edit",
                                      icon: Icons.edit,
                                      ontap: () {
                                        isEdit.value = true;
                                      },
                                    ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
