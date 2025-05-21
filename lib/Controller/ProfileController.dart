import 'dart:convert';
import 'dart:io';

import 'package:NegXus/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  Rx<UserModel> currentUser = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    try {
      final snapshot = await db.collection("users").doc(auth.currentUser!.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        currentUser.value = UserModel.fromJson(snapshot.data()!);
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  Future<void> updateProfile({
    String? name,
    String? about,
    String? phoneNumber,
    String? imagePath,
  }) async {
    isLoading.value = true;

    try {
      String? imageUrl = currentUser.value.profileImage;

      if (imagePath != null && imagePath.isNotEmpty) {
        imageUrl = await uploadImageToCloudinary(imagePath);
      }

      final updatedUser = UserModel(
        id: currentUser.value.id,
        name: name ?? currentUser.value.name,
        about: about ?? currentUser.value.about,
        phoneNumber: phoneNumber ?? currentUser.value.phoneNumber,
        profileImage: imageUrl,
        email: currentUser.value.email,
        createdAt: currentUser.value.createdAt,
        status: currentUser.value.status,
        lastOnlineStatus: DateTime.now().toIso8601String(),
      );

      await db.collection("users").doc(auth.currentUser!.uid).set(
            updatedUser.toJson(),
            SetOptions(merge: true),
          );

      currentUser.value = updatedUser;
    } catch (e) {
      print("Error updating profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Method to reset user data on logout
  void resetUserData() {
    currentUser.value = UserModel(); // Reset the current user to an empty user model
  }

  Future<String> uploadFileToCloudinary(String filePath, {required String resourceType}) async {
    const cloudName = 'dxvnxycz6';
    const uploadPreset = 'flutter_upload';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload');
    final file = File(filePath);

    final mimeType = resourceType == "audio" ? 'mpeg' : 'jpeg';

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType(resourceType, mimeType),
      ));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data['secure_url'];
    } else {
      print('Upload failed: ${res.body}');
      return '';
    }
  }

  Future<String> uploadImageToCloudinary(String imagePath) async {
    const cloudName = 'dxvnxycz6';
    const uploadPreset = 'flutter_upload';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final file = File(imagePath);

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data['secure_url'];
    } else {
      print('Upload failed: ${res.body}');
      return '';
    }
  }
}
