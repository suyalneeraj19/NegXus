import 'dart:io';

import 'package:NegXus/Controller/AuthController.dart';
import 'package:NegXus/Controller/ImagePicker.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Pages/Widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final RxBool isEdit = false.obs;
  late final ProfileController profileController;
  late final ImagePickerController imagePickerController;
  late final AuthController authController;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController about = TextEditingController();
  final RxString imagePath = ''.obs;

  @override
  void initState() {
    super.initState();

    profileController = Get.put(ProfileController());
    imagePickerController = Get.put(ImagePickerController());
    authController = Get.put(AuthController());

    // Set initial values
    final user = profileController.currentUser.value;
    name.text = user.name ?? "";
    email.text = user.email ?? "";
    phone.text = user.phoneNumber ?? "";
    about.text = user.about ?? "";

    // Listen for user data changes
    ever(profileController.currentUser, (user) {
      name.text = user.name ?? "";
      email.text = user.email ?? "";
      phone.text = user.phoneNumber ?? "";
      about.text = user.about ?? "";
    });
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    about.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {
                authController.logoutUser();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(
                () => Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => isEdit.value
                              ? InkWell(
                                  onTap: () async {
                                    imagePath.value = await imagePickerController.pickImage();

                                    print("Image picked: ${imagePath.value}");
                                  },
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.background,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: imagePath.value == ""
                                        ? const Icon(Icons.add, size: 40)
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: profileController.currentUser.value.profileImage != null
                                        ? (profileController.currentUser.value.profileImage!.startsWith('http')
                                            ? Image.network(
                                                profileController.currentUser.value.profileImage!,
                                                fit: BoxFit.cover,
                                                height: 200,
                                                width: 200,
                                              )
                                            : Image.file(
                                                File(profileController.currentUser.value.profileImage!),
                                                fit: BoxFit.cover,
                                                height: 200,
                                                width: 200,
                                              ))
                                        : const Icon(Icons.person, size: 100),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: name,
                      enabled: isEdit.value,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person, color: Colors.white),
                        filled: true,
                        fillColor: isEdit.value ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: about,
                      enabled: isEdit.value,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "About",
                        prefixIcon: const Icon(Icons.info, color: Colors.white),
                        filled: true,
                        fillColor: isEdit.value ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.primaryContainer,
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
                    const SizedBox(height: 10),
                    TextField(
                      controller: phone,
                      enabled: isEdit.value,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        prefixIcon: const Icon(Icons.phone, color: Colors.white),
                        filled: true,
                        fillColor: isEdit.value ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryButton(
                          btnName: isEdit.value ? 'Save' : 'Edit',
                          icon: isEdit.value ? Icons.save : Icons.edit,
                          ontap: () async {
                            if (isEdit.value) {
                              // Save logic here
                              print("Saved Name: ${name.text}");
                              print("Saved About: ${about.text}");
                              // Update the user object in the controller if needed
                              await profileController.updateProfile(
                                name: name.text,
                                about: about.text,
                                imagePath: imagePath.value,
                                phoneNumber: phone.text,
                              );
                            }
                            isEdit.value = !isEdit.value;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
