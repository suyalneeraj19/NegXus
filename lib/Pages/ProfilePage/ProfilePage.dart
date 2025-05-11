import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Pages/Widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isEdit = false.obs;
    ProfileController profileController = Get.put(ProfileController());

    TextEditingController name = TextEditingController(text: profileController.currentUser.value.name);
    TextEditingController email = TextEditingController(text: profileController.currentUser.value.email);
    TextEditingController phone = TextEditingController(text: profileController.currentUser.value.phoneNumber);
    TextEditingController about = TextEditingController(text: profileController.currentUser.value.about);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
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
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          radius: 60,
                          child: const Icon(Icons.image, size: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Name (Editable)
                    TextField(
                      controller: name,
                      enabled: isEdit.value,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person, color: Colors.white),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // About (Editable, multiline)
                    TextField(
                      controller: about,
                      enabled: isEdit.value,
                      minLines: 2,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "About",
                        prefixIcon: const Icon(Icons.info, color: Colors.white),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Email (Read-only)
                    TextField(
                      controller: email,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.alternate_email, color: Colors.white),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Phone (Read-only)
                    TextField(
                      controller: phone,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        prefixIcon: const Icon(Icons.phone, color: Colors.white),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Edit / Save Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryButton(
                          btnName: isEdit.value ? 'Save' : 'Edit',
                          icon: isEdit.value ? Icons.save : Icons.edit,
                          ontap: () {
                            if (isEdit.value) {
                              // Save logic here
                              print("Saved Name: ${name.text}");
                              print("Saved About: ${about.text}");
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
